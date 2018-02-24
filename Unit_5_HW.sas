data LongitudinalStudy;
infile 'C:\Vivek\Data_Science\MSDS-6372-Stats-II\Week-05\HW\HW5_LongitudinalStudy_1.csv' dlm=',' firstobs=2;
input Columnname $ Subject Hours Gender $ Age characteristics_ch1 $ IFITM3;
run;

proc print data=LongitudinalStudy;
run;

proc sort data=LongitudinalStudy;
	by characteristics_ch1 Hours;
run;

/* Calculate the mean and standard error for each X */
proc means data=LongitudinalStudy noprint;
   by characteristics_ch1 Hours;
   var IFITM3;
   output out=meansout mean=mean stderr=stderr;
run;

proc print data=meansout;
run;

/* Reshape the data to contain three Y values for */
/* each X for use with the HILOC interpolation.   */
data reshape(keep=characteristics_ch1 Hours IFITM3 mean stderr);
   set meansout;
   by characteristics_ch1 Hours;

/* Offset the X values to display two groups */
*   if characteristics_ch1='Asymp' then Hours=Hours - 0.08;
*   else if characteristics_ch1='Symp' then Hours=Hours + 0.08;

   IFITM3=mean;
   output;

   IFITM3=mean - stderr;
   output;

   IFITM3=mean + stderr;
   output;
run;

proc print data=reshape;
run;

/* Define the title */
   title1 'Plot Means with Standard Error Bars from Calculated Data for Groups';

/* Define the axis characteristics */
   axis1 offset=(0,0) minor=none value=(t=10 ' ' t=14 ' ');
   axis2 label=(angle=90) order=(10 to 14 by 1) minor=(n=1);

/* Define the symbol characteristics */
   symbol1 interpol=hiloctj color=vibg line=1;
   symbol2 interpol=hiloctj color=depk line=2;

   symbol3 interpol=none color=vibg value=dot height=1.5;
   symbol4 interpol=none color=depk value=dot height=1.5;

/* Define the legend characteristics */
   legend1 label=('Group:') frame;
ods graphics on;
/* Plot the error bars using the HILOCTJ interpolation */
/* and overlay symbols at the means. */
proc gplot data=reshape;
   plot IFITM3*Hours=characteristics_ch1 / haxis=axis1 vaxis=axis2 legend=legend1;
   plot2 mean*Hours=characteristics_ch1 / vaxis=axis2 noaxis nolegend;
run;
quit;
ods graphics off;

ods graphics on;
proc mixed data=LongitudinalStudy plots=all;
class Subject Hours characteristics_ch1;
model IFITM3 = Hours characteristics_ch1 Hours*characteristics_ch1;
repeated Hours / type=CS subject=Subject;
lsmeans Hours*characteristics_ch1 / pdiff tdiff adjust=Tukey slice=hours;
*estimate 'Asymptomatic vs. Symptomatic at HR 0' characteristics_ch1 -1 1 characteristics_ch1*Hours -1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0;
run;
ods graphics off;

ods graphics on;
proc glm data=LongitudinalStudy plots=ALL;
class Subject Hours characteristics_ch1;
model IFITM3 =  Hours characteristics_ch1 Hours*characteristics_ch1 / solution;
lsmeans Hours*characteristics_ch1 /pdiff tdiff adjust=Tukey;
run;
ods graphics off;
