require_relative '../../spec_helper'

module Glint
  describe Server do
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
      before { server.start }

      it {
        expect(server.child_pid).to be_true
      }
    end

    describe '#stop' do
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
  end
end
