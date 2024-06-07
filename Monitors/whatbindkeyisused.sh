#!/bin/bash

pgrep -a "xbindkeys" | sed 's/.*\(.\)/\1/'