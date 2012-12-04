A = load '$logfile' using PigStorage(' ');

B = filter A by $6 MATCHES  '/adpic/P_.*(png|jpg|jpeg|gif)';

C = foreach B generate $0 as ip, $6 as img;

D = distinct C;

E =  group D by img;

F = foreach E generate group, COUNT(D.img) as mycount;

G = order F by mycount desc;

STORE G INTO '$out_dir';


