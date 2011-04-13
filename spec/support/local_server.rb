# Connection details for the local server used in tests.
def integration_server_data
  { :host => 'localhost', :port => 3000, :ssl => false,
    :user => 'config', :password => 'vars' }
end
