A = load '$logfile' using PigStorage('\t');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $8 as operator, $9 as lang, $12 as imei; 
D = distinct C;
E =  group D by (operator, lang);
F = foreach E generate FLATTEN(group), COUNT(D.imei) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
