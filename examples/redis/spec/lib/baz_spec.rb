require 'spec_helper'

describe 'baz' do
  include_context 'redis'
  before { client.set('test_baz', 'value') }
  it { expect(client.get('test_baz')).to be == 'value' }
end
