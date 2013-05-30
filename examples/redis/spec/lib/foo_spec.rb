require 'spec_helper'

describe 'foo' do
  include_context 'redis'
  before { client.set('test_foo', 'value') }
  it { expect(client.get('test_foo')).to be == 'value' }
end
