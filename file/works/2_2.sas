
/* E_account && Payroll */
/* taskA */
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskA wait=no sysrputsync=yes;
	libname sasdata "C:\Academy\SAS\file\sasdata1";
	

endrsubmit;

	rdisplay;
/* taskB */
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskB wait=no sysrputsync=yes;
	libname sasdata "C:\Academy\SAS\file\sasdata2";

endrsubmit;

	rdisplay;
/* taskC */
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskC wait=no sysrputsync=yes;
	libname sasdata "C:\Academy\SAS\file\sasdata3";
	

endrsubmit;

	rdisplay;
/* taskD */
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskD wait=no sysrputsync=yes;
	libname sasdata "C:\Academy\SAS\file\sasdata4";
	

endrsubmit;

	rdisplay;

%sysrput pathtaskD=%sysfunc(pathname(work));


/* taskA */
rsubmit taskA wait=no sysrputsync=yes;
/*
	proc sql;
	create table max_income as
		select max(Gross_income) as max_income from 
		sasdata.spanish_bank
		;
	quit;
*/
	proc sql;
	create table numerator1 as 
	select count(*) as numerator
	from sasdata.test
	where E_account = 1 and Payroll = 1;
	quit;

	proc sql;
	create table denom1 as
	select count(*) as denom
	from sasdata.test
	where E_account = 1 or Payroll = 1;
	quit;

	proc sql;
	create table jaccard1 as
	select a.numerator, b.denom
	from numerator1 a, denom1 b;
	quit;

endrsubmit;
/* taskB */
rsubmit taskB wait=no sysrputsync=yes;
	proc sql;
	create table numerator1 as 
	select count(*) as numerator
	from sasdata.test
	where E_account = 1 and Payroll = 1;
	quit;

	proc sql;
	create table denom1 as
	select count(*) as denom
	from sasdata.test
	where E_account = 1 or Payroll = 1;
	quit;

	proc sql;
	create table jaccard1 as
	select a.numerator, b.denom
	from numerator1 a, denom1 b;
	quit;

endrsubmit;
/* taskC */
rsubmit taskC wait=no sysrputsync=yes;
	proc sql;
	create table numerator1 as 
	select count(*) as numerator
	from sasdata.test
	where E_account = 1 and Payroll = 1;
	quit;

	proc sql;
	create table denom1 as
	select count(*) as denom
	from sasdata.test
	where E_account = 1 or Payroll = 1;
	quit;

	proc sql;
	create table jaccard1 as
	select a.numerator, b.denom 
	from numerator1 a, denom1 b;
	quit;

endrsubmit;
/* taskD */
rsubmit taskD wait=no sysrputsync=yes;
	proc sql;
	create table numerator1 as 
	select count(*) as numerator
	from sasdata.test
	where E_account = 1 and Payroll = 1;
	quit;

	proc sql;
	create table denom1 as
	select count(*) as denom
	from sasdata.test
	where E_account = 1 or Payroll = 1;
	quit;

	proc sql;
	create table jaccard1 as
	select a.numerator, b.denom 
	from numerator1 a, denom1 b;
	quit;

endrsubmit;

listtask _all_;
rget taskD;

waitfor _all_ taskA taskB taskC taskD;
*%put &pathtask1;
libname rworkA slibref=work server=taskA;
libname rworkB slibref=work server=taskB;
libname rworkC slibref=work server=taskC;
libname rworkD slibref=work server=taskD;

data bothABCD;
	set rworkA.jaccard1 rworkB.jaccard1 rworkC.jaccard1 rworkD.jaccard1;
run;

proc sql;
	create table jaccard1 as
	select 1 - sum(bothABCD.numerator)/sum(bothABCD.denom) as jaccard_1
	from bothABCD;
quit;

proc print;
run;


signoff taskA;
signoff taskB;
signoff taskC;
signoff taskD;

signoff _all_;



