# encoding: utf-8
require 'rubygems'
require 'net/http'
require 'uri'
require 'json'

class StarChatApiClient
  def initialize(url, username, password)
    @url = url
    @username = username
    @password = password
  end
  
  def enc(str)
    URI.encode_www_form_component(str)
  end
  
  def get_user()
    Net::HTTP.start(@url) do |http|
      req = Net::HTTP::Get.new('/users/' + enc(@username));
      req.basic_auth(@username, @password)
      JSON.parse(http.request(req).read_body)
    end
  end
  
  def get_channels()
    Net::HTTP.start(@url) do |http|
      req = Net::HTTP::Get.new('/users/' + enc(@username) + '/channels');
      req.basic_auth(@username, @password)
      JSON.parse(http.request(req).read_body)
    end
  end
  
  def get_channel(channel)
    Net::HTTP.start(@url) do |http|
      req = Net::HTTP::Get.new('/channels/' + enc(channel));
      req.basic_auth(@username, @password)
      JSON.parse(http.request(req).read_body)
    end
  end
  
  def get_users(channel)
    Net::HTTP.start(@url) do |http|
      req = Net::HTTP::Get.new('/channels/' + enc(channel) + '/users');
      req.basic_auth(@username, @password)
      JSON.parse(http.request(req).read_body)
    end
  end
  
  def subscribe_channel(channel)
    Net::HTTP.start(@url) do |http|
      req = Net::HTTP::Put.new("/subscribings?user_name=" + enc(@username) + ";channel_name=" + enc(channel));
      req.basic_auth(@username, @password)
      res = http.request(req, "")
    end
  end
  
  def unsubscribe_channel(channel)
    Net::HTTP.start(@url) do |http|
      req = Net::HTTP::Delete.new("/subscribings?user_name=" + enc(@username) + ";channel_name=" + enc(channel));
      req.basic_auth(@username, @password)
      res = http.request(req)
    end
  end
  
  def post_comment(channel, comment)
    Net::HTTP.start(@url) do |http|
      req = Net::HTTP::Post.new('/channels/' + enc(channel) + '/messages');
      req.basic_auth(@username, @password)
      s = "body=" + enc(comment) + ";notice=true";
      res = http.request(req, s)
    end
  end
  
  def get_stream(&block)
    Net::HTTP.start(@url) do |http|
      req = Net::HTTP::Get.new('/users/' + enc(@username) + '/stream');
      req.basic_auth(@username, @password)
      http.request(req) do |res|
        txt = ""
        res.read_body do |body|
          body.each_line {|line|
            next if line == "\n" # bypass return code
            
            line = txt + line if txt != ""
            
            begin
              block.call(JSON.parse(line))
              txt = ""
            rescue JSON::ParserError
              txt += line
            end
          }
        end
      end
    end
  end
end


