
/*please change the right path of the "depression dataset" on your machine !*/
PROC IMPORT OUT= WORK.test3 
            DATAFILE= "C:\Academy\SAS\file\sasdata\zp.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

libname sasdata 'C:\Academy\SAS\file\sasdata';
libname sasdata1 'C:\Academy\SAS\file\sasdata1';
libname sasdata2 'C:\Academy\SAS\file\sasdata2';
libname sasdata3 'C:\Academy\SAS\file\sasdata3';
libname sasdata4 'C:\Academy\SAS\file\sasdata4';
/*please change the right path of the "depression dataset" on your machine !*/

proc copy in = sasdata out = work;
 select test3;
run;

proc format;
 value clstfmt
 low - 249 = A
 250 - 499 = B
 500 - 749 = C
 750 - high = D
 ;
run;

data sasdata1.test3
      sasdata2.test3
      sasdata3.test3
      sasdata4.test3
      err
      ;
set test3(rename = (zipcode = zipcodeb));
zipcode = input(zipcodeb,12.2);
cluster = put(mod(zipcode,997),clstfmt.);
 if cluster = 'A' then output sasdata1.test3;
 else if cluster = 'B' then output sasdata2.test3;
 else if cluster = 'C' then output sasdata3.test3;
 else if cluster = 'D' then output sasdata4.test3;
 else output err;
run;
