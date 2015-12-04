A = load '$logfile' using PigStorage(' ');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $6 as country, $10 as uuid;
D = distinct C;
E =  group D by country;
F = foreach E generate group, COUNT(D.country) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
