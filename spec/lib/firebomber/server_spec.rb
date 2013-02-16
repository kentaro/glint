require_relative '../../spec_helper'

module Firebomber
  describe Server do
    describe '.new' do
      context 'when block is given' do
        context 'and a port is passed in' do
          let(:server) { Firebomber::Server.new(65535) { 'dummy' } }

          it {
            expect(server).to be_an_instance_of(Firebomber::Server)
            expect(server.port).to be == 65535
            expect(server.block).to be_an_instance_of(Proc)
          }
        end

        context 'and a port is not passed in' do
          let(:server) { Firebomber::Server.new  { 'dummy' } }

          it {
            expect(server).to be_an_instance_of(Firebomber::Server)
            expect(server.port).to be_an_instance_of(Fixnum)
            expect(server.block).to be_an_instance_of(Proc)
          }
        end
      end

      context 'when block is not given' do
        context 'and a port is passed in' do
          it {
            expect {
              Firebomber::Server.new(65535)
            }.to raise_error(ArgumentError)
          }
        end

        context 'and a port is not passed in' do
          it {
            expect {
              Firebomber::Server.new
            }.to raise_error(ArgumentError)
          }
        end
      end
    end

    describe '#start' do
      let(:server) {
        Firebomber::Server.new do |port|
          exec File.expand_path("../../../bin/server.rb", __FILE__), port.to_s
        end
      }
      before { server.start }

      it {
        expect(server.child_pid).to be_true
      }
    end
  end
end
