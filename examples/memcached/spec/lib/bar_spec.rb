require 'spec_helper'

describe 'bar' do
  include_context 'memcached'
  before { client.set('test_bar', 'value') }
  it { expect(client.get('test_bar')).to be == 'value' }
end
