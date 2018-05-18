#!/bin/sh
source ../header.sh
source ./version.sh
sqlite=sqlite-autoconf-3170000
python_dir=${PYTHON_V:0:3}

dependencies() {
  yum -y install gcc-c++ glibc-headers openssl openssl-devel make
  # 解决无法安装scrapy依赖的twisted问题
  yum -y install bzip2-devel
}

download() {
  #python3
	py_tgz=Python-$PYTHON_V.tgz
	if [ ! -f $download/$py_tgz ];
	then
    wget https://www.python.org/ftp/python/$PYTHON_V/Python-$PYTHON_V.tgz -P $download
		tar zxvf $py_tgz
	fi
  #sqlite
  sqlite_tgz=$sqlite.tar.gz
  wget https://www.sqlite.org/2017/$sqlite_tgz --no-check-certificate -P $download
	tar zxvf $sqlite_tgz
}

install() {
  cd $download/$sqlite 
  ./configure --prefix=/usr/local/sqlite3 --disable-static --enable-fts5 --enable-json1 CFLAGS="-g -O2 -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS4=1 -DSQLITE_ENABLE_RTREE=1"
  
  # install python3
	cd $download/Python-$PYTHON_V
  LD_RUN_PATH=/usr/local/sqlite3/lib ./configure --prefix=/usr/local/python$python_dir LDFLAGS="-L/usr/local/sqlite3/lib" CPPFLAGS="-I /usr/local/sqlite3/include"
  LD_RUN_PATH=/usr/local/sqlite3/lib make
  #LD_RUN_PATH=/usr/local/sqlite3/lib make test
  LD_RUN_PATH=/usr/local/sqlite3/lib make install
}

usergroup() {
  :
}

config() {
  echo "export PATH=\$PATH:/usr/local/python$python_dir/bin" >> /etc/profile
  source /etc/profile
}

reload() {
 : 
}				


main $1
