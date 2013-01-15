A = load '$logfile' using PigStorage('\t');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
B = filter A by $4 matches '901';
C = foreach B generate $9 as operator, $13 as imei; 
D = distinct C;
E =  group D by operator;
F = foreach E generate group, COUNT(D.operator) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
