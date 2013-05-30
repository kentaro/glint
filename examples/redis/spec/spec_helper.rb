$LOAD_PATH.unshift '../../lib'

require 'glint'
Dir[File.expand_path("../servers/*.rb", __FILE__)].each {|f| require f}

require 'rspec'
shared_context 'redis' do
  require 'redis'
  let(:client) {
    Redis.new(
      host: Glint::Server.info[:redis][:host],
      port: Glint::Server.info[:redis][:port]
    )
  }
end

RSpec.configure do |config|
end
