require_relative '../../spec_helper'

module Firebomber
  describe Util do
    describe '.empty_port' do
      let(:port) { Firebomber::Util.empty_port }

      it {
        expect(port).to be_an_instance_of(Fixnum)
      }
    end
  end
end
