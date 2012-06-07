# encoding: utf-8
require './starchatapiclient'
require 'yaml'

setting = YAML.load_file('./config.yaml')
test_channel = setting['test_channel']

s = StarChatApiClient.new(setting['host'], setting['username'], setting['password'])

p "=== get_user ==="
p s.get_user()

p "=== get_channels / get_channel / get_users ==="
channels = s.get_channels()
channels.each do |channel|
  p s.get_channel(channel['name'])
  p s.get_users(channel['name'])
end

p "=== subscribe_channel ==="
s.subscribe_channel(test_channel)

p "=== post_comment ==="
s.post_comment(test_channel, "コメントcomment\n1234567890")

p "=== unsubscribe_channel ==="
s.unsubscribe_channel(test_channel)

