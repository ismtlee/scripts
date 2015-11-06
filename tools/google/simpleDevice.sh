#!/bin/sh
OUTFILE=./test
adb wait-\for-device
Fingerprint=`adb shell getprop ro.build.fingerprint|tr -d '\r'`
Product=`adb shell getprop ro.product.name|tr -d '\r'`
Carrier=`adb shell getprop ro.carrier|tr -d '\r'`
Radio=`adb shell getprop gsm.version.baseband|tr -d '\r'`
Bootloader=`adb shell getprop ro.bootloader|tr -d '\r'`
Client=`adb shell getprop net.hostname|tr -d '\r'`
Device=`adb shell getprop ro.product.device|tr -d '\r'`
SDKVER=`adb shell getprop ro.build.version.sdk|tr -d '\r'`
Model=`adb shell getprop ro.product.model|tr -d '\r'`
Manufacturer=`adb shell getprop ro.product.manufacturer|tr -d '\r'`
BuildPrd=`adb shell getprop ro.build.product|tr -d '\r'`

LineContent=$Fingerprint"\t"$Product"\t"$Carrier"\t"$Radio"\t"$Bootloader"\t"$Client"\t"$Device"\t"$SDKVER"\t"$Model"\t"$Manufacturer"\t"$BuildPrd
echo $LineContent >> $OUTFILE
