#!/usr/bin/env ruby

$:.unshift(File.dirname(__dir__))

print $:[0], "\n"

require 'tasks/security'

if ARGV.length < 4
  print "Please specify 4 numbers!\n"
  return
end

print Security.hash_key(ARGV[0], ARGV[1], ARGV[2], ARGV[3]), "\n"
