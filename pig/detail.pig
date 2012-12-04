A = load '/usr/deploy/jmmq/logs/pluginlog_2012_12_02_00' using PigStorage('\t');
B = filter A by $5 MATCHES  'adpic/P_.*(png|jpg|jpeg|gif)';
C = foreach B generate $3 as status, $4 as imei, $5 as img, $6 as ip;
D = group C by (img, status);
-- E = FOREACH D {F = DISTINCT C.imei; G = DISTINCT C.ip; GENERATE group, COUNT(F) as imei_count, COUNT(G) as ip_count;};
E = FOREACH D {G = DISTINCT C.ip; GENERATE group, COUNT(G) as ip_count;};
H = order E by ip_count desc;
STORE H INTO 'output/detail';


