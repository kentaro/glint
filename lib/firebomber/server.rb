require_relative 'util.rb'

module Firebomber
  class Server
    attr_accessor :port, :block, :pid, :child_pid

    def initialize(port = nil, opts = {}, &block)
      unless block_given?
        raise ArgumentError.new('block is not given')
      end

      @port  = port || Util.empty_port
      @block = block
      @pid   = Process.pid

    end

    def start
      self.child_pid = fork do
        block.call(port)
        exit 0
      end

      ObjectSpace.define_finalizer(self) { stop }
      Firebomber::Util.wait_port(port)
    end

    def stop
      if self.child_pid
        Process.kill(:TERM, child_pid)
        Process.waitpid(child_pid)
        child_pid = nil
      end
    end
  end
end
