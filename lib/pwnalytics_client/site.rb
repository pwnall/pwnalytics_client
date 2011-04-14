require 'cgi'

# :nodoc: namespace
class PwnalyticsClient

# Information about a site on a Pwnalytics server.
class Site
  # New wrapper for a site on a Pwnalytics server.
  #
  # This is called automatically by PwnalyticsClient in #sites and #site.
  #
  # Args:
  #   client:: the PwnalyticsClient connection to be used for queries
  #   uid:: site's Pwnalytics UID
  #   name:: site's user-friendly name (optional)
  def initialize(client, uid, name = 'unknown')
    @client = client
    @uid = uid
    @name = name
  end
  
  # PwnalyticsClient connection used for queries.
  attr_reader :client
  # Pwnalytics UID for the site.
  attr_reader :uid
  # User-friendly name for the site
  attr_reader :name
  
  # Queries the Pwnalytics server for events matching some criteria.
  #
  # Options supports the following keys:
  #     :names:: only get events whose names are contained in this array
  #     :limit:: return the first events matching the criteria
  #
  # Events will be resturned in the reverse order of their occurrence.
  def events(options = {})
    request = "/web_properties/#{@uid}/events.json?"
    request << "limit=#{options[:limit] || 'no'}"
    
    if options[:names]
      request << options[:names].
          map { |name| '&names%5B%5D=' + CGI.escape(name.to_s) }.join('')
    end
    @client.request(request).map { |data| Event.new self, data }
  end
end  # class PwnalyticsClient::Site
  
end  # namespace PwnalyticsClient
