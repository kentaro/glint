require_relative '../../spec_helper'

module Glint
  describe Server do
    describe '.info' do
      context 'when no info set' do
        it { expect(Glint::Server.info).to be == {} }
      end

      context 'when a value via the method' do
        before {
          Glint::Server.info['foo'] = 'bar'
          Glint::Server.info['baz'] = 'qux'
        }

        it {
          expect(Glint::Server.info).to be == {
            'foo' => 'bar',
            'baz' => 'qux',
          }
        }
      end
    end

    describe '.new' do
      context 'when block is given' do
        context 'and a port is passed in' do
          let(:server) { Glint::Server.new(65535) { 'dummy' } }

          it {
            expect(server).to be_an_instance_of(Glint::Server)
            expect(server.port).to be == 65535
            expect(server.block).to be_an_instance_of(Proc)
          }
        end

        context 'and a port is not passed in' do
          let(:server) { Glint::Server.new  { 'dummy' } }

          it {
            expect(server).to be_an_instance_of(Glint::Server)
            expect(server.port).to be_an_instance_of(Fixnum)
            expect(server.block).to be_an_instance_of(Proc)
          }
        end
      end

      context 'when block is not given' do
        context 'and a port is passed in' do
          it {
            expect {
              Glint::Server.new(65535)
            }.to raise_error(ArgumentError)
          }
        end

        context 'and a port is not passed in' do
          it {
            expect {
              Glint::Server.new
            }.to raise_error(ArgumentError)
          }
        end
      end
    end

    describe '#start' do
      let(:server) {
        Glint::Server.new do |port|
          exec File.expand_path("../../../bin/server.rb", __FILE__), port.to_s
        end
      }

      it {
        expect(server.start).to equal(server)
        expect(server.child_pid).to be_true
      }
    end

    describe '#stop' do
      context "when normal process" do
        let(:server) {
          server = Glint::Server.new do |port|
            exec File.expand_path("../../../bin/server.rb", __FILE__), port.to_s
          end
          server.start
          server
        }
        let(:child_pid) { server.child_pid }

        before { server.stop }

        it {
          expect(server.child_pid).to be_nil
        }
      end

      context "when process which traps SIGTERM" do
        let(:server) {
          server = Glint::Server.new(nil, { timeout: 0.1 }) do |port|
            require "socket"
            Signal.trap(:SIGTERM) { }
            server = TCPServer.new(port)
            1 while server.accept
          end
          server.start
          server
        }
        let(:child_pid) { server.child_pid }

        before { server.stop }

        it {
          expect(server.child_pid).to be_nil
        }
      end

      context "when process which traps SIGTERM and SIGINT" do
        let(:server) {
          server = Glint::Server.new(nil, { timeout: 0.1 }) do |port|
            require "socket"
            Signal.trap(:SIGTERM) { }
            Signal.trap(:SIGINT) { }
            server = TCPServer.new(port)
            1 while server.accept
          end
          server.start
          server
        }
        let(:child_pid) { server.child_pid }

        before { server.stop }

        it {
          expect(server.child_pid).to be_nil
        }
      end
    end

    describe '#on_stopped' do
      let!(:result) { false }
      let(:server) {
        server = Glint::Server.new do |port|
          exec File.expand_path("../../../bin/server.rb", __FILE__), port.to_s
        end
        server.start
        server
      }

      context 'when `on_stopped` is set' do
        before {
          server.on_stopped = ->(s) {
            s.instance_variable_set(:@_stopped, true)
          }
          server.stop
        }

        it {
          expect(server.instance_variable_get(:@_stopped)).to be true
        }
      end

      context 'when `on_stopped` is not set' do
        before {
          server.stop
        }

        it {
          expect(server.instance_variable_get(:@_stopped)).to be nil
        }
      end
    end
  end
end
