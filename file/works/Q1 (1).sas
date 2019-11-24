*** The title of the charts***;
title 'Midterm1 PCA';

***please use your libname if different***;
libname sasdata "C:\Academy\SAS\file\sasdata";
proc copy in=sasdata out=work;
select baseball;
run;
proc univariate data = baseball;
*** The values ***;
 var age games at_bats runs hits doubles triples homeruns RBIs walks strikeouts bat_ave on_base_pct slugging_pct stolen_bases caught_stealing;
 run;
 proc corr data = baseball cov;
  var age games at_bats runs hits doubles triples homeruns RBIs walks strikeouts bat_ave on_base_pct slugging_pct stolen_bases caught_stealing;
 run;
 *** Normalization ***;
 proc standard data = baseball
               mean = 0 std = 1
	           out = baseball_z;
 var age games at_bats runs hits doubles triples homeruns RBIs walks strikeouts bat_ave on_base_pct slugging_pct stolen_bases caught_stealing;
 run;

 proc princomp data = baseball_z out = baseball_pca;
 var age games at_bats runs hits doubles triples homeruns RBIs walks strikeouts bat_ave on_base_pct slugging_pct stolen_bases caught_stealing;
 run;
/*
After these works, we can see the result from the output, so there 4 commponents should be extracted, because these first four components' cumulative is more than 85%
*/ 
