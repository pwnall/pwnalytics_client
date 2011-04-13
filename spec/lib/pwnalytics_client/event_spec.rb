require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe PwnalyticsClient::Event do
  let(:json_data) do
    {'name' => 'page', 'referrer' => {'url' => 'http://google.com/'},'data' => {'pixie' => 'dust'},'pixels' => {'screen' => {'height' => 1440,'width' => 4240},'document' => {'height' => 863,'width' => 1680},'window' => {'x' => 2215,'y' => 181}},'id' => 1,'visitor' => {'uid' => '12f49459540.11faa9b963f5c4f0'},'page' => {'url' => 'http://localhost:3000/'},'ip' => '127.0.0.1', 'browser' => {'ua' => 'Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Ubuntu/10.10 Chromium/10.0.648.204 Chrome/10.0.648.204 Safari/534.16', 'time' => 1302682242437}}
  end
  let(:client) { PwnalyticsClient.new integration_server_data }
  let(:site) { PwnalyticsClient::Site.new client, 'AA', 'Test'}
  let(:event) { PwnalyticsClient::Event.new site, json_data }

  it 'should report the Pwnalytics site' do
    event.site.should == site
  end
  
  it 'should parse out the name' do
    event.name.should == 'page'
  end
  
  it 'should parse out the page URL' do
    event.url.should == URI.parse('http://localhost:3000/')
  end

  it 'should parse out the referrer URL' do
    event.ref.should == URI.parse('http://google.com/')
  end
  
  it 'should parse out null URLs' do
    PwnalyticsClient::Event.new(site, json_data.
        merge('page' => { 'url' => 'null'})).url.should == nil
    PwnalyticsClient::Event.new(site, json_data.
        merge('page' => {})).url.should == nil
    PwnalyticsClient::Event.new(site, json_data.
        merge('page' => nil)).url.should == nil
  end
  
  it 'should parse out the time' do
    event.time.gmtime.to_s.should == "Wed Apr 13 08:10:42 UTC 2011"
  end
  
  it 'should parse out the IP' do
    event.ip.should == '127.0.0.1'
  end
  
  it 'should parse out the User-Agent string' do
    event.browser_ua.should match(/WebKit/)
  end
  
  it 'should parse screen metric data' do
    event.pixels.screen.width.should == 4240
    event.pixels.screen.height.should == 1440
    event.pixels.document.width.should == 1680
    event.pixels.document.height.should == 863
    event.pixels.window.x.should == 2215
    event.pixels.window.y.should == 181
  end

  it 'should parse out additional data' do
    event.data.should eq({'pixie' => 'dust'})
  end
  
  it 'should have syntactic sugar on the additional data' do
    event.data.pixie.should == 'dust'
  end
end
