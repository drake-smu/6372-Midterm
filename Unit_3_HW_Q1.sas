proc means data=growth3 n mean max min range std fw=8;
class Fertilizer;
var Growth;
output out=meansout mean=mean std=std;
title 'Summary of Grass Growth';
run;

proc print data=meansout;
run;

data summarystats;
set meansout;
if _TYPE_=0 then delete;
run;

*This data step creates the necessary data set to plot the mean estimates along with the error bars;
data plottingdata(keep=Fertilizer mean std newvar);                                                                                                      
   set summarystats;
by Fertilizer;
 
   newvar=mean;  
   output;                                                                                                                              
                                                                                                                                        
   newvar=mean - std;                                                                                                                  
   output;                                                                                                                              
                                                                                                                                        
   newvar=mean + std;                                                                                                                  
   output;                                                                                                                              
run;  

proc print data=plottingdata;
run;

*Plotting options to make graph look somewhat decent;
 title1 'Plot Means with Standard Error Bars from Calculated Data for Groups';  

   symbol1 interpol=hiloctj color=vibg line=1;                                                                                          
   symbol2 interpol=hiloctj color=depk line=1;                                                                                          
                                                                                                                                        
   symbol3 interpol=none color=vibg value=dot height=1.5;                                                                               
   symbol4 interpol=none color=depk value=dot height=1.5;  

   axis1 offset=(2,2) ;                                                                                                       
   axis2 label=("Math ACT") order=(0 to 40 by 10) minor=(n=1); 

   *data has to be sorted on the variable which you are going to put on the x axis;
   proc sort data=plottingdata;
   by Fertilizer;
   run;



proc gplot data=plottingdata;
plot NewVar*Fertilizer / vaxis=axis2 haxis=axis1;
*Since the first plot is actually 2 (male female) the corresponding symbol1 and symbol2 options are used which is telling sas to make error bars.  The option is hiloctj;
plot2 Mean*Fertilizer / vaxis=axis2 noaxis nolegend;
*This plot uses the final 2 symbols options to plot the mean points;
run;quit;
*This is the end of the plotting code;

*Running 2way anova analysis;

proc glm data=growth3 PLOTS=(DIAGNOSTICS RESIDUALS);
class Fertilizer;
model growth= Fertilizer / solution clm;
lsmeans Fertilizer / pdiff tdiff CL adjust=bon;
run;

proc mixed data=growth3 PLOTS=(RESIDUALPANEL);
class Fertilizer;
model growth= Fertilizer / clm;
lsmeans Fertilizer / pdiff tdiff CL adjust=bon;
run;


*estimate '1 vs 2' Fertilizer -1 1 0 0;
*estimate '1 vs 3' Fertilizer -1 0 1 0;
*estimate '1 vs 4' Fertilizer -1 0 0 1;
*estimate '2 vs 3' Fertilizer 0 -1 1 0;
*estimate '2 vs 4' Fertilizer 0 -1 0 1;
*estimate '3 vs 4' Fertilizer 0 0 -1 1;
*lsmeans Fertilizer / pdiff tdiff CL adjust=Tukey;
