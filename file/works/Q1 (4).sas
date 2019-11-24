*** please use your libname ***;
libname sasdata  "C:\Academy\SAS\file\sasdata";
libname sasdataA "C:\Academy\SAS\file\sasdata1";
libname sasdataB "C:\Academy\SAS\file\sasdata2";
libname sasdataC "C:\Academy\SAS\file\sasdata3";
libname sasdataD "C:\Academy\SAS\file\sasdata4";

proc copy in=sasdata out=work;
  select spanish_bank_student;
run;

*** use the number 997 to divide the data***;
%let prim =997;

proc format;
  value clstfmt
  low - 249   =A
  250 - 499  =B
  500 -749   =C
  800< - high  =D;
run;

data sasdataA.spanish_bank_student
      sasdataB.spanish_bank_student
      sasdataC.spanish_bank_student
      sasdataD.spanish_bank_student
	  err;

    set work.spanish_bank_student;
    cluster = put(mod(Customer_code,997),clstfmt.);

	      if cluster = 'A' then output sasdataA.spanish_bank_student;
    else  if cluster = 'B' then output sasdataB.spanish_bank_student;
	else  if cluster = 'C' then output sasdataC.spanish_bank_student;
	else  if cluster = 'D' then output sasdataD.spanish_bank_student;
	else   output empty;
run;

*** after divide the data, distribute the work to 4 tasks***;
*** TaskA ***;
option autosignon=yes;
option sascmd= "!sascmd";
rsubmit taskA wait=no sysrputsync=yes;
libname sasdata  "C:\Academy\SAS\file\sasdata1";
proc sql;
  create table sasdata.numerator as
    select AVG(age) as Numerator from
	sasdata.spanish_bank_student;
quit;

endrsubmit;

   RDISPLAY;
   RGET taskA;
*** TaskB ***;
   option autosignon=yes;
option sascmd= "!sascmd";
rsubmit taskB wait=no sysrputsync=yes;
libname sasdata  "C:\Academy\SAS\file\sasdata2";
proc sql;
  create table sasdata.numerator as
    select AVG(age) as Numerator from
	sasdata.spanish_bank_student;
quit;

endrsubmit;

   RDISPLAY;
   RGET taskB;
*** TaskC ***;
option autosignon=yes;
option sascmd= "!sascmd";
rsubmit taskC wait=no sysrputsync=yes;
libname sasdata  "C:\Academy\SAS\file\sasdata3";
proc sql;
  create table sasdata.numerator as
    select AVG(age) as Numerator from
	sasdata.spanish_bank_student;
quit;

endrsubmit;

   RDISPLAY;
   RGET taskC;
*** TaskD ***;
option autosignon=yes;
option sascmd= "!sascmd";
rsubmit taskD wait=no sysrputsync=yes;
libname sasdata  "C:\Academy\SAS\file\sasdata4";
proc sql;
  create table sasdata.numerator as
    select AVG(age) as Numerator from
	sasdata.spanish_bank_student;
quit;

endrsubmit;

   RDISPLAY;
   RGET taskD;

LISTTASK _ALL_;

waitfor _all_ taskA taskB taskC taskD;




libname sasdataA slibref=sasdata server=taskA;
libname sasdataB slibref=sasdata server=taskB;
libname sasdataC slibref=sasdata server=taskC;
libname sasdataD slibref=sasdata server=taskD;

data numerator_all;
  set sasdataA.numerator
      sasdataB.numerator
	  sasdataC.numerator
	  sasdataD.numerator
;
run;
proc sql;
   create table average as 
   select AVG(numerator) as ave_age from
     numerator_all;
quit;


*** delete the task windows***;
signoff taskA;
signoff taskB;
signoff taskC;
signoff taskD;

signoff _all_;

*** after these works, the result will be in work.average***
