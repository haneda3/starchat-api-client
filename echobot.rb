# encoding: utf-8
require './starchatapiclient'
require 'yaml'

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
        if b['type'] == 'message'
          message = b['message']
          if message['notice'] == false
            s.post_comment(message['channel_name'], message['body'])
          end
        end
      end
    end
  rescue Timeout::Error
  end
end
