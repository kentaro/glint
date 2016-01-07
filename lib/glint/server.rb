require_relative 'util.rb'
require "timeout"

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
      @opts  = { timeout: 1, signals: [:TERM, :INT, :KILL] }.merge(opts)
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
        signals = @opts[:signals].clone
        begin
          Process.kill(signals.shift, child_pid)
          Timeout.timeout(@opts[:timeout]) do
            Process.waitpid(child_pid)
          end
        rescue Timeout::Error => e
          retry
        end
        self.child_pid = nil
        on_stopped && on_stopped.call(self)
      end
    end
  end
end
