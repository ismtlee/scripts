A = load '/usr/deploy/jmmq/logs/pluginlog_2012_12_03_00' using PigStorage(' ');
B = filter A by $6 MATCHES  'adpic/P_.*(png|jpg|jpeg|gif)';
C = foreach B generate $4 as status, $5 as imei, $6 as img, $7 as ip;
D = group C by (img, status);
E = FOREACH D {F = DISTINCT C.imei; G = DISTINCT C.ip; GENERATE group, COUNT(F) as imei_count, COUNT(G) as ip_count;};
H = order E by imei_count,ip_count desc;
STORE H INTO 'output/detail';


