# encoding: utf-8
require './starchatapiclient'
require 'yaml'

SUMAHO = <<"SUMAHO"
  ＼　　　/　.::::::::::::::::::::::::;;:;;::,ｯ､::::::　　 )　　く 　 ホ 　す
　 ＼　l　 ,ｯｨrj,rｆ'"'"'"　　　 lﾐ:::::::　く　　 れ　 モ　 ま
　　　　 Y　　　　　　　　　　 ,!ﾐ:::::::　ヽ　　な　 以　 な
｀ヽ､　　|　　　　　　　　　　 くミ::::::::　ﾉ 　 い　 外　 い
　　　　 |､__　 ｬー--＿ニゞ　｀i::::,rく　　　か　 は
｀`''ｰ-　ゝ､'ｌ　 ￣ﾞ´彑,ヾ　　　}::;! ,ﾍ.）　　！　 帰
　　　　　 ﾞｿ　　　""""´｀　　　　　〉 L_　 　 　 っ
　　　　　 /　　　　　　　　　　i　　,　　/|　　　　て　　　　r
≡＝-　〈´　,,.._　　　　　　　 i　　't-'ﾞ　|　,へ　　　　　,r┘
,､yx=''"　｀ｰ{ﾞ　＿, -､　　　　;　　l　　　ﾚ'　　ヽr､⌒ヽ'
　　　　　　　 ﾞ､`--─ﾞ　　　　　 /!　　　　　　　　 `､
　　_,,､-　　 　 ﾞ､ ー''　　　　／　;　　　　　　　　　　 `､
-''"_,,､-''"　　　 ﾞ､　　　　／;;'　,'　　/　　　　　　　　 、＼
-''"　　　 ／　　　`ｰ─''ぐ;;;;' ,'　　ノ
　　 ／／　　　 /　　　　　ヾ_､=ﾆﾞ

SUMAHO

setting = YAML.load_file('./config.yaml')
test_channel = setting['test_channel']

s = StarChatApiClient.new(setting['host'], setting['username'], setting['password'])

p "=== subscribe_channel ==="
s.subscribe_channel(test_channel)

p "=== get_stream ==="
s.get_stream do |res|
  res.read_body do |body|
    b = JSON.parse(body)
    if b['type'] == 'message'
      message = b['message']
      if message['notice'] == false
        if message['body'] =~ /スマホ/
          s.post_comment(message['channel_name'], SUMAHO)
        end
      end
    end
  end
end
