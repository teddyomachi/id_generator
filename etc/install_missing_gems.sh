#!/bin/bash --
mydir=`dirname $0`
bundle install --gemfile $mydir/../Gemfile
gem update
gem clean
bundle update
bundle install

