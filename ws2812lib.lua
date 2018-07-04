function ws2812_init()
-- init the ws2812 module
ws2812.init(ws2812.MODE_SINGLE)
-- create a buffer, 60 LEDs with 3 color bytes
strip_buffer = ws2812.newBuffer(27, 3)
-- init the effects module, set color to red and start blinking
ws2812_effects.init(strip_buffer)
ws2812_effects.set_speed(0)
ws2812_effects.set_brightness(255)
ws2812_effects.set_color(254,254,254)
ws2812_effects.set_mode("static")
ws2812_effects.start()
end

function ws2812_changeRGB(rgb)
    ws2812_effects.set_color(254,254,254)
    ws2812_effects.set_mode("static")
end
