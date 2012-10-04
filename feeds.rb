# encoding: utf-8
require 'sinatra'
require 'json'
require 'net/http'
require 'active_support/core_ext'

feeds = {"twblogs" => 'http://www.thoughtworks.com/blogs/rss/current',
  "ilm" => 'http://feeds.feedburner.com/ILoveMadras?format=xml',
  "ycombinator" => "http://news.ycombinator.com/rss",
  "google" => "http://feeds.feedburner.com/blogspot/MKuf"}

def thoughtblogs_rss(feed_url)
  s = Net::HTTP.get_response(URI.parse(feed_url)).body
  Hash.from_xml(s).to_json
end


get '/latest.json/:name' do
  content_type :json
  puts feeds[params[:name]]
  thoughtblogs_rss feeds[params[:name]]
end

get '/supported.json' do
  content_type :json
  feeds.to_json
end