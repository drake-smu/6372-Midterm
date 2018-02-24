data mel;
input Year	Melanoma	Sunspot;
datalines;
1936	1	40
1937	0.9	115
1938	0.8	100
1939	1.4	80
1940	1.2	60
1941	1	40
1942	1.5	23
1943	1.9	10
1944	1.5	10
1945	1.5	25
1946	1.5	75
1947	1.6	145
1948	1.8	130
1949	2.8	130
1950	2.5	80
1951	2.5	65
1952	2.4	20
1953	2.1	10
1954	1.9	5
1955	2.4	10
1956	2.4	60
1957	2.6	190
1958	2.6	180
1959	4.4	175
1960	4.2	120
1961	3.8	50
1962	3.4	35
1963	3.6	20
1964	4.1	10
1965	3.7	15
1966	4.2	30
1967	4.1	60
1968	4.1	105
1969	4	105
1970	5.2	105
1971	5.3	80
1972	5.3	65
;

proc print data=mel;
run;

proc sgplot data=mel;
	title 'melanoma per 100,000 people over time';
	scatter x=Year y=Melanoma;
run;

proc glm data=mel PLOTS=(RESIDUALS);
	title 'Proc GLM OLS (melanoma per 100,000 people over time)';
	model Melanoma=Year;
run;

proc autoreg data=mel plots(unpack);
	title 'Proc Autoreg OLS (melanoma per 100,000 people over time)';
	model Melanoma=Year / dwprob;
run;

proc autoreg data=mel plots(unpack);
	title 'Proc Autoreg AR1 (melanoma per 100,000 people over time)';
	model Melanoma=Year / nlag=1 dwprob;
run;

proc autoreg data=mel plots(unpack);
	title 'Proc Autoreg AR1 (melanoma per 100,000 people over time)';
	model Melanoma=Year / nlag=1 dwprob;
	output out=p p=yhat pm=trendhat lcl=lcl ucl=ucl;
run;


title 'Predictions for Autocorrelation Model';
proc sgplot data=p;
band x=Year upper=ucl lower=lcl;
scatter x=Year y=Melanoma / markerattrs=(color=blue);
series x=Year y=yhat / markerattrs=(color=blue);
series x=Year y=trendhat / markerattrs=(color=black);
run;

data mel2;
Melanoma=.;
do Year = 1973 to 1975; output;
end;
run;

proc print data=mel2;
run;

data mel3;
merge mel mel2;
by year;
run;
proc print data=mel3;
run;

proc autoreg data=mel3 plots(unpack);
	title 'Proc Autoreg AR1 Predict (melanoma per 100,000 people over time)';
	model Melanoma=Year / nlag=1 dwprob;
	output out = Forecast p=yhat pm=ytrend lcl=lower ucl=upper;
run;

proc print data=Forecast;
run;

title 'Predictions for Autocorrelation Model';
proc sgplot data=Forecast;
band x=Year upper=upper lower=lower;
scatter x=Year y=Melanoma / markerattrs=(color=blue);
series x=Year y=yhat / markerattrs=(color=blue);
series x=Year y=ytrend / markerattrs=(color=black);
run;

title 'Predictions for Autocorrelation Model';
proc sgplot data=Forecast;
where Year > 1972;
band x=Year upper=upper lower=lower;
scatter x=Year y=Melanoma / markerattrs=(color=blue);
series x=Year y=yhat / markerattrs=(color=blue);
series x=Year y=ytrend / markerattrs=(color=black);
run;

data mel4;
set mel;
sunspot1=lag1(sunspot);
sunspot2=lag2(sunspot);
sunspot3=lag3(sunspot);
run;

title 'Proc GLM OLS (melanoma per 100,000 people compared with sunspot (with and without lag))';
proc print data=mel4;
run;

proc glm data=mel4 PLOTS=(RESIDUALS);
	title 'Proc GLM OLS (melanoma per 100,000 people compared with sunspot)';
	model Melanoma=sunspot;
run;

proc glm data=mel4 PLOTS=(RESIDUALS);
	title 'Proc GLM OLS (melanoma per 100,000 people compared with sunspot1)';
	model Melanoma=sunspot1;
run;

proc glm data=mel4 PLOTS=(RESIDUALS);
	title 'Proc GLM OLS (melanoma per 100,000 people compared with sunspot2)';
	model Melanoma=sunspot2;
run;

proc glm data=mel4 PLOTS=(RESIDUALS);
	title 'Proc GLM OLS (melanoma per 100,000 people compared with sunspot2)';
	model Melanoma=sunspot3;
run;

proc glm data=mel4 PLOTS=(RESIDUALS);
	title 'Proc GLM OLS (melanoma per 100,000 people compared with sunspot)';
	model Melanoma=Year sunspot Year*sunspot;
run;

proc glm data=mel4 PLOTS=(RESIDUALS);
	title 'Proc GLM OLS (melanoma per 100,000 people compared with sunspot1)';
	model Melanoma=Year sunspot1 Year*sunspot1;
run;

proc glm data=mel4 PLOTS=(RESIDUALS);
	title 'Proc GLM OLS (melanoma per 100,000 people compared with sunspot2)';
	model Melanoma=Year sunspot2 Year*sunspot2;
run;

proc glm data=mel4 PLOTS=(RESIDUALS);
	title 'Proc GLM OLS (melanoma per 100,000 people compared with sunspot2)';
	model Melanoma=Year sunspot3 Year*sunspot3;
run;
