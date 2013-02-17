require 'socket'

module Firebomber
  module Util
    def self.empty_port
      s = TCPServer.open(0)
      port = s.addr[1]
      s.close
      port
    end

    def self.check_port(port)
      begin
        socket = TCPSocket.open('127.0.0.1', port)
        socket.close
        return true
      rescue Errno::ECONNREFUSED
        return false
      end
    end

    def self.wait_port(port)
      100.times do |n|
        return true if check_port(port)
        sleep 0.1
      end

      raise RuntimeError.new("Could not open the port: #{port}")
    end
  end
end
