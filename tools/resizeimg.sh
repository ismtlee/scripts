#! /bin/Bash
#yum install ImageMagick
let Limit=10*1024
Quality=70
DIR="/home/wwwroot/www.xiaohuai.com"
cd $DIR
for i in `find $DIR -name "*.???"`
do
    FSIZE=`wc -c $i|awk '{print $1}'`
    EXT=${i##*.}
    if [ $FSIZE -ge $Limit ] && [ "$EXT" == "jpg" ] || [ "$EXT" == "JPG" ] || [ "$EXT" == "png" ] || [ "$EXT" == "PNG" ] || [ "$EXT" == "bmp" ] || [ "$EXT" == "BMP" ]; then
        #convert -resize 800x600 -quality $Quality $i $i
        convert -quality $Quality $i $i
        echo $i is Okay.
    fi
done
