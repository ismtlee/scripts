A = load '$logfile' using PigStorage('\t');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $1 as uid, $3 as gameId, $10 as country; 
E =  group C by (gameId, country);
F = foreach E generate FLATTEN(group), COUNT(C.uid) as mycount;
G = order F by gameId desc;
STORE G INTO '$out_dir';
