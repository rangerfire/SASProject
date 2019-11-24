
libname sasdata "C:\Academy\SAS\file";
proc copy in=sasdata out=work;
select lung;
run;

title " 03-03";
proc reg data=lung  outest=res_lung ;
     model Height_oldest_child = Age_oldest_child Weight_oldest_child Height_mother Weight_mother Height_father Weight_father /p;
  quit;

