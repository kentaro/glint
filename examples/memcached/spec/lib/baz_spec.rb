require 'spec_helper'

describe 'baz' do
  include_context 'memcached'
  before { client.set('test_baz', 'value') }
  it { expect(client.get('test_baz')).to be == 'value' }
end
