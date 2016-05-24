function alert()
    pwm.setup(2, 1000, 512)
    for i=0,5,1 do
        gpio.write(0, gpio.LOW)
        pwm.start(2)
        tmr.delay(100000)
        gpio.write(0, gpio.HIGH)
        pwm.stop(2)
        tmr.delay(100000)
    end
    pwm.close(2)
end

function srvreceive(c, pl)
    local cmdtext = pl:sub(1, -1)
    print(cmdtext)
    if cmdtext == "running" then
        gpio.write(1, gpio.LOW)
    end
    if cmdtext == "done" then
        gpio.write(1, gpio.HIGH)
        tmr.alarm(0, 2000, tmr.ALARM_AUTO, alert)
        alert()
    end
    if cmdtext == "ack" then
        tmr.stop(0)
        tmr.unregister(0)
    end
    c:close()
end

function srvlisten(c)
    local ip, peerport = c:getpeer()
    print("Got connection from " .. tostring(ip) .. " on port " .. tostring(peerport))
    c:on("receive", srvreceive)
end
