# encoding: utf-8
require 'sinatra'
require 'json'
require 'net/http'
require 'active_support/core_ext'

def thoughtblogs_rss
  s = Net::HTTP.get_response(URI.parse('http://www.thoughtworks.com/blogs/rss/current')).body
  Hash.from_xml(s).to_json
end


get '/latest.json' do
  content_type :json
  thoughtblogs_rss  
end