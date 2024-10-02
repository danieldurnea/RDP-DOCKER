#!/bin/sh

service ssh start
./ngrok tcp 22

"$@"
