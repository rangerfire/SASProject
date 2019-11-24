
/* dm odsresult 'clear' continue; */


***import the dataset***;
libname sasdata "C:\Academy\SAS\file\sasdata";
proc copy in=sasdata out=work;
select credit;
run;

********************************************************************* Data processing ************************************************************************;
/*
1. translate the type of Class to numeric
2. distribute the dataset to 2 files(class = 0, 1)
3. pick 10% samples from the first dataset(class = 0)
4. copy some data samples (class = 1)
5. merge 2 datsets
6. normalize the dataset
7. train ; test
*/

/*
1. translate the type of Class to numeric
*/
data credit;
   set credit;
   if class = '0'
   then class_new = 0;
   if class = '1'
   then class_new = 1;
   drop class;
run;

/*
2. distribute the dataset to 2 files(class = 0, 1)
*/
/*
class_new = 0
*/
proc sql;
	create table train1 as 
	select *
	from credit
	where class_new = 0;
quit;
/*
class_new = 1
*/
proc sql;
	create table train2 as 
	select *
	from credit
	where class_new = 1;
quit;
/* Now we have 284315 samples(class = 0)
	492 samples(class = 1)
	deal with Imbalanced Classes in Dataset
*/
proc surveyselect data = train1   
              out=train_out          
              method = srs
              samprate =0.1;
run;
/* train1_out : 28432 */

data train2_out;
        do i=1 to 10;
                do j=1 to 492;
/*492: total of train2's samples*/
                           set train2 point=j;
                        output;
                end;
        end;
        stop;
run;
/* train2_out:4920*/

/* Merge two trainsets*/
proc append base=train_out data=train2_out force;
quit;
/* the train set : train_out */

/* 
   We would like to choose testset
*/
proc surveyselect data = train1   
              out=test_out          
              method = srs
              samprate =0.1;
run;
proc append base=test_out data=train2 force;
quit;

*** Normalize the data ***;
PROC STANDARD DATA=train_out MEAN=0 STD=1 
             OUT=train;
  var time v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 Amount;
RUN;
PROC STANDARD DATA=test_out MEAN=0 STD=1 
             OUT=test;
  var time v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 Amount;
RUN;


********************************************************************************* Data Exploration ***************************************************************;
title " Univariate Analysis";
/*
proc univariate data = train normal;
   var time -- Amount;
   run; 
title " ";
*/

proc univariate data = train;
    class class_new;
	var time v1 v2 v3 v4 v5 v6 v7 v8 v9
			v10 v11 v12 v13 v14 v15 v16 
			v17 v18 v19 v20 v21 v22 v23 
			v24 v25 v26 v27 v28 Amount;
run;


/* correlation with class_new */
proc corr data = train ;
    var time v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11
    v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24
    v25 v26 v27 v28 Amount;   
	with class_new;
run;
quit;
/* correlation of all variables */
proc corr data = train ;
    var time v1 v2 v3 v4 v5 v6 
			v7 v8 v9 v10 v11
   			v12 v13 v14 v15 
			v16 v17 v18 v19 
			v20 v21 v22 v23 
			v24 v25 v26 v27 v28 Amount;
run;
quit;

proc corr data = train ;
    var time v1 v2 v3 v4 v5 v6 
			v7 v8 v9 v10 v11
   			v12 v13 v14 v15 
			v16 v17 v18 v19 
			v20 v21 v22 v23 
			v24 v25 v26 v27 v28 Amount;
	with class_new;
run;
quit;




title "Principal Component Analysis"; 

proc princomp   data=train 
	out = Work.train_total;
   	var time v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 
			v13 v14 v15 v16 v17 v18 v19 v20 
		 v21 v23 v24 v25 v26 v27 v28 Amount;
run;


***************************************************************** Model Selection 1 *******************************************************************;

/*BaseLine Model*/
title " rating: maxR selection";
proc reg data=train_total  outest=est_train;
     model     class_new = prin1 prin2 prin3 prin4 prin5 prin6 
							prin7 prin8 prin9 prin10 prin11 prin12 prin13 prin14
                        		/ selection=MAXR vif ;
      OUTPUT OUT = est_credit_1  PREDICTED=   RESIDUAL=Res   
					L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit
         ;  
quit;

proc princomp   data=test 
	out = Work.test_total;
   	var time v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v23 v24 v25 v26 v27 v28 Amount;
run;

/**/

data test_total;
   set test_total;   
   if 0.25711 - 0.09540 * prin1 + 0.04334 * prin2 + 0.05169 * prin3-0.01171*prin4 
