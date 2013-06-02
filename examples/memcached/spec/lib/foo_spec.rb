require 'spec_helper'

describe 'foo' do
  include_context 'memcached'

  before {
    client.set('test_foo', 'value')
  }

  it {
    expect(client.get('test_foo')).to be == 'value'
  }
end
