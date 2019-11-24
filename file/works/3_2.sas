
libname sasdata "C:\Academy\SAS\file";
proc copy in=sasdata out=work;
select depression;
run;

title " 03-02";
proc reg data=depression  outest=est_depression ;
     model cases = income sex age /p;
  quit;

