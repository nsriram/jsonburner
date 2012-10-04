# encoding: utf-8
require 'sinatra'
require 'json'
require 'net/http'
require 'net/https'
require 'active_support/core_ext'

configure do
  set :protection, :except => :json_csrf
end

feeds = { "twblogs" => 'http://www.thoughtworks.com/blogs/rss/current',
  "ilm" => 'http://feeds.feedburner.com/ILoveMadras?format=xml',
  "ycombinator" => "http://news.ycombinator.com/rss",
  "google" => "http://feeds.feedburner.com/blogspot/MKuf",
  "cricinfo" => "http://www.espncricinfo.com/rss/content/story/feeds/0.xml",
  "nytimes" => "http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml",
  "amazon-blu-ray" => "http://www.amazon.com/rss/tag/blu-ray/new/ref=tag_rsh_hl_ersn",
  "oiga" =>'https://oiga.me/campaigns/feed'
}

def jsonify(feed_url)
  uri = URI.parse(feed_url)
  http = Net::HTTP.new(uri.host, uri.port)
  if uri.scheme == 'https' 
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true 
  end
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  s = response.body
  Hash.from_xml(s).to_json
end

get '/latest/:name' do
  if !feeds[params[:name]]
      content_type 'text/html'
      return "<h1>Feed Not Supported</h1>"
  end
  content_type 'application/json;charset=utf-8'
  jsonify feeds[params[:name]]
end

get '/source' do
  content_type 'application/json;charset=utf-8'
  jsonify params[:feed]
end

get '/supported' do
  content_type :json
  feeds.to_json
end