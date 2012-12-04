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
L = foreach K generate $0 as img, $1 as show_status, $2 as show_imei, $3 as show_ip, $5 as click_status, $6 as click_imei, $7 as click_ip, (float)$6/show_imei as click_imei_rate, (float)click_ip/show_ip as click_ip_rate;
M = order L by show_imei desc;
STORE M INTO '$out_dir';


