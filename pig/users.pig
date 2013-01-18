A = load '$logfile' using PigStorage('\t');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $12 as imei; 
D = distinct C;
F = foreach D generate COUNT(D.imei) as mycount;
STORE F INTO '$out_dir';
