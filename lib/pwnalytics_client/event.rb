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
    
    
  end
  
  # PwnalyticsClient::Site that the event occured on.
  attr_reader :site
  # Pwnalytics UID for the site.
  attr_reader :uid
  # User-friendly name for the site
  attr_reader :name
  
end  # class PwnalyticsClient::Event
  
end  # namespace PwnalyticsClient
