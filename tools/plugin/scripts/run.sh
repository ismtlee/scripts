#!/bin/sh
envdir=$(dirname $0)
source $envdir/env.sh

showInfo() {
  gap
  echo 原始apk包存放: $CURRENT
  echo 临时解压包存放: $TEMP
  echo 已注apk包存放: $NEWAPK
  gap
}

clean() { 
    if [ -d $TEMP ]; then
        rm -rf $TEMP/*
    fi
}

decompile() {
    echo "Begin decompiling all packages, it may take a while..."
    hasfiles=`ls $CURRENT` 
    if [ -z "$hasfiles" ]; then
       echo "错误: 请把待破解的apk包放到current目录!"
       exit
    fi
    for file in $CURRENT/*
    do
        if [ "${file##*.}" = "apk" ];then
            filedir=`basename ${file%.*}`
            #apktool d $CURRENT/com.macropinch.pearl_130043.apk -f -o $TEMP/$filedir
            apktool d $file -f -o $TEMP/$filedir > /dev/null
        fi
    done
    gap "Current Projects"
    ls -l $TEMP/
}

buildAllApk() {
    echo "Begin generating apk files, it may take a while..."
    for file in $TEMP/*
    do
        buildApk $file $NEWAPK
    done
}

copyFiles() {
   for file in $TEMP/*
   do
     cp -r $PLUGDIR/smali/com/blery $file/smali/com/
     # copy google's new sdk
     rm -rf $file/smali/com/google
     cp -r $PLUGDIR/smali/com/google $file/smali/com/
     #copy so files
     copySofile $file
   done
}

copySofile() {
    file=$1
    if [ ! -d "$file/lib" ];then
        mkdir $file/lib
    fi
    hasSo=0
    for sofile in $PLUGDIR/lib/*
    do
        bsofile=`basename $sofile`
        if [ -d "$file/lib/$bsofile" ];then
           cp  -r $sofile $file/lib/
           hasSo=1
        fi
    done
    if [ $hasSo == 0 ]; then
        cp -r $PLUGDIR/lib/armeabi $file/lib/
    fi
        
}

manifest() {
    tt=`xml sel -t  -c "//uses-permission" $PLUGDIR/AndroidManifest.xml`
    for file in $TEMP/*
    do
        # add uses-permision
        tt=`echo $tt | perl -pe 's/xmlns:android=".+?"//g'`
        line=`gsed -n -e '/uses-permission/=' $file/AndroidManifest.xml |tail -1`
        if [ -z $line ]; then
           line=`gsed -n -e '/<\/application>/=' $file/AndroidManifest.xml`
           gsed  -i "${line}i$tt" $file/AndroidManifest.xml
        else
           gsed  -i "${line}a$tt" $file/AndroidManifest.xml
        fi

        # add others node
        #othernode=`cat $PLUGDIR/AndroidManifest.xml|tr -d '\040\011\012\015'|grep -o "<meta.*</service>"`
        othernode=`cat $PLUGDIR/AndroidManifest.xml|tr -d '\n'|grep -o "<meta.*</service>"`
        line=`gsed -n -e '/<\/application>/=' $file/AndroidManifest.xml`
        gsed  -i "${line}i$othernode" $file/AndroidManifest.xml
   
        #gp service
        gpservice $file

        smali $file   
        #format xml
        xml fo  $file/AndroidManifest.xml > $file/AndroidManifest.xml.bak
        mv $file/AndroidManifest.xml.bak  $file/AndroidManifest.xml
     done
     gap "manifest construected"
     gap "smali files construected"

}

gpservice() {
    file=$1
    if [ ! -f $file/res/values/integers.xml ]; then
        cp $PLUGDIR/res/values/integers.xml $file/res/values/  
    else
        attr=`xml sel -t -m "resources/integer[@name='google_play_services_version']" -v "//integer[@name='google_play_services_version']" $file/res/values/integers.xml`
        plg_attr=`xml sel -t -m "resources/integer[@name='google_play_services_version']" -v "//integer[@name='google_play_services_version']" $PLUGDIR/res/values/integers.xml`
        if [ -z $attr ]; then
            xml ed -s "//resources" -t elem -n linkerboominteger -v $plg_attr $file/res/values/integers.xml |xml ed -i //linkerboominteger -t attr -n name -v google_play_services_version |xml ed -L -r //linkerboominteger -v integer  > $file/res/values/output_integers.xml
            rm -rf $file/res/values/integers.xml
            mv $file/res/values/output_integers.xml $file/res/values/integers.xml
        else
            #replace
            xml ed -L -u "//resources/integer[@name='google_play_services_version']" -v $plg_attr $file/res/values/integers.xml
        fi
    fi
}

smali() {
   file=$1
   attr=`xml sel -t -m "/manifest/application" -v "@android:name" $file/AndroidManifest.xml`
   if [ -z $attr ]; then
       xml ed -L -i "/manifest/application" -t attr -n "android:name" -v "com.blery.sdk.PlgApplication" $file/AndroidManifest.xml 
   else
       #xml ed -L -u "/manifest/application/@android:name"  -v "com.blery.sdk.PlgApplication" $file/AndroidManifest.xml
       appfile=$file/smali/`echo $attr|tr . /`.smali
       #application可能存在没有onCreate方法
       aa=`grep -e ".method.*onCreate(.*)" $appfile`
       if [ -z "$aa" ]; then
           plgapp=$PLUGDIR/smali/com/blery/sdk/PlgApplication.smali
           str=`gsed -n '/.method.*onCreate(.*)/, /return-void/p' $plgapp`
           echo $str >> $appfile
           echo ".end method" >> $appfile
       else
         line=`gsed -n '/.method.*onCreate(.*)/, /return-void/=' $appfile|tail -1`
         tt='invoke-static {p0}, Lcom/blery/sdk/PlgFacade;->Init(Landroid/content/Context;)V'
         gsed  -i "${line}i$tt" $appfile
       fi

   fi

   #attr=`xml sel -t -m "/manifest/application/activity/intent-filter/action[@android:name='android.intent.action.MAIN']/../.." -v "@android:name" $file/AndroidManifest.xml`
   attr=`xml sel -t -m "/manifest/application/activity/intent-filter/category[@android:name='android.intent.category.LAUNCHER']/../.." -v "@android:name" $file/AndroidManifest.xml`
   #主activity有两种写法:com.a.b.MainActivity|.MainActivity
   #如果是后一种与MF的packname拼接成全路径
   dot_num=`echo $attr | grep -o '\.'|wc -l`
  
   if [ $dot_num -eq 1 ]; then
        PKGNAME=`xml sel -t -m "/manifest" -v "@package" $file/AndroidManifest.xml`
        appfile=$file/smali/`echo $PKGNAME$attr|tr . /`.smali
   else
        appfile=$file/smali/`echo $attr|tr . /`.smali
   fi

   #appfile=$file/smali/`echo $attr|tr . /`.smali
   line=`gsed -n '/.method.*onCreate(.*)/, /return-void/=' $appfile|tail -1` 
   tt='invoke-static {p0}, Lcom/blery/sdk/PlgFacade;->ShowOnStart(Landroid/app/Activity;)V'
   gsed  -i "${line}i\\\t${tt}\n" $appfile
}

modPackage() {
   #file=$1
   file=./
   pkgname=`genPkgName`
   #mf 包名|smali替换|文件夹名
   attr=`xml sel -t -m "/manifest" -v "@package" $file/AndroidManifest.xml`
   #echo $attr |perl -pe "s/\.[a-z]*/\.`genPkgName`/g"
   echo `genPkgName`
   echo `genPkgName`
}

genPkgName() {
    seed=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    pkglen=$(((RANDOM%(10 + 1 - 5))+5))
    i=0
    while(($i<$pkglen)); do
        key=$(((RANDOM%(${#seed[@]} - 0))+0))
        pkgname=${pkgname}${seed[$key]}
        i=`expr $i + 1`
    done
    echo $pkgname 
}

afterall() {
    #chown -R nobody:nobody $APKROOT
    gap
    echo "The new apk files are: "
    ls -l $NEWAPK/*
}

main() {
    showInfo
    clean
    decompile
    copyFiles
    manifest
    buildAllApk
    afterall
}

case $1 in
   d)
        decompile
    ;;
   b)
        buildApk $2 $NEWAPK
    ;;
   c)
        copyFiles
    ;;
   test)
       progressBar
       #modPackage
    ;;
   all)
       main 
    ;;
   *)
    echo -e "options:\nd:decompile\nb:buildApk\nall:all"
    ;;
esac
