
***please use your libname if different***;
libname sasdata "C:\Academy\SAS\file\sasdata";
proc copy in=sasdata out=work;
select churn;
run;

data2 churn2;
	set churn;
	if churn = "False." then v_churn = 0;
	else v_churn = 1;
	if VMail_plan = "yes" then v_voiceplan = 1;
	else v_voiceplan = 0;

	/*

	**------------plus----------**;
	if CustServ_Calls < 2 then V_CSC = 0;
	else if CustServ_Calls < 4 then V_CSC = 1;
	else V_CSC = 2;

	if CustServ_Calls < 4 and CustServ_Calls > 1 then V_CSCtemp1 = 1;
	else V_CSCtemp1 = 0;
	if CustServ_Calls >=4 then V_CSCtemp2 = 1;
	else V_CSCtemp2 = 0;
	**------------plus----------**; 

	*/
	**------------combine----------**; 
	if CustServ_Calls <4 then V_CSC2 = 0;
	else V_CSC2 = 1;
	**------------combine----------**; 

	if Int_l_Plan = 'no' then V_int = 0;
	else V_int  =1;
run;

proc freq data = churn2;
	table v_churn * v_voiceplan;
run;

proc logistic data = churn2 descending;
	class v_voiceplan(ref='0') / param = ref;
	model v_churn = v_voiceplan;
quit;

/*
**plus---------------**;
proc logistic data = churn2 descending;
	class V_CSCtemp1(ref='0') V_CSCtemp2(ref='0') / param = ref;
	model v_churn = V_CSCtemp1 V_CSCtemp2;
quit;

proc logistic data = churn2 descending;
	class V_CSC(ref='0') / param = ref;
	model v_churn = V_CSC;
quit;
*/

**------------combine----------**; 
proc logistic data = churn2 descending;
	class V_CSC2(ref='0') / param = ref;
	model v_churn = V_CSC2;
quit;
**------------combine----------**; 

proc logistic data = churn2 descending;
	model V_churn = Day_Mins;
quit;

proc logistic data  = churn2 descending;
	class V_int(ref = '0') V_voiceplan(ref = '0') V_CSC2(ref = '0') / param = ref;
	model v_churn = V_int V_voiceplan V_CSC2 Account_Length
			Day_Mins Eve_Mins Night_Mins Intl_Mins;
quit;
/*
	After this proc, we can see the Accunt_Length is less significant -> throw it away
*/

proc logistic data  = churn2 descending;
	class V_int(ref = '0') V_voiceplan(ref = '0') V_CSC2(ref = '0') / param = ref;
	model v_churn = V_int V_voiceplan V_CSC2 /*Account_Length*/
			Day_Mins Eve_Mins Night_Mins Intl_Mins;
quit;
/*
	Now everything is significant -> what model?

So: divide data set to 2 parts, run the logistic and compare the result
*/







/*
	lg(odds)  = -3.92 + 0.013 * Day_Mins

		if Day_mins increase by 1, the odds increase not lineary but e^0.013 times
	


*/




