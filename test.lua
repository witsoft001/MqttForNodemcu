local aaa = splitStr('0,254,0', ',')

ws2812_changeRGB(aaa)

ws2812.init(ws2812.MODE_SINGLE)
-- create a buffer, 60 LEDs with 3 color bytes
strip_buffer = ws2812.newBuffer(3, 3)
-- init the effects module, set color to red and start blinking
ws2812_effects.init(strip_buffer)
ws2812_effects.set_speed(1)
ws2812_effects.set_brightness(254)
ws2812_effects.set_color(aaa[1],aaa[2],aaa[3])
ws2812_effects.set_mode("static")
ws2812_effects.start()
