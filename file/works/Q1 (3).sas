*** Multiple Regrssion for Depression dataset ***;
title 'Midterm3';

libname sasdata "C:\Academy\SAS\file\sasdata";
proc copy in=sasdata out=work;
	select depression;
run;
 proc reg data = depression  outest = depressionEst_ ;
   model  Cat_total = INCOME SEX AGE / dwProb STB 
	selection = backward
	selection = stepwise
	selection = MAXR;
   output 	OUT = regout_depression_Cat_t PREDICTED = predict RESIDUAL = Res L95M = l95m U95M = u95m L95 = l95 U95 = u95
   			rstudent = rstudent h = lev cookd = Cookd dffits = dffit STDP = s_predicted STDR = s_residual STUDENT = student     
			;  
  quit;

ods graphics on;
proc reg data =  depression;
   PREDICT: model Cat_total = income sex age / r influence;
   output out = outliers rstudent = rstud h = lev dffits = dfits cookd = cooksd;
   title;
run;
quit;

ods graphics off;
proc reg data=depression 
  plots(label) = (CooksD RStudentByLeverage DFFITS DFBETAS);
  model Cat_total = income sex age / influence;
run;

ods graphics off;
/*
After these works, the result is obvious in the output data.
*/
