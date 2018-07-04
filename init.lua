-- setup.lua
local function wifi_wait_ip()
  if wifi.sta.getip()== nil then
    print("IP unavailable, Waiting...")
  else
    tmr.stop(1)
    print("\n====================================")
    print("wifi mode is: " .. wifi.getmode())
    print("Chip ID "..node.chipid());
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is "..wifi.sta.getip())
    print("====================================")
    mqtt_start()
    ws2812_init()
  end
end


local function wifi_start(list_aps)
    if list_aps then
        for key,value in pairs(list_aps) do
            if config.SSID and config.SSID[key] then
                print('config: ', key, config.SSID[key])
                wifi.setmode(wifi.STATION);
                wifi.sta.config({ssid=module.SSID, pwd=module.WIFI_PWD, auth=wifi.WPA2_PSK})
                wifi.sta.connect()
                print("Connecting to " .. key .. " ...")
                config.SSID = nil  -- can save memory
                tmr.alarm(1, 2500, 1, wifi_wait_ip)
            end
        end
    else
        print("Error getting AP list")
    end
end

function start()
  print("Configuring Wifi " ..module.SSID.. " : " ..module.WIFI_PWD.. " ..." )
  wifi.setmode(wifi.STATION);
  wifi.sta.config({ssid=module.SSID, pwd=module.WIFI_PWD, auth=wifi.WPA2_PSK})
  wifi.sta.connect()
  tmr.alarm(1, 2500, 1, wifi_wait_ip)
  -- wifi.sta.getap(wifi_start)
end

dofile('util.lua')
dofile('config.lua')
dofile('mqttClient.lua')
dofile('ws2812lib.lua')
start()
