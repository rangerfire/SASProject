/*PLEASE USE YOUR LIBNAME*/
libname sasdata "C:\Academy\SAS\file";
proc copy in=sasdata out=work;
select lung;
run;

title " 03-01";
proc reg data=lung  outest=est_lung ;
     model FVC_father = Age_father Height_father;
  quit;

