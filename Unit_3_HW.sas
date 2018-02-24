data growth1;
input Fertilizer Growth;
datalines;
1    10
2    15
3    8
4    19
1    20
2    25
3    18
4    29
1    12
2    17
3    10
4    21
;

data growth2;
input Fertilizer ENV $ Growth;
datalines;
1  MOSTLY_SHADY  10
2  MOSTLY_SHADY  15
3  MOSTLY_SHADY  8
4  MOSTLY_SHADY  19
1  WETLANDS  20
2  WETLANDS  25
3  WETLANDS  18
4  WETLANDS  29
1  SUNNY  12
2  SUNNY  17
3  SUNNY  10
4  SUNNY  21
;

data growth3;                                                                                                                           
input Fertilizer Growth;                                                                                                                
datalines;                                                                                                                              
1    10
2    15
3    8
4    19
1    20
2    25
3    18
4    29
1    12
2    17
3    10
4    22
;

data growth4;
input Fertilizer ENV $ Growth;
datalines;
1  MOSTLY_SHADY  10
2  MOSTLY_SHADY  15
3  MOSTLY_SHADY  8
4  MOSTLY_SHADY  19
1  WETLANDS  20
2  WETLANDS  25
3  WETLANDS  18
4  WETLANDS  29
1  SUNNY  12
2  SUNNY  17
3  SUNNY  10
4  SUNNY  22
;

proc print data=growth1;
run;

proc print data=growth2;
run;

proc print data=growth3;
run;

proc print data=growth4;
run;

