#!/usr/bin/env ruby

require 'socket'

server = TCPServer.new(ARGV[0])
server.accept
