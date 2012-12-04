--A = load '$logfile' using PigStorage('\t');
A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
B = filter A by $5 MATCHES  'adpic/P_.*(png|jpg|jpeg|gif)';
C = foreach B generate $3 as status, $4 as imei, $5 as img, $7 as ip;
D = group C by (img, status);
E = FOREACH D {F = DISTINCT C.imei; G = DISTINCT C.ip; GENERATE FLATTEN(group), COUNT(F) as imei_count, COUNT(G) as ip_count;};
H = order E by $0 desc;
I = filter H by $1 == 1;
J = filter H by $1 == 2;
K = join I by $0, J by $0;
L = foreach K generate $0, $1, $2, $3, $5, $6, $7
STORE L INTO '$out_dir';


