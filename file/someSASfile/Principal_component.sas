

* initalize the data ;
proc copy in=sashelp out=work;
   select iris ;
run;

title "Principal Component Analysis"; 
title2 " Univariate Analysis"; 
proc univariate data=iris;
   var PetalWidth PetalLength;
run;
title " "; 
title2 " ";

 

*** Normalize the data ***;
PROC STANDARD DATA=iris(keep= SepalLength species PetalWidth PetalLength) MEAN=0 STD=1 
             OUT=iris_z(rename=(PetalWidth=PetalWidth_z PetalLength=PetalLength_z));
  VAR  PetalWidth PetalLength ;
RUN;
*** calculate corrolations between variables ***;
title "Principal Component Analysis"; 
title2 " corrolation between variables"; 
proc corr data=iris_z; 
var PetalWidth_z PetalLength_z;
run;

title "Principal Component Analysis"; 
title2 " Plot of the normalized data"; 
proc sgplot data=iris_z ;
  scatter     x= PetalWidth_z y=PetalLength_z;
  ellipse     x= PetalWidth_z y=PetalLength_z; ;
   
run;
title " "; 
title2 " "; 




proc princomp   data=iris_z ;
   var  PetalWidth_z  PetalLength_z  ;
run;



data iris_z2;
  set iris_z;
     compz_1=0.707107*PetalWidth_z+0.707107*PetalLength_z;
     compz_2=0.707107*PetalWidth_z-0.707107*PetalLength_z;
run;
title "Principal Component Analysis"; 
title2 " corrolation between components"; 
proc corr data=iris_z2; 
var  compz_1  compz_2;
run;


** creat an output dataset with scores **;

proc princomp   data=iris_z  out=pca_petal;
   var  PetalWidth_z  PetalLength_z  ;
run;


proc sgplot data=pca_petal  ;
  scatter     x= Prin1  y=SepalLength ;  
run;

proc sgplot data= pca_petal;
  hbox  Prin1   / category=species  ;
run;


title "Principal Component Analysis"; 
title2 " corrolation between components"; 
proc corr data=pca_petal; 
var    Prin1  Prin2 ;
run;

ods graphics on;
proc corr data=pca_petal; 
var    Prin1  Prin2 ;
run;
ods graphics off;

*** stop here ****;
options pagesize=120;
proc factor data = iris_z   print  method = principal nfactors=2
   MINEIGEN = 0     ROTATE=NONE      outstat=fact out=factout;
var PetalWidth_z  PetalLength_z  ;
run;
 PRIORS=SMC round score corr scree residuals EIGENVECTORS

proc corr data=factout; 
var     factor1 factor2 ;
run;


data factor_out2;
  set factout;
  petalw_calc=0.50470748*factor1 + 0.50470748*factor2  ;
   petall_calc = 0.50470748*factor1 -3.6694064* factor2;
run; 


data gdata;
  set iris2(keep= PetalWidth PetalLength);
   PetalWidth_z = ( (PetalWidth-11.99333333)/7.62237669);
   PetalLength_z= ( (PetalLength - 37.58000000)/17.65298233 );
   Prin_1= PetalLength * 0.707107 + PetalWidth* 0.707107; 
   PetalLength_z_neg= - PetalLength_z;
   Prin_2= PetalLength * 0.707107 + PetalWidth- 0.707107;
   prin_line= PetalLength;
;
run;
proc sort data=gdata; by PetalWidth ;run;
proc sgplot data=gdata;
  *scatter    x= PetalWidth y=PetalLength;
  *ellipse     x= PetalWidth y=PetalLength; ;
  scatter     x= PetalWidth_z y=  PetalLength_z;
  ellipse      x= PetalWidth_z y=  PetalLength_z;
  series      x= PetalWidth_z y= PetalWidth_z /lineattrs=(color=red pattern=dash);
   series      x=PetalLength_z y=  PetalLength_z_neg/lineattrs=(color=red pattern=dash)    ;
run;


proc princomp   data=gdata;
   var  PetalLength_z PetalWidth_z ;
run;


SepalLength    =  SepalWidth PetalLength PetalWidth Setosa Virginica;

ods graphics on;
proc princomp plots=all data=iris2;
   var SepalWidth PetalLength PetalWidth Setosa Virginica;
run;
ods graphics off;


data iris2;
  set iris(keep= PetalWidth PetalLength);
   PetalWidth_z = ( (PetalWidth-11.99333333)/7.62237669);
   PetalLength_z= ( (PetalLength - 37.58000000)/17.65298233 );
   Prin_1= PetalLength * 0.707107 + PetalWidth* 0.707107; 
   PetalLength_z_neg= - PetalLength_z;
   Prin_2= PetalLength * 0.707107 + PetalWidth- 0.707107;
   prin_line= PetalLength;
run;
