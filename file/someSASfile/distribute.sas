libname sasdata "D:\sas\sasdata";

libname sasdata1 "D:\sas\sasdata1";
libname sasdata2 "D:\sas\sasdata2";
libname sasdata3 "D:\sas\sasdata3";
libname sasdata4 "D:\sas\sasdata4";

proc copy in=sasdata out=work;
  select income;
run;

proc format;
  value clstfmt
  low - 249   =A
  250 - 499  =B
  500 -749   =C
  800< - high  =D;
run;

data sasdata1.income
      sasdata2.income
      sasdata3.income
      sasdata4.income
	  empty;

    set income(rename = (zipcode = zipcodeb));
    zipcode = input(zipcodeb,12.2);
    cluster = put(mod(zipcode,997),clstfmt.);

	      if cluster = 'A' then output sasdata1.income;
    else  if cluster = 'B' then output sasdata2.income;
	else  if cluster = 'C' then output sasdata3.income;
	else  if cluster = 'D' then output sasdata4.income;
	else   output empty;
run;
