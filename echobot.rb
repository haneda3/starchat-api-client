# encoding: utf-8
require './starchatapiclient'
require 'yaml'

setting = YAML.load_file('./config.yaml')
test_channel = setting['test_channel']

s = StarChatApiClient.new(setting['host'], setting['username'], setting['password'])

p "=== subscribe_channel ==="
s.subscribe_channel(test_channel)

p "=== get_stream ==="
s.get_stream do |body|
  p body
  if body['type'] == 'message'
    message = body['message']
    if message['notice'] == false
      s.post_comment(message['channel_name'], message['body'])
    end
  end
end

