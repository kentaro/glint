server = Glint::Server.new do |port|
  exec '/usr/bin/memcached', '-p', port.to_s;
  exit 0
end
server.on_stopped = ->(s) { puts 'memcached stopped!' }
server.start

Glint::Server.info[:memcached] = "127.0.0.1:#{server.port}"
