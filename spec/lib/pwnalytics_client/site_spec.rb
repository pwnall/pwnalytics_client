require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe PwnalyticsClient::Site do
  let(:client) { PwnalyticsClient.new integration_server_data }
  let(:site) { PwnalyticsClient::Site.new client, 'AA', 'Test'}
  
  describe 'events' do
    it 'should request all events by default' do
      client.should_receive(:request).
          with('/web_properties/AA/events.json?limit=no').and_return({})
      site.events.should be_empty
    end
    
    it 'should encode name filter if given' do
      client.should_receive(:request).
          with('/web_properties/AA/events.json?limit=no&' +
               'names%5B%5D=ab&names%5B%5D=C+D').
          and_return({})
      site.events(:names => [:ab, 'C D']).should be_empty
    end
    
    it 'should encode limit filter if given' do
      client.should_receive(:request).
          with('/web_properties/AA/events.json?limit=42').and_return({})
      site.events(:limit => 42).should be_empty
    end
    
    let(:result) do
      client.should_receive(:request).
          with('/web_properties/AA/events.json?limit=no').
          and_return([{'name' => 'page', 'referrer' => {'url' => 'null'},'data' => {},'pixels' => {'screen' => {'height' => 1440,'width' => 4240},'document' => {'height' => 863,'width' => 1680},'window' => {'x' => 2215,'y' => 181}},'id' => 1,'visitor' => {'uid' => '12f49459540.11faa9b963f5c4f0'},'page' => {'url' => 'http://localhost:3000/'},'ip' => '127.0.0.1', 'browser' => {'ua' => 'Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Ubuntu/10.10 Chromium/10.0.648.204 Chrome/10.0.648.204 Safari/534.16', 'time' => 1302682242437}},
                      {'name' => 'unload', 'referrer' => {'url' => 'null'},'data' => {},'pixels' => {'screen' => {'height' => 1440,'width' => 4240},'document' => {'height' => 863,'width' => 1680},'window' => {'x' => 2215,'y' => 181}},'id' => 2,'visitor' => {'uid' => '12f49459540.11faa9b963f5c4f0'},'page' => {'url' => 'http://localhost:3000/'},'ip' => '127.0.0.1', 'browser' => {'ua' => 'Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Ubuntu/10.10 Chromium/10.0.648.204 Chrome/10.0.648.204 Safari/534.16', 'time' => 1302682245565}}])
      site.events
    end
    
    it 'should map all results to events' do
      result.should have(2).events
    end
    
    it 'should map events correctly' do
      result.first.name.should == 'page'
      result.first.site.should == site
      result.last.name.should == 'unload'
      result.last.site.should == site
    end
  end
end
