A = load '$logfile' using PigStorage(' ');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $8 as android, $10 as uuid;
D = distinct C;
E =  group D by android;
F = foreach E generate group, COUNT(D.android) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
