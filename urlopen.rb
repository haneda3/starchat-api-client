# encoding: utf-8
require './starchatapiclient'
require 'yaml'
require 'mechanize'

setting = YAML.load_file('./config.yaml')
test_channel = setting['test_channel']

s = StarChatApiClient.new(setting['host'], setting['username'], setting['password'])

p "=== subscribe_channel ==="
s.subscribe_channel(test_channel)

p "=== get_stream ==="
while true
  begin
    s.get_stream do |res|
      res.read_body do |body|
        b = JSON.parse(body)
        
        next if b['type'] != 'message'
        
        message = b['message']
        
        next if message['notice'] != false
        
        if message['body'] =~ /((http|https):\/\/.*)/ then
          agent = Mechanize.new
          agent.get($1)
          p agent.page.title
          s.post_comment(message['channel_name'], "【URL】" + agent.page.title)
        end
      end
    end
  rescue Timeout::Error
    p 'Timeout::Error'
  rescue JSON::ParserError
    p 'Json::ParserError'
  end
end
