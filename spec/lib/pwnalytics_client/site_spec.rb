require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe PwnalyticsClient::Site do
  let(:client) { PwnalyticsClient.new integration_server_data }
  let(:site) { PwnalyticsClient::Site.new client, 'AA', 'Test'}
  
  describe 'events' do
    it 'should request all events by default' do
      client.should_receive(:request).
          with('/web_properties/AA/events.json?').and_return({})
      site.events.should be_empty
    end
    
    it 'should encode name filter if given' do
      client.should_receive(:request).
          with('/web_properties/AA/events.json?names%5B%5D=AB&names%5B%5D=C+D').
          and_return({})
      site.events(:names => ['AB', 'C D']).should be_empty
    end
    
    let(:result) do
      client.should_receive(:request).with('/web_properties/AA/events.json?').
          and_return([{'uid' => 'AA123456', 'name' => 'Pwnalytics itself'},
                      {'uid' => 'CDCDCDCD', 'name' => 'Test Property'}])
      site.events
    end
    
  end
end
