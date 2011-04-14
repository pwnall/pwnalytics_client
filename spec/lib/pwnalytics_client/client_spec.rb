require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe PwnalyticsClient do
  describe 'with good data' do
    let(:client) { PwnalyticsClient.new integration_server_data }
    
    describe 'request with good data' do
      let(:response) { client.request '/web_properties.json' }


      it 'should return an array' do
        response.should_not be_empty
      end
      
      let(:js_test) { response.find { |site| site['uid'] == 'AA123456' }}
      
      it 'should return the test site' do
        js_test.should_not be_nil
        js_test['name'].should == 'Pwnalytics itself'
      end
    end
    
    it 'should report the server hostname' do
      client.host.should == integration_server_data[:host]
    end
    it 'should report the server port' do
      client.port.should == integration_server_data[:port]
    end
    it 'should report whether it uses SSL' do
      client.ssl.should == integration_server_data[:ssl]
    end
    
    let(:sites) { client.sites }

    describe 'sites' do
      it 'should have at least one entry' do
        sites.should_not be_empty
      end
    end
    
    describe 'site' do
      let(:uid) { sites.first.uid }
      
      it 'should get data matching the sites call' do
        client.site(uid).name.should == sites.first.name
      end
    end
  end

  describe 'with bad credentials' do
    let(:client) do
      PwnalyticsClient.new integration_server_data.merge(:user => 'nouser')
    end
    
    it 'should raise an exception on request with good data' do
      lambda {
        client.request '/web_properties.json'
      }.should raise_error
    end
  end

  describe 'with a bad server' do
    let(:client) do
      PwnalyticsClient.new integration_server_data.merge(:host => 'nohost')
    end
    
    it 'should raise an exception on request with good data' do
      lambda {
        client.request '/web_properties.json'
      }.should raise_error
    end
  end
  
  describe 'sites' do
    let(:client) { PwnalyticsClient.new integration_server_data }
    
    let(:result) do
      client.should_receive(:request).with('/web_properties.json').
          and_return([{'uid' => 'AA123456', 'name' => 'Pwnalytics itself'},
                      {'uid' => 'CDCDCDCD', 'name' => 'Test Property'}])
      client.sites
    end
    
    it 'should map all items in the response' do
      result.should have(2).sites 
    end
    
    let(:js_test) { result.first }
    it 'should map the test site correctly' do
      js_test.client.should == client
      js_test.uid.should == 'AA123456'
      js_test.name.should == 'Pwnalytics itself'
    end
  end
  
  describe 'site' do
    let(:client) { PwnalyticsClient.new integration_server_data }
    
    let(:site) do
      client.should_receive(:request).with('/web_properties/AA123456.json').
          and_return({'uid' => 'AA123456', 'name' => 'Pwnalytics itself'})
      client.site 'AA123456'
    end
    
    it 'should parse the response correctly' do
      site.client.should == client
      site.uid.should == 'AA123456'
      site.name.should == 'Pwnalytics itself'
    end
  end
end
