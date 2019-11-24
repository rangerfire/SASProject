
data utility;
infile datalines;
input USER $ HP1 HP2 HP3 TW SW1 SW2 SW3;
datalines;
A	4	0	0	5	1	0	0
B	5	5	4	0	0	0	0
C	0	0	0	2	4	5	0
D	0	3	0	0	0	0	3
;
run;


data utility_round;
infile datalines;
input USER $ HP1 HP2 HP3 TW SW1 SW2 SW3;
datalines;
A	1	0	0	1	0	0	0
B	1	1	1	0	0	0	0
C	0	0	0	0	1	1	0
D	0	1	0	0	0	0	1
;
run;
data utility_normal;
infile datalines;
input USER $ HP1 HP2 HP3 TW SW1 SW2 SW3;
datalines;
A	0.6667	0.0000	0.0000	1.6667	-2.3333	0.0000	0.0000
B	0.3333	0.3333	-0.6667	0.0000	0.0000	0.0000	0.0000
C	0.0000	0.0000	0.0000	-1.6667	0.3333	1.3333	0.0000
D	0.0000	0.0000	0.0000	0.0000	0.0000	0.0000	0.0000
;
run;

proc iml;
use utility_normal;
read all var {  HP1 HP2 HP3 TW SW1 SW2 SW3 } into M; 
print M;
   norm = sqrt(M[ ,##]); /* Euclidean norm */
   print norm;
   A = M/norm; 
   print A;
   A[4,1:7]=0;
   print A;
   d = A*A`;
   print d;
quit;




