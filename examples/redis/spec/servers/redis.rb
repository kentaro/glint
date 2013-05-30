server = Glint::Server.new do |port|
  # `--port` option is available since version 2.6
  exec 'redis-server', '--port', port.to_s
  exit 0
end
server.on_stopped = ->(s) { puts 'redis stopped!' }
server.start

Glint::Server.info[:redis] = {
  host: "127.0.0.1",
  port: server.port,
}
