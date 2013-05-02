require 'rubygems'
require 'bundler'

Bundler.require

require File.expand_path(File.dirname(__FILE__) + '/app')

run Sinatra::Application
