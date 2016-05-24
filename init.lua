dofile("server.lua")
function main()
    gpio.mode(0, gpio.OUTPUT)
    gpio.write(0, gpio.HIGH) -- Done
    gpio.mode(1, gpio.OUTPUT)
    gpio.write(1, gpio.HIGH) -- Running 
    gpio.mode(2, gpio.OUTPUT)
    gpio.write(2, gpio.LOW) -- Speaker
    mdns.register("alertnode", { description="Alert NodeMCU", service="alert", port=33073, location="Bedroom" })
    sv = net.createServer(net.TCP, 30)
    port = 33073
    sv:listen(port, srvlisten)
    print("Listening on port " .. tostring(port) .. "...")
end

enduser_setup.start(
  function()
    print("Connected to wifi as:" .. wifi.sta.getip())
    main()
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
  end
)
