#!/bin/sh

service xrdp start
./ngrok tcp 3389

"$@"
