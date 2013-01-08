A = load '$logfile' using PigStorage('\t');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $20 as status, $12 as imei; 
D = distinct C;
E =  group D by status;
F = foreach E generate group, COUNT(D.status) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
