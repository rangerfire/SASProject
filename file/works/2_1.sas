/*please change the right path of the "Spanish_bank_student_acct dataset" on your machine !*/
libname sasdata 'C:\Academy\SAS\file';
data sasdata.test;
set sasdata.spanish_bank_student_acct;
run;

libname sasdata1 'C:\Academy\SAS\file\sasdata1';
libname sasdata2 'C:\Academy\SAS\file\sasdata2';
libname sasdata3 'C:\Academy\SAS\file\sasdata3';
libname sasdata4 'C:\Academy\SAS\file\sasdata4';
/*please change the right path of the " Spanish_bank_student_acct dataset" on your machine !*/

proc copy in = sasdata out = work;
 select test;
run;

proc format;
 value clstfmt
 low - 249 = A
 250 - 499 = B
 500 - 749 = C
 750 - high = D
 ;
run;

data sasdata1.test
      sasdata2.test
      sasdata3.test
      sasdata4.test
      err
      ;
set test(rename = (Customer_code = Customer_codeb));
Customer_code = input(Customer_codeb,12.2);
cluster = put(mod(Customer_code,997),clstfmt.);
 if cluster = 'A' then output sasdata1.test;
 else if cluster = 'B' then output sasdata2.test;
 else if cluster = 'C' then output sasdata3.test;
 else if cluster = 'D' then output sasdata4.test;
 else output err;
run;
