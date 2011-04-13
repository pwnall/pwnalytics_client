require 'json'
require 'net/http'
require 'net/https'
require 'uri'


# Information about connecting to a Pwnalytics server.
class PwnalyticsClient
  # New client connection to a Pwnalytics server.
  #
  # The options argument supports the following keys:
  #    :host:: the server hostname (e.g. "ticks.pwnb.us")
  #    :port:: the server port (defaults to 80 for http, 443 for https)
  #    :user:: the account username (e.g. "config")
  #    :password:: the account passowrd (e.g. "vars")
  #    :ssl:: if true, https will be used; make sure to populate the relevant
  #           net_http options (at the very least, you need ca_file or ca_path)
  #    :net_http:: properties to be set on the Net::HTTP connection object
  def initialize(options)
    unless @host = options[:host]
      raise InvalidArgumentError, 'Missing server hostname'
    end
    unless @user = options[:user]
      raise InvalidArgumentError, 'Missing account username'
    end
    unless @password = options[:password]
      raise InvalidArgumentError, 'Missing account password'
    end
    @ssl = options[:ssl] ? true : false
    @port = options[:port] || (@ssl ? 443 : 80)
    @net_http = options[:net_http] || {}
  end
  
  # Pwnalytics server hostname.
  attr_reader :host
  
  # Pwnalytics server port.
  attr_reader :port
  
  # True if the connection to the Pwnalytics server is secured with SSL.
  attr_reader :ssl
  
  # Issues a low-level request to the Pwnalytics server, parses the JSON.
  #
  # Args:
  #   request:: the low-level request, e.g. '/web_properties.json'
  #
  # Returns the parsed JSON, as a Hash or Array.
  #
  # Raises IOError if the server's response indicates HTTP error.
  def request(request)
    http_request = Net::HTTP::Get.new request
    http_request.initialize_http_header 'User-Agent' => 'Pwnalytics Client Gem'
    http_request.basic_auth @user, @password

    http = Net::HTTP.new @host, @port
    if @ssl
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end
    @net_http.each { |key, value| http.send :"#{key}=", value }
    response = http.request http_request
    unless response.kind_of? Net::HTTPSuccess
      raise IOError, "Unhappy HTTP response: #{response}\n"
    end
    
    JSON.parse response.body
  end
  
  # Returns an array of all Sites on this server.
  def sites
    request('/web_properties.json').map do |site|
      Site.new self, site['uid'], site['name']
    end
  end
  
  # Returns the Site with the given UID.
  #
  # This method does a server request, to get additional property data.
  def property(uid)
    request('/web_property/#{uid}.json').map do |site|
      Site.new self, site['uid'], site['name']
    end
  end
end  # class PwnalyticsClient
