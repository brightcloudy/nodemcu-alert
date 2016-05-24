#!/bin/bash
python luatool.py --src server.lua --dest server.lua
python luatool.py --src init.lua --dest init.lua --restart