- 0.07416 * prin5+0.02338*prin6 -0.02257*prin7+0.02729*prin8-0.01690*prin9-0.00848*prin10
-0.03957*prin11-0.02068*prin12 +0.05962*prin13- 0.06793 * prin14 < 0.5
   then class_pred = 0;
   if 0.25711 - 0.09540 * prin1 + 0.04334 * prin2 + 0.05169 * prin3-0.01171*prin4 
- 0.07416 * prin5+0.02338*prin6 -0.02257*prin7+0.02729*prin8-0.01690*prin9-0.00848*prin10
-0.03957*prin11-0.02068*prin12 +0.05962*prin13- 0.06793 * prin14 >=0.5
   then class_pred = 1;
run;


proc sql;
	create table test_pred as 
	select count(*)
	from test_total
	where class_new = 1 and class_pred = 0;
quit;
proc sql;
	create table test_pred1 as 
	select count(*)
	from test_total
	where class_new = 1;
quit;


/********************************************************************** Model diagnosis *******************************************************************************/

title " Model diagnosis";
proc surveyselect data = train_total   
              out=train_d          
              method = srs
              samprate =0.1;
run;


/* residual analysis */
proc reg data=train_d outest=est_train;
     model   class_new = prin1--prin14 ;
     
   plot student.*obs./vref= 3 2 -2 -3
                    haxis= 0 to 32 by 1;
   plot nqq.*student.;
run;



/* Influential observation */
proc reg data=train_total outest=est_train2;
     model   class_new = prin1 -- prin14/r influence;
	 
	 output out=ck2
	     rstudent=C_rstudent h=lev cookd=Cookd  dffits=dffit;
		 title 'influence';
run;
quit;

proc sql;
	create table ck_2 as 
	select *
	from ck2
	where class_new = 0;
quit;



/*delete*/
%let numparms = 15;
%let numobs = 14216;

data influential;
  set ck_2;

    cutdifts = 2*(sqrt(&numparms/&numobs));
	cutcookd = 4/&numobs;

	rstud_i = (abs(C_rstudent)>3);
	dfits_i = (abs(dffit)>cutdifts);
	cookd_i = (Cookd>cutcookd);
	sum_1 = rstud_i + dfits_i+ cookd_i;
	if sum_1 >0;
run;
quit;



data ck3;
  set train;
run;
quit;

proc sql;
delete from ck3 where id in (select id from influential);
quit;


dm odsresult 'clear' continue;
/*train:ck3*/



/******************** After remove, should got a new model ****************************/

title "Principal Component Analysis"; 

proc princomp   data=ck3 
	out = Work.ck3_total;
   	var time v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v23 v24 v25 v26 v27 v28 Amount;
run;


proc reg data=ck3_total outest=est_traininf;
     model     class_new = prin1 prin2 prin3 prin4 prin5 prin6 
							prin7 prin8 prin9 prin10 prin11 prin12 prin13 prin14
                        		/ selection=MAXR vif;
			output out = est_train_inf;
quit;




proc princomp   data=test 
	out = Work.test_total;
   	var time v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v23 v24 v25 v26 v27 v28 Amount;
run;


data test_total;
   set test_total;   
   if 0.14757 - 0.08323 * prin1 + 0.03708 * prin2 + 0.03133 * prin3+0.02148*prin4 
- 0.01780 * prin5-0.05388*prin6 +0.00556*prin7-0.01806*prin8-0.01556*prin9-0.01230*prin10
-0.03005*prin11+0.04754*prin12 +0.01855*prin13- 0.03574 * prin14 < 0.5
   then class_pred = 0;
   if 0.14757 - 0.08323 * prin1 + 0.03708 * prin2 + 0.03133 * prin3+0.02148*prin4 
- 0.01780 * prin5-0.05388*prin6 +0.00556*prin7-0.01806*prin8-0.01556*prin9-0.01230*prin10
-0.03005*prin11+0.04754*prin12 +0.01855*prin13- 0.03574 * prin14 >=0.5
   then class_pred = 1;
run;

proc sql;
	create table test_pred as 
	select count(*)
	from test_total
	where class_new = 1 and class_pred = 0;
quit;
proc sql;
	create table test_pred1 as 
	select count(*)
	from test_total
	where class_new = 1;
quit;




  
/***********************************************/  




/*BaseLine Model*/

Proc logistic data = train_total outmodel=outlog;

model class_new = prin1 -- prin14/selection=STEPWISE 
Slentry=0.1
Slstay=0.1;
Score data=train_total outroc=test_1;
quit
;


proc logistic inmodel=outlog;
score data=test_total out=predict;
run;


proc sql;
	create table test_pred1 as 
	select count(*)
	from predict 
	where F_class_new = '1' and I_class_new ='0';
quit;

proc sql;
	create table test_pred2 as 
	select count(*)
	from predict
	where F_class_new = '1';
quit;

