/*
	last lecture
*/


/*PageRank Soluion*/
data Arcs;
    infile datalines;
    input Node $ A B C D  ;
    datalines;

A   0   1   1   0    
B   1   0   0   1    
C   1   0   0   1    
D   1   1   0   0    
;
run;

/*get the transition matrix*/
proc sql;
    create table matrix_1 as
        select a/sum(a) as x1
              ,b/sum(b) as x2
              ,c/sum(c) as x3
              ,d/sum(d) as x4                 
        from Arcs
    ;
quit;

/*Since there are 7 nodes, the initial vector v0 has 7 components, each 1/7*/
data rank_p;
    x1=1/4; 
    x2=1/4;
    x3=1/4;
    x4=1/4;
        output;
run;

proc iml;
	use matrix_1;
	read all var { x1, x2, x3, x4 } into M;
	print M;

	use rank_p;
	read all var { x1, x2, x3, x4 } into rank_p1;
	print rank_p1;
	rank_p = t(rank_p1);
	print rank_p;

	rank_p2 = M * rank_p;
	print rank_p2;
	rank_p50 = (M**50)*rank_p;
	print rank_p50;

quit;

/*---------------------------------------------*/

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

/*
	the result is: the matrix of cos( (?,?)simliarity ), and we know cos(0)=1, like the matrix shows 

*/
