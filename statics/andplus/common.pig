A = load '$logfile' using PigStorage(' ');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate '$fieldnum' as packname, $10 as uuid;
D = distinct C;
E =  group D by packname;
F = foreach E generate group, COUNT(D.packname) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
