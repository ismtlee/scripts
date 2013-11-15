A = load '$logfile' using PigStorage(' ');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $7 as lang, $10 as uuid;
D = distinct C;
E =  group D by lang;
F = foreach E generate group, COUNT(D.lang) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
