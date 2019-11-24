data   age_height_weight;
infile datalines;
constant=1;
input Name $ Gender $	Age	Height	Weight;
datalines;
Alfred	M	14	69	    112.5
Alice	F	13	56.5	84
Barbara	F	13	65.3	98
Carol	F	14	62.8	102.5
Henry	M	14	63.5	102.5
James	M	12	57.3	83
Jane	F	12	59.8	84.5
Janet	F	15	62.5	112.5
Jeffrey	M	13	62.5	84
John	M	12	59	    99.5
Joyce	F	11	51.3	50.5
Judy	F	14	64.3	90
Louise	F	12	56.3	77
Mary	F	15	66.5	112
Philip	M	16	72	    150
Robert	M	12	64.8	128
Ronald	M	15	67	    133
Thomas	M	11	57.5	85
William	M	15	66.5	112
;
run;
data ones;
  drop i;
  col1=1;col2=1;col3=1; col4=1;col5=1;col6=1; 
  col7=1;col8=1;col9=1; col10=1;col11=1;col12=1;
   col13=1;col14=1;col15=1; col16=1;col17=1;col18=1;
  col19=1;
    do i=1 to 19;
	 output;
    end;
     
run; 


proc iml;
    use age_height_weight;
    read all var { Age	Height	weight } into x;
    print x;

	use ones;
	 read all var{col1  col2  col3   col4  col5  col6  
                  col7 col8  col9   col10  col11  col12 
                  col13  col14  col15   col16  col17  col18  
                   col19   } into ones;
	 print ones;
     x_center=x-(ones*x)*(1/19);
	 print x_center;

    covar=(x_center`*x_center)*1/18;
	print covar;

quit;

proc corr data=age_height_weight cov;
   var Age	Height	weight;
run;