
***import the dataset***;
libname sasdata "C:\Academy\SAS\file\sasdata";
proc copy in=sasdata out=work;
select lung;
run;

title "forward selection";
proc reg data = lung  outest = est_train;
     model    HEIGHT_Oldest_Child = AGE_Oldest_Child     WEIGHT_Oldest_Child     HEIGHT_Mother
 									 WEIGHT_Mother      HEIGHT_Father      WEIGHT_Father 
                        		/ selection = forward ;  
quit;

title "back selection";
proc reg data = lung  outest = est_train;
     model    HEIGHT_Oldest_Child = AGE_Oldest_Child     WEIGHT_Oldest_Child     HEIGHT_Mother
 									 WEIGHT_Mother      HEIGHT_Father      WEIGHT_Father 
                        		/ selection = backward ;  
quit;

title "step selection";
proc reg data = lung  outest = est_train;
     model    HEIGHT_Oldest_Child = AGE_Oldest_Child     WEIGHT_Oldest_Child     HEIGHT_Mother
 									 WEIGHT_Mother      HEIGHT_Father      WEIGHT_Father 
                        		/ selection = stepside ;  
quit;



/*PageRank Soluion*/
/*PageRank Soluion*/
data Arcs;
    infile datalines;
    input Node $ A B C D E F G  ;
    datalines;
A   0	1	1	0	0	1	0    
B   1	0	0	1	0	0	1	 
C   0	0	0	1	0	1	0	 
D   1	1	0	0	1	0	0	 
E   0	0	1	0	0	0	0	 
F   0	0	0	0	1	0	0	 
G   0	1	0	0	0	0	0	 
;
run;
/*get the transition matrix*/
proc sql;
    create table matrix_1 as
        select a/sum(a) as x1
              ,b/sum(b) as x2
              ,c/sum(c) as x3
              ,d/sum(d) as x4 
              ,e/sum(e) as x5 
              ,f/sum(f) as x6 
              ,g/sum(g) as x7 
        from Arcs;
quit;
/*Since there are 7 nodes, the initial vector v0 has 7 components, each 1/7*/
data rank_p;
    x1=1/7; 
    x2=1/7;
    x3=1/7;
    x4=1/7;
	x5=1/7;
	x6=1/7;
	x7=1/7;
        output;
run;
proc iml;
    use matrix_1;
    read all var { x1 x2 x3 x4 x5 x6 x7} into M;
    print M;

    use rank_p;
    read all var { x1 x2 x3 x4 x5 x6 x7} into rank_p1;
	print rank_p1;
    rank_p = t(rank_p1);
    print rank_p ; 
    
    rank_p2=M *rank_p;
    print rank_p2 ;     
   rank_p50=(M**50)*rank_p;
   print rank_p50 ;

quit;

/*

*** Normalize the data ***;
PROC STANDARD DATA = breast_cancer_data MEAN=0 STD=1 
             OUT = train;
  var radius_mean -- fractal_dimension_mean;
RUN;

title "Principal Component Analysis"; 

proc princomp   data = train 
	out = Work.train_PCA;
   	var radius_mean -- fractal_dimension_mean;
run;

*/


/*
proc logistic data  = heart_attack descending;
	model Heart_attack_2 = Anger_Treatment Anxiety_Treatment;
quit;


proc logistic data  = heart_attack descending;
	model Heart_attack_2 = Anger_Treatment Anxiety_Treatment;
quit;
*/

/* dm odsresult 'clear' continue; */

**plus---------------**;

/*
	lg(odds) = -1.6060 - 0.7478  voice
	

	if	voice = 0
			log(odds) = -1.6060
			exp( log(odds) ) = e^-1.6060 = 0.200689 ~~(0.200697 =  using the table in excel )
			p(churn) = e^-1.6060/(1 + e^-1.6060) = 0.167145 ~~ (0.267151 = using the table in excel)

	if	voice = 1
			log(odds) = -2.3538
			exp( log(odds) ) = e^-2.3538 = 0.95007 ~~( ?  =  using the table in excel )
			p(churn) = e^-2.3538/(1 + e^-2.3538) = 0.8764 ~~ (? = using the table in excel)

prob -> odds - > or

odds ratio => divides of two odds
*/

/*
	beta1 = 0.7478
*/


/*step2
service call: 4 parts
sercall  v_csc   temp1   temp2
0,1   ->  0        0      0

2,3   ->  1        1      0

4+    ->  2        0      1

*/

/*
run the temp part:
log(odds) = -2.0510 - 0.0370 TEMP1 + 2.1184 TEMP2

run the csc part:
log(odds) = -2.0510 - 0.0370 CSC 1 + 2.1184 CSC 2

===> DON'T need to use the temp: cause sas do it for us

not significant?
can't delete what? servcall = 2,3 ?

=>

combine: 
0,1,2,3    V_CSC = 0
4+         V_CSC = 1

*/

/*
fomula:

	e^----------
----------------------    ====> no restriction!, use any variable
  1+e^------------

*/
