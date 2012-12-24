A = load '$logfile' using PigStorage('\t');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $12 as imei; 
E =  group C by imei;
F = foreach E generate group, COUNT(C.imei) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
