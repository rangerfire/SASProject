
* Project        :  CS593                             ;
* Developer(s)   : Khasha Dehand                                          ;
* Comments       : Multiple regression                                    ;
*                  see cereal load for dataset                            ;
* Dependencies   : libnames.sas                                           ;
*-------------------------------------------------------------------------;

/*
COOKD= Cook�s  influence statistic
* Cook�s  statistic lies above the horizontal reference line at value 4/n *;
COVRATIO=standard influence of observation on covariance of betas
DFFITS=standard influence of observation on predicted value
H=leverage, 
LCL=lower bound of a % confidence interval for an individual prediction. This includes the variance of the error, as well as the variance of the parameter estimates.
LCLM=lower bound of a % confidence interval for the expected value (mean) of the dependent variable
PREDICTED | P= predicted values
RESIDUAL | R= residuals, calculated as ACTUAL minus PREDICTED
RSTUDENT=a studentized residual with the current observation deleted
STDI=standard error of the individual predicted value
STDP= standard error of the mean predicted value
STDR=standard error of the residual
STUDENT=studentized residuals, which are the residuals divided by their standard errors
UCL= upper bound of a % confidence interval for an individual prediction
UCLM= upper bound of a % confidence interval for the expected value (mean) of the dependent variable 
* DFFITS� statistic is greater in magnitude than 2sqrt(n/p);
* Durbin watson around 2 *;
* VIF over 10 multicolinear **;


*/
libname sasdata "/folders/myshortcuts/MyFolders";
data  work.cereal_ds;
set sasdata.cereal_ds;
run;

title " rating: stepwise selection";
proc reg data=cereal_ds  outest=est_cereal ;
     model     rating = sugars fiber shelf  sodium fat protein carbo calories vitamins 
                        / selection=MAXR ;
      OUTPUT OUT=reg_cerealOUT  PREDICTED=   RESIDUAL=Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent=C_rstudent h=lev cookd=Cookd  dffits=dffit
         ;  
    
  quit;
title " rating vs. fat";
proc reg data=cereal_ds  outest=est_cereal ;
     model     rating = fat   
                        /   ;
      OUTPUT OUT=reg_cerealOUT  PREDICTED=   RESIDUAL=Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent=C_rstudent h=lev cookd=Cookd  dffits=dffit
         ;  
    
  quit;

data cereal_ds2;
  set cereal_ds;
  if shelf=1 then shelf1=1;
  else  shelf1=0;
  if shelf=2 then shelf2=1;
  else  shelf2=0; 
run;


title " rating: stepwise selection";
proc reg data=cereal_ds2  outest=est_cereal ;
     model     rating = shelf1 shelf2;
      OUTPUT OUT=reg_cerealOUT  PREDICTED=   RESIDUAL=Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent=C_rstudent h=lev cookd=Cookd  dffits=dffit
         ;  
    
  quit;
/* https://wenku.baidu.com/view/d1479c2cbe1e650e52ea99b7.html
*/
proc reg data=cereal_ds;
	model rating = sugars fiber protein;
 	OUTPUT OUT=reg_cerealOUT  h=lev cookd=Cookd  dffits=dffit;
run;
quit;

proc univariate data = reg_cerealOUT;
 	var lev cookd dffit;
run;  

proc standard data= cereal_ds2(keep=rating sugars fiber protein)
Mean=0 std=1
out= cereal_ds2;
var rating sugars fiber protein;
run;

proc reg data=cereal_ds;
	model rating = fiber protein / stb;
 	OUTPUT OUT=reg_cerealOUT  h=lev cookd=Cookd  dffits=dffit
 	L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95;
run;
quit;









