A = load '$logfile' using PigStorage(' ');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $10 as uuid;
D = distinct C;
E = group D ALL;
F = foreach E generate COUNT(D.uuid) as mycount;
STORE F INTO '$out_dir';
