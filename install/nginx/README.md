#自动获取免费证书
0 0 1 * * ~/letsencrypt.sh ~/letsencrypt.conf >> /logs/lets-encrypt.log 2>&1
