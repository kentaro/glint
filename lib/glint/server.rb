require_relative 'util.rb'

module Glint
  class Server
    attr_accessor :port, :block, :pid, :child_pid, :on_stopped

    def self.info
      @@info ||= {}
    end

    def initialize(port = nil, opts = {}, &block)
      unless block_given?
        raise ArgumentError.new('block is not given')
      end

      @port  = port || Util.empty_port
      @block = block
      @pid   = Process.pid

      ObjectSpace.define_finalizer(self) { stop }
    end

    def start
      self.child_pid = fork do
        block.call(port)
        exit 0
      end

      Util.wait_port(port)
      self
    end

    def stop
      if pid == Process.pid && child_pid
        Process.kill(:TERM, child_pid)
        Process.waitpid(child_pid)
        self.child_pid = nil
        on_stopped && on_stopped.call(self)
      end
    end
  end
end
