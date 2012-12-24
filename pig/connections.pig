A = load '$logfile' using PigStorage('\t');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $12 as imei; 
E =  group C by imei;
F = foreach E generate group, COUNT(C.imei) as mycount;

--G = foreach F generate $0 as imei, $1 as count;
--H = group G by count;
--I = foreach H generate group, COUNT(G.count) as count2;


--J = order I by count2 desc;
STORE F INTO '$out_dir';
