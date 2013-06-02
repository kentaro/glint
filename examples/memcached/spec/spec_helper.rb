$LOAD_PATH.unshift '../../lib'

require 'glint'
Dir[File.expand_path("../servers/*.rb", __FILE__)].each do |f|
  require f
end

require 'rspec'
shared_context 'memcached' do
  require 'dalli'
  let(:client) {
    Dalli::Client.new(Glint::Server.info[:memcached])
  }
end