/*E_account && Direct_Debit */


/* taskA */
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskA wait=no sysrputsync=yes;
	libname sasdata "C:\Academy\SAS\file\sasdata1";
	

endrsubmit;

	rdisplay;
/* taskB */
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskB wait=no sysrputsync=yes;
	libname sasdata "C:\Academy\SAS\file\sasdata2";

endrsubmit;

	rdisplay;
/* taskC */
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskC wait=no sysrputsync=yes;
	libname sasdata "C:\Academy\SAS\file\sasdata3";
	

endrsubmit;

	rdisplay;
/* taskD */
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskD wait=no sysrputsync=yes;
	libname sasdata "C:\Academy\SAS\file\sasdata4";
	

endrsubmit;

	rdisplay;

%sysrput pathtaskD=%sysfunc(pathname(work));


/* taskA */
rsubmit taskA wait=no sysrputsync=yes;
/*
	proc sql;
	create table max_income as
		select max(Gross_income) as max_income from 
		sasdata.spanish_bank
		;
	quit;
*/
	proc sql;
	create table numerator1 as 
	select count(*) as numerator
	from sasdata.test
	where E_account = 1 and Direct_Debit = 1;
	quit;

	proc sql;
	create table denom1 as
	select count(*) as denom
	from sasdata.test
	where E_account = 1 or Direct_Debit = 1;
	quit;

	proc sql;
	create table jaccard1 as
	select a.numerator, b.denom
	from numerator1 a, denom1 b;
	quit;

endrsubmit;
/* taskB */
rsubmit taskB wait=no sysrputsync=yes;
	proc sql;
	create table numerator1 as 
	select count(*) as numerator
	from sasdata.test
	where E_account = 1 and Direct_Debit = 1;
	quit;

	proc sql;
	create table denom1 as
	select count(*) as denom
	from sasdata.test
	where E_account = 1 or Direct_Debit = 1;
	quit;

	proc sql;
	create table jaccard1 as
	select a.numerator, b.denom
	from numerator1 a, denom1 b;
	quit;

endrsubmit;
/* taskC */
rsubmit taskC wait=no sysrputsync=yes;
	proc sql;
	create table numerator1 as 
	select count(*) as numerator
	from sasdata.test
	where E_account = 1 and Direct_Debit = 1;
	quit;

	proc sql;
	create table denom1 as
	select count(*) as denom
	from sasdata.test
	where E_account = 1 or Direct_Debit = 1;
	quit;

	proc sql;
	create table jaccard1 as
	select a.numerator, b.denom 
	from numerator1 a, denom1 b;
	quit;

endrsubmit;
/* taskD */
rsubmit taskD wait=no sysrputsync=yes;
	proc sql;
	create table numerator1 as 
	select count(*) as numerator
	from sasdata.test
	where E_account = 1 and Direct_Debit = 1;
	quit;

	proc sql;
	create table denom1 as
	select count(*) as denom
	from sasdata.test
	where E_account = 1 or Direct_Debit = 1;
	quit;

	proc sql;
	create table jaccard1 as
	select a.numerator, b.denom 
	from numerator1 a, denom1 b;
	quit;

endrsubmit;

listtask _all_;
rget taskD;

waitfor _all_ taskA taskB taskC taskD;
*%put &pathtask1;
libname rworkA slibref=work server=taskA;
libname rworkB slibref=work server=taskB;
libname rworkC slibref=work server=taskC;
libname rworkD slibref=work server=taskD;

data bothABCD;
	set rworkA.jaccard1 rworkB.jaccard1 rworkC.jaccard1 rworkD.jaccard1;
run;

proc sql;
	create table jaccard2 as
	select 1 - sum(bothABCD.numerator)/sum(bothABCD.denom) as jaccard_2
	from bothABCD;
quit;

proc print;
run;


signoff taskA;
signoff taskB;
signoff taskC;
signoff taskD;

signoff _all_;





