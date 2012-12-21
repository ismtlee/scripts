A = load '$logfile' using PigStorage('\t');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $10 as country, $12 as imei; 
D = distinct C;
E =  group D by country;
F = foreach E generate group, COUNT(D.country) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
