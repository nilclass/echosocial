ApiConf = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', 'api.yml')).symbolize_keys.freeze

$config = {
  :host => ApiConf[:host],
  :port => ApiConf[:port],
  :auth_info => {
    :method => 'key',
    :key => ApiConf[:key]
  },
  :log_level => 'INFO'
}

ApiSwitch::API.use do |api|
  puts "USERS:"
  api[:echologic].users
end

