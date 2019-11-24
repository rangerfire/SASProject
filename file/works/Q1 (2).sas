*** please use your libname ***;
libname sasdata "C:\Academy\SAS\file\sasdata";
proc copy in = sasdata out = work;
select cereal_ds;
run;

proc univariate data = cereal_ds normaltest plot;
  var rating sodium;
run;

title 'Midterm2 ';
proc reg data = cereal_ds outest = cerealest_rating ;
     model rating = sodium /VIF dwProb STB ;
	 OUTPUT OUT = regout_cerealest_rating  PREDICTED = predict   RESIDUAL = Res L95M = l95m  U95M = u95m  L95 = l95 U95 = u95
       rstudent = rstudent h = lev cookd = Cookd  dffits = dffit
     STDP = s_predicted  STDR = s_residual  STUDENT = student     ;  
  quit;
