#!/bin/sh
. ./config.sh
svn ci ${OUTPUT}*.swf -m "genrate by server."
echo "committed to server..."
