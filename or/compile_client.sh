#!/bin/sh
export PATH=${PATH}./usr/bin:/bin:/usr/local/bin:/data/flex_sdks/3.6.0/bin
. ./config.sh
echo "Begin update clent sources..."
svn up ${CLIENT}
svn up ${OUTPUT}
echo "Begin genrate swf files, pls wait..."
echo "------------------------------------"
mxmlc ${CLIENT}/src/com/defends/GameView.as -output=${OUTPUT}GameView.swf -source-path=${CLIENT}/src/  -target-player=10.1 -default-background-color=0x000000 -l+=${CLIENT}libs/  -optimize=true -default-frame-rate=24 -creator=joymeng -warnings=false

mxmlc ${CLIENT}/src/Gloader.as -output=${OUTPUT}Gloader.swf -source-path=${CLIENT}/src/  -target-player=10.1 -default-background-color=0x000000 -l+=${CLIENT}libs/  -optimize=true -default-frame-rate=24 -creator=joymeng -warnings=false
echo "------------------------------------"
echo "swf files genrated .."


echo "begin secure the swf.."
#/data/secureSWF_v3pro_linux/secureSWF ${OUTPUT}/GameView.swf ${OUTPUT} -p:standard
#/data/secureSWF_v3pro_linux/secureSWF ${OUTPUT}/GameView.swf ${OUTPUT} -s:off -c:50 -w:3
#/data/secureSWF_v3pro_linux/secureSWF ${OUTPUT}/Gloader.swf ${OUTPUT} -s:off -c:50 -w:3
echo "swf genrated successfully!"

