*-------------------------------------------------------------------------;
* Project        :  Distributed File System                                         ;
* Developer(s)   :  Khasha Dehand                                         ;
* Comments       :  Distribute SAS data over multiple node                  ;
*-------------------------------------------------------------------------;

%let prim=997;

proc format;
  value clstfmt 
     low   - 249  =A
     250  - 499   =B
     500  - 749   =C
     750 -  high  =D
  ;
run;


data sasdataA.Spanish_Bank 
     sasdataB.Spanish_Bank 
     sasdataC.Spanish_Bank 
     sasdataD.Spanish_Bank 
	 empty
	 ;
 set sasdata.Spanish_Bank_student(rename=(Gross_income=Gross_incomeb))
      ;
 Gross_income=input(Gross_incomeb,10.2); 
 cluster =put(mod(Customer_code,997),clstfmt.);
  
        if cluster='A' then output sasdataA.Spanish_Bank ;
   else if cluster='B' then output sasdataB.Spanish_Bank ;
   else if cluster='C' then output sasdataC.Spanish_Bank ;
   else if cluster='D' then output sasdataD.Spanish_Bank ;
   else output empty;
run;

