# nodemcu-alert
## Installation
Pull submodules with `git submodule init` and make sure esptool's dependencies are installed by running `sudo python esptool/setup.py install`.

Connect the NodeMCU and run `./flash.sh`. 

Once flashing has completed, unplug + replug in the NodeMCU.

You then need to run `./upload.sh` to upload the LUA source. If this fails with an error about communicating to the NodeMCU, just kill the script and start again. Make sure both server.lua and init.lua get uploaded, then you should be ready to go!
