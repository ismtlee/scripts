A = load '$logfile' using PigStorage(' ');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $2 as operator, $10 as uuid;
D = distinct C;
E =  group D by operator;
F = foreach E generate group, COUNT(D.operator) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
