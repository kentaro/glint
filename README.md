# Glint [![BuildStatus](https://secure.travis-ci.org/kentaro/glint.png)](http://travis-ci.org/kentaro/glint)

Glint is a library which allows you to fire arbitrary TCP server processes programatically and ensures the processes are shutdown when your code exit.

It's useful when you want to test your code against real TCP server processes.

## Usage

```ruby
server = Glint::Server.new do |port|
  # Execute target server process
  exec command, args
end
server.start

# Test your code against the server process
client = MyClient.new('127.0.0.1', server.port)
client.do_something

exit
# The process executed above will be shutdown here.
```

## Installation

Add this line to your application's Gemfile:

    gem 'glint'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install glint

## See Also

  * [Test::TCP](https://metacpan.org/module/Test::TCP)
    * This library is a port of Test::TCP for Perl.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
