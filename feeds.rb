# encoding: utf-8
require 'sinatra'
require 'json'
require 'net/http'
require 'active_support/core_ext'

feeds = {"twblogs" => 'http://www.thoughtworks.com/blogs/rss/current',
  "ilm" => 'http://feeds.feedburner.com/ILoveMadras?format=xml',
  "ycombinator" => "http://news.ycombinator.com/rss",
  "google" => "http://feeds.feedburner.com/blogspot/MKuf",
  "cricinfo" => "http://www.espncricinfo.com/rss/content/story/feeds/0.xml",
  "nytimes" => "http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml",
  "amazon-blu-ray" => "http://www.amazon.com/rss/tag/blu-ray/new/ref=tag_rsh_hl_ersn"}

def thoughtblogs_rss(feed_url)
  s = Net::HTTP.get_response(URI.parse(feed_url)).body
  Hash.from_xml(s).to_json
end

get '/latest/:name' do
  if !feeds[params[:name]]
      content_type 'text/html'
      return "<h1>Feed Not Supported</h1>"
  end
  content_type :json
  puts feeds[params[:name]]
  thoughtblogs_rss feeds[params[:name]]
end

get '/supported' do
  content_type :json
  feeds.to_json
end