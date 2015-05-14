require 'rubygems'
require 'bundler'
require 'roar-sinatra'

%w(
  active_support
  rest-client
  net/http
  uri
  hyperclient
  hyperresource
  data_mapper
  dm-migrations
  active_record
  active_support
  kramdown
  newrelic_rpm
  nokogiri
  pg
  roar/json
  roar/json/hal
  sinatra
  sinatra/asset_pipeline
  sinatra/flash
  sinatra/static_assets
  sinatra/redirect_with_flash
  slim
  sprockets
  sprockets-helpers
  sprockets-sass
  ostruct
  yui/compressor
).each { |d| require d }

#$env = ENV['RACK_ENV']
# Bundler.require :default, $env.to_sym
# You probably should not do that.
# See http://myronmars.to/n/dev-blog/2012/12/5-reasons-to-avoid-bundler-require

enable :sessions
#use Rack::Flash, :sweep => true

def reset_representer(*module_name)
  module_name.each do |mod|
    mod.module_eval do
      @representable_attrs = nil
    end
  end
end

helpers do
    include Rack::Utils
    alias_method :h, :escape_html
end

SITE_TITLE = "Blendle Memo's"
SITE_DESCRIPTION = "''Heb je memo's altijd bij de hand, wanneer het schikt ;-)"

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/test_db.db")

