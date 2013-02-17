require_relative '../../spec_helper'

module Glint
  describe Util do
    describe '.empty_port' do
      let(:port) { Glint::Util.empty_port }

      it {
        expect(port).to be_an_instance_of(Fixnum)
      }
    end
  end
end
