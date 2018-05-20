--[[
    nodeMcu连接oneNet，20180312
    nodeMcu固件需要加入mqtt支持
    ]]--

m = nil

local payload = '{"datastreams":[{"id":"temperature", "datapoints":[{"at":"2018-05-20T14:47:00", "value":50}]}]}'
local header = string.char(1, 0, string.len(payload)) .. payload

local led = {}
led.pin = 1 -- 0就是D1

local function ledTest(isLight)
  gpio.mode(led.pin, gpio.OUTPUT)
  print ('pin ' .. isLight)
  local t = type(isLight);
  if t == "string" then
    local n = tonumber(isLight);
      if n then
        isLight = n -- n就是得到数字
        print (isLight)
      else
        print 'num parse failed' -- 转数字失败,不是数字, 这时n == nil
      end
  end
  if isLight ~= nil and isLight == 0 then
    print 'pin is 0'
    gpio.write(led.pin, gpio.LOW) -- HIGH为亮 LOW为z
  else
    print 'pin is 1'
    gpio.write(led.pin, gpio.HIGH) -- HIGH为亮 LOW为z
  end
end

local function conume_data( payload )
    print('conume_data', payload);
    --do someting with the payload and send responce
    -- send_ping()
    if payload == "close" then
      print('close client');
      m:close()
    else
      ledTest(payload)
    end    
end


local function mqtt_start()
    m = mqtt.Client(module.CLIENT_ID, 120, module.USERNAME, module.PASSWORD, 0)
    print('mqtt_start', module.CLIENT_ID);
    -- register message callback beforehand
    m:on("message", function(conn, topic, data)
      print('message', data);
      if data ~= nil then
        print("got data:" .. topic .. ": " .. data)
        conume_data(data)
      end
    end)

    m:on("connect", function(client) print ("connected") end)
    m:on("offline", function(client) print ("offline") end)

    m:connect(module.HOST, module.PORT, function(client)
      print("connected")
      -- Calling subscribe/publish only makes sense once the connection
      -- was successfully established. You can do that either here in the
      -- 'connect' callback or you need to otherwise make sure the
      -- connection was established (e.g. tracking connecti**tatus or in
      -- m:on("connect", function)).
    
      -- subscribe topic with qos = 0
      client:subscribe(module.TOPIC, 0, function(client) print("subscribe success") end)
      -- publish a message with data = hello, QoS = 0, retain = 0
      client:publish(module.TOPIC, "hello", 0, 0, function(client) print("sent") end)
      tmr.alarm(1, 5000, 1, function()
        client:publish('$dp', header, 0, 0, function(client) print("sent header") end)
      end)
    end,
    function(client, reason)
      print("failed reason: " .. reason)
    end)
    
    -- m:close();

end
