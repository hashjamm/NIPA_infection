
/* designating library path */

libname a "C:/SAS/NIPA_time_stratified_20231023";

/* data loading */

proc import datafile = "C:/SAS/NIPA_time_stratified_20231023/raw_data_20231023.csv"
 out = raw_data
 dbms = CSV;
run;

data a.raw_data; set raw_data; run;

/* na 값 존재 여부 확인 */
data na_test; set a.raw_data;
if 
lag0_humidity=. or lag7_humidity=. or
lag0_rainfall=. or lag7_rainfall=. or
lag0_sun_hours=. or lag7_sun_hours=. or
lag0_temperature=. or lag7_temperature=. or
lag0_wind_velocity=. or lag7_wind_velocity=. ;
run;

data a.data1; set a.raw_data;
lag0_7_humidity = (lag0_humidity + lag7_humidity)/2;
lag0_7_rainfall = (lag0_rainfall + lag7_rainfall)/2;
lag0_7_sun_hours = (lag0_sun_hours + lag7_sun_hours)/2;
lag0_7_temperature = (lag0_temperature + lag7_temperature)/2;
lag0_7_wind_velocity = (lag0_wind_velocity + lag7_wind_velocity)/2;
run;

proc means data=a.data1 p25 p75;
var
lag0_humidity lag7_humidity lag0_7_humidity
lag0_rainfall lag7_rainfall lag0_7_rainfall
lag0_sun_hours lag7_sun_hours lag0_7_sun_hours
lag0_temperature lag7_temperature lag0_7_temperature
lag0_wind_velocity lag7_wind_velocity lag0_7_wind_velocity;
run;

/*
iqr normalized columns

lag0_humidity lag7_humidity lag0_7_humidity
lag0_rainfall lag7_rainfall lag0_7_rainfall
lag0_sun_hours lag7_sun_hours lag0_7_sun_hours
lag0_temperature lag7_temperature lag0_7_temperature
lag0_wind_velocity lag7_wind_velocity lag0_7_wind_velocity

20.36 20.5 15.975
3.06 2.42 3.35
5.1 4.6 3.35
6.02 5.5 4.71
1.4 1.1 1.05
*/

data a.data2; set a.data1;
lag0_humidity_iqr_nor=lag0_humidity/20.36;
lag7_humidity_iqr_nor=lag7_humidity/20.5;
lag0_7_humidity_iqr_nor=lag0_7_humidity/15.975;
lag0_rainfall_iqr_nor=lag0_rainfall/3.06;
lag7_rainfall_iqr_nor=lag7_rainfall/2.42;
lag0_7_rainfall_iqr_nor=lag0_7_rainfall/3.35;
lag0_sun_hours_iqr_nor=lag0_sun_hours/5.1;
lag7_sun_hours_iqr_nor=lag7_sun_hours/4.6;
lag0_7_sun_hours_iqr_nor=lag0_7_sun_hours/3.35;
lag0_temperature_iqr_nor=lag0_temperature/6.02;
lag7_temperature_iqr_nor=lag7_temperature/5.5;
lag0_7_temperature_iqr_nor=lag0_7_temperature/4.71;
lag0_wind_velocity_iqr_nor=lag0_wind_velocity/1.4;
lag7_wind_velocity_iqr_nor=lag7_wind_velocity/1.1;
lag0_7_wind_velocity_iqr_nor=lag0_7_wind_velocity/1.05;
run;

proc rank data=a.data2 out=a.data3 groups=4; var lag0_humidity; ranks lag0_humidity_g; run;
proc rank data=a.data3 out=a.data3 groups=4; var lag7_humidity; ranks lag7_humidity_g; run;
proc rank data=a.data3 out=a.data3 groups=4; var lag0_7_humidity; ranks lag0_7_humidity_g; run;

proc rank data=a.data3 out=a.data3 groups=4; var lag0_rainfall; ranks lag0_rainfall_g; run;
proc rank data=a.data3 out=a.data3 groups=4; var lag7_rainfall; ranks lag7_rainfall_g; run;
proc rank data=a.data3 out=a.data3 groups=4; var lag0_7_rainfall; ranks lag0_7_rainfall_g; run;

proc rank data=a.data3 out=a.data3 groups=4; var lag0_sun_hours; ranks lag0_sun_hours_g; run;
proc rank data=a.data3 out=a.data3 groups=4; var lag7_sun_hours; ranks lag7_sun_hours_g; run;
proc rank data=a.data3 out=a.data3 groups=4; var lag0_7_sun_hours; ranks lag0_7_sun_hours_g; run;

proc rank data=a.data3 out=a.data3 groups=4; var lag0_temperature; ranks lag0_temperature_g; run;
proc rank data=a.data3 out=a.data3 groups=4; var lag7_temperature; ranks lag7_temperature_g; run;
proc rank data=a.data3 out=a.data3 groups=4; var lag0_7_temperature; ranks lag0_7_temperature_g; run;

proc rank data=a.data3 out=a.data3 groups=4; var lag0_wind_velocity; ranks lag0_wind_velocity_g; run;
proc rank data=a.data3 out=a.data3 groups=4; var lag7_wind_velocity; ranks lag7_wind_velocity_g; run;
proc rank data=a.data3 out=a.data3 groups=4; var lag0_7_wind_velocity; ranks lag0_7_wind_velocity_g; run;

/**analysis**/
/*lag 0*/

/*humidity*/
proc sort data=a.data3; by lag0_humidity_g; run;

proc means data=a.data3; var lag0_humidity; by lag0_humidity_g; run;

proc freq data=a.data3; table influ*lag0_humidity_g; run;

proc logistic data=a.data3;
strata id;
class lag0_humidity_g (ref="0") /param=reference;
model influ(event="1")=lag0_humidity_g;
run;

proc logistic data=a.data3;
strata id;
class /param=reference;
model influ(event="1")=lag0_humidity_g;
run;

/*rainfall*/

/*sun_hours*/

/*temperature*/

/*wind_velocity*/



