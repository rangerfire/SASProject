libname AA 'c:\Academy\Stevens\2 _CS593\file';	/*please change the right path of the "depression dataset" on your machine !*/
data AA.test;
set AA.depression;
run;
/*
proc print data = AA.test;
run;
*/

data test2;
set AA.test;
keep DRINK HEALTH REG_DOC TREATED BEDDAYS ACUTE_ILLNESS CHRON_ILLNESS;
run;
/*
proc print data = test2;
run;
*/

proc princomp
	data = test2
	out = Work.outp1
	prefix = comp
	outstat = Work.outs1
	;
	var DRINK HEALTH REG_DOC TREATED BEDDAYS ACUTE_ILLNESS CHRON_ILLNESS;
run;
