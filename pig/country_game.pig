A = load '$logfile' using PigStorage('\t');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $2 as uid, $3 as gameId, $10 as country; 
D = filter C by uid == 0;
E =  group D by (gameId, country);
F = foreach E generate FLATTEN(group), COUNT(E.uid) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
