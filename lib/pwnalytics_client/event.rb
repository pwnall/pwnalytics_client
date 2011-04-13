# :nodoc: namespace
class PwnalyticsClient

# Information about an event logged on a Pwnalytics server.
class Event
  # New wrapper for a site on a Pwnalytics server.
  #
  # This is called automatically by PwnalyticsClient in #sites and #site.
  #
  # Args:
  #   site:: the PwnalyticsClient::Site that the event occured on
  #   json_data:: a Hash containing parsed JSON data representing the event
  def initialize(site, json_data)
    @site = site
    
    @name = json_data['name']
    @url = self.class.parse_url json_data['page']
    @ref = self.class.parse_url json_data['page']
    if json_data['browser'] && json_data['browser']['time']
      @time = Time.at(json_data['browser']['time'] / 1000.0)
    else
      @time = nil
    end
    @data = json_data['data']
  end
  
  # PwnalyticsClient::Site that the event occured on.
  attr_reader :site
  
  # Event name used for filtering in queries.
  attr_reader :name
  # URL of the page where the event was triggerred.
  attr_reader :url
  # Referer URL for the page where the event was triggerred.
  attr_reader :ref
  # When the event was triggerred.
  attr_reader :time
  # User-defined data associated with the event.
  attr_reader :data
  
  # Parses an URL out of a Pwnalytics server response.
  def self.parse_url(json_data)
    if json_data && json_data['url']
      URI.parse json_data['url']
    else
      nil
    end
  end
end  # class PwnalyticsClient::Event
  
end  # namespace PwnalyticsClient
