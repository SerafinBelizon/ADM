/* Creamos la libreria */
libname lib  '/home/serafinbelizon0/serafinbelizongomez/my_project';

/* Para que nos permita usar caracteres especiales */
options validvarname=any;

/* Realizamos el paso data */
data banco (drop= duration y);
	set lib.bank_additional_full;
	
	if y = 'yes' then SUSCRITO = 1;
		else if y = 'no' then SUSCRITO = 0;
run;

/* Analisis frecuencias */
proc freq data=banco;
run;


data banco (drop=age job marital education default housing loan contact month day_of_week pdays previous 
'emp.var.rate'n 'cons.price.idx'n 'cons.conf.idx'n euribor3m 'nr.employed'n);
	set banco;
	
	/* Tramificamos la edad */
	if age < 18 then DELETE;
		else if age >=18 and age <= 30 then nAGE = 1; /* de 18 a 30 */
		else if age > 30 and age <= 40 then nAGE = 2; /* de 30 a 40 */
		else if age > 40 and age <= 50 then nAGE = 3; /* de 40 a 50 */
		else if age > 50 and age <= 60 then nAGE = 4; /* de 50 a 60 */
		else if age > 60 then nAGE = 5; /* de 61 o mas */

	/* Codificamos variable de trabajo */
	if job = 'admin.' then nJOB = 1;
		else if job = 'blue-collar' then nJOB = 2;
		else if job = 'entrepreneur' then nJOB = 3;
		else if job = 'housemaid' then nJOB = 4;
		else if job = 'management' then nJOB = 5;
		else if job = 'retired' then nJOB = 6;
		else if job = 'self-employed' then nJOB = 7;
		else if job = 'services' then nJOB = 8;
		else if job = 'student' then nJOB = 9;
		else if job = 'technician' then nJOB = 10;
		else if job = 'unemployed' then nJOB = 11;
		else if job = 'unknown' then nJOB = 1;
		
	/* Codificamos variable de estado civil */
	if marital = 'divorced' then nMAR = 1;
		else if marital = 'married' then nMAR = 2;
		else if marital = 'single' then nMAR = 3;
		else if marital = 'unknown' then nMAR = 2;

	/* Codificamos variable de educacion */
	if education = 'basic.4y' then nEDU = 1;
		else if education = 'basic.6y' then nEDU = 2;
		else if education = 'basic.9y' then nEDU = 3;
		else if education = 'high.school' then nEDU = 4;
		else if education = 'illiterate' then DELETE;
		else if education = 'professional.course' then nEDU = 5;
		else if education = 'university.degree' then nEDU = 6;
		else if education = 'unknown' then nEDU = 6;

		
	/* Codificamos variable de contacto */
	if contact = 'cellular' then nCON = 0;
		else if contact = 'telephone' then nCON = 1;

	/* Codificamos variable de mes */
	if month = 'mar' then nMON = 1;
		else if month = 'apr' then nMON = 2;
		else if month = 'may' then nMON = 3;
		else if month = 'jun' then nMON = 4;
		else if month = 'jul' then nMON = 5;
		else if month = 'aug' then nMON = 6;
		else if month = 'sep' then nMON = 7;
		else if month = 'oct' then nMON = 8;
		else if month = 'nov' then nMON = 9;
		else if month = 'dec' then nMON = 10;
		
		
	/* Agrupamos valores con poca frecuencia */
	if campaign > 5 then campaign = 6;
	
	/* Codificamos variable pdays */
	if pdays = 999 then nPD = 0;
		else nPD = 1;
		
	/* Codificamos variable previous */
	if previous = 0 then nPRE = 0;
		else nPRE = 1;
	
	/* Renombramos y tramificamos variables con caracteres especiales */
	emp_var_rate = 'emp.var.rate'n;
	/* Tramificamos la emp.var.rate */
	if emp_var_rate > -3.5 and emp_var_rate <= -1.8 then nEVR = 1;
		else if emp_var_rate > -1.8 and emp_var_rate <= 1.1 then nEVR = 2; 
		else if emp_var_rate > 1.1 and emp_var_rate <= 1.4 then nEVR = 3; 
		
	cons_price_idx = 'cons.price.idx'n;
	/* Tramificamos la variable */
	if cons_price_idx > 92.200 and cons_price_idx <= 93.369	 then nCPI = 1;
		else if cons_price_idx > 93.369 and cons_price_idx <= 93.918 then nCPI = 2;
		else if cons_price_idx > 93.918 and cons_price_idx <= 94.767 then nCPI = 3;

	cons_conf_idx = 'cons.conf.idx'n;
	/* Tramificamos la variable */
	if cons_conf_idx > -51 and cons_conf_idx <= -42.7	 then nCCI = 1;
		else if cons_conf_idx > -42.7 and cons_conf_idx <= -37.5 then nCCI = 2; 
		else if cons_conf_idx > -37.5 and cons_conf_idx <= -26.9 then nCCI = 3; 
	
	/* Tramificamos y codificamos variable euribor */
	if euribor3m > 0 and euribor3m < 1 then nEUR = 1;
		else if euribor3m > 0.99 and euribor3m <= 2 then nEUR = 2;
		else if euribor3m > 2 then nEUR = 3;
	
	/* Renombramos variables con caracteres especiales */
	nr_employed = 'nr.employed'n;
	if nr_employed > 4962 and nr_employed <= 5099.1 then nNRE = 1;
		else if nr_employed > 5099.1	 and nr_employed <= 5195.8 then nNRE = 2; 
		else if nr_employed > 5195.8 and nr_employed <= 5228.1 then nNRE = 3; 
run;




ods listing close; 
ods listing gpath="/home/serafinbelizon0/serafinbelizongomez/data_output";
/*Construccion Modelo optimo*/
%let ruta1 = '/home/serafinbelizon0/serafinbelizongomez/data_output/macro01.txt';
%put &ruta1;

%macro primera;
	data;  file &ruta1. ; run;
	%do semilla=12355 %to 12365;
		ods output   SelectionSummary=modelos;
		ods output    SelectedEffects=efectos;
		ods output    Glmselect.SelectedModel.FitStatistics=ajuste;
		proc glmselect data=banco plots=all seed=&semilla;
		  partition fraction(validate=0.4);
		  class nAGE nJOB nMAR nEDU nCON nMON 
		  campaign nPD nPRE nEVR nCPI nEUR nNRE;
			
		  model SUSCRITO = nAGE nJOB nMAR nEDU nCON nMON 
		  campaign nPD nPRE nEVR nCPI nEUR nNRE
		  / selection=stepwise(select=aic choose=validate) details=all stats=all;
		run;
		ods graphics off;   
		ods html close;   
		data union; i=12; set efectos; set ajuste point=i; run; *observación 12 ASEval;
		data;semilla=&semilla.;
		file &ruta1. mod;
		set union;put effects @80 nvalue1 @95 semilla;run;
	%end;
%mend;
/* Ejecutamos macro */
%primera;


%let ruta2 = '/home/serafinbelizon0/serafinbelizongomez/data_output/macro02.txt';
%macro segunda;
data; file &ruta2. ;run;
	%do semilla=12355 %to 12365;
		ods output SelectionSummary=modelos;
		ods output SelectedEffects=efectos;
		ods output Glmselect.SelectedModel.FitStatistics=ajuste;
		proc glmselect data=banco plots=all seed=&semilla;
		  partition fraction(validate=0.4);
		  class nAGE nJOB nMAR nEDU nCON nMON 
		  campaign nPD nPRE nEVR nCPI nEUR nNRE;
			
		  model SUSCRITO = nAGE nJOB nMAR nEDU nCON nMON 
		  campaign nPD nPRE nEVR nCPI nEUR nNRE
		  nEDU*nJOB nJOB*nNRE nJOB*nEUR 
		   / selection=stepwise(select=aic choose=validate) details=all stats=all; run;   
		ods graphics off;   
		ods html close;   
		data union;i=12;set efectos;set ajuste point=i;run;
		data;semilla=&semilla;file &ruta2. mod;set union;put effects @80 nvalue1 @95 semilla;run;
	%end;
%mend;
/* Ejecutamos macro */
%segunda;


%let ruta3 = '/home/serafinbelizon0/serafinbelizongomez/data_output/macro03.txt';
%macro tercera;
	data;file &ruta3. ;run;
	%do frac=3 %to 5;
		data;fra=&frac/10;call symput('porcen',left(fra));run;
		%do semilla=12355 %to 12365;
			ods output   SelectionSummary=modelos;
			ods output    SelectedEffects=efectos;
			ods output    Glmselect.SelectedModel.FitStatistics=ajuste;
			proc glmselect data=banco plots=all seed=&semilla;
			  partition fraction(validate=&porcen);
			  class nAGE nJOB nMAR nEDU nCON nMON 
			  campaign nPD nPRE nEVR nCPI nEUR nNRE;
				
			  model SUSCRITO = nAGE nJOB nMAR nEDU nCON nMON 
			  campaign nPD nPRE nEVR nCPI nEUR nNRE
			  nEDU*nJOB nJOB*nNRE nJOB*nEUR 
			   / selection=stepwise(select=aic choose=validate) details=all stats=all;
			run;   
			ods graphics off;   
			ods html close;   
			data union;i=12;set efectos;set ajuste point=i;run;
			data;fra=&frac/10;semilla=&semilla;
			file &ruta3. mod;
			set union;put effects @80 nvalue1 @90 fra @95 semilla;;run;
		%end;
	%end;
%mend;
/* Ejecutamos macro */
%tercera;


%let ruta4 = '/home/serafinbelizon0/serafinbelizongomez/data_output/macro04.txt';
%macro tercera_cv;
	data;file &ruta4.; run;
	%do frac=3 %to 5;
		data;fra=&frac/10;call symput('porcen',left(fra));run;
		%do semilla=12355 %to 12365;
			ods output   SelectionSummary=modelos;
			ods output    SelectedEffects=efectos;
			ods output    Glmselect.SelectedModel.FitStatistics=ajuste;
			proc glmselect data=banco plots=all seed=&semilla;
			  partition fraction(validate=&porcen);
			  class nAGE nJOB nMAR nEDU nCON nMON 
			  campaign nPD nPRE nEVR nCPI nEUR nNRE;
				
			  model SUSCRITO = nAGE nJOB nMAR nEDU nCON nMON 
			  campaign nPD nPRE nEVR nCPI nEUR nNRE
			  nEDU*nJOB nJOB*nNRE nJOB*nEUR  
			   / selection=stepwise(select=aic choose=cv) details=all stats=all; run;   
			ods graphics off;  
			ods html close;   
			data union;i=12;set efectos;set ajuste point=i;run;
			data;fra=&frac/10;semilla=&semilla;
			file &ruta4. mod;
			set union;put effects @80 nvalue1 @90 fra @95 semilla;;run;
		%end;
	%end;
%mend;
/* Ejecutamos macro */
%tercera_cv;




/*analisis seleccion modelos*/
/*Vamos a ver cuantas veces sale como mejor modelo cada uno de ellos*/
data seleccion;
length modelo $90;
input modelo $ 1-76 ase frac semilla;
cards;
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nEUR                               0.080168       12355
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nEUR                               0.077519       12356
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nEUR                               0.079484       12357
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nEUR                               0.077803       12358
Intercept nCON nMON nPD nPRE nEVR nCPI nEUR                                    0.080250       12359
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nEUR                               0.078880       12360
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nEUR                               0.080309       12361
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nEUR                               0.079952       12362
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nEUR                               0.077044       12363
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nEUR                      0.076192       12364
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nEUR                      0.078856       12365
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.080173       12355
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.077753       12356
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nNRE nJOB*nEUR                     0.079599       12357
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                          0.077914       12358
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                          0.080307       12359
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.078945       12360
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.080268       12361
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.079991       12362
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.077148       12363
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.076090       12364
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.079051       12365
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.081068  0.3  12355
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.076499  0.3  12356
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.079936  0.3  12357
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.078166  0.3  12358
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.082762  0.3  12359
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.079358  0.3  12360
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.080399  0.3  12361
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                          0.079645  0.3  12362
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.075750  0.3  12363
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.077580  0.3  12364
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.079972  0.3  12365
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.080173  0.4  12355
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.077753  0.4  12356
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nNRE nJOB*nEUR                     0.079599  0.4  12357
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                          0.077914  0.4  12358
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                          0.080307  0.4  12359
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.078945  0.4  12360
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.080268  0.4  12361
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.079991  0.4  12362
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.077148  0.4  12363
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.076090  0.4  12364
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.079051  0.4  12365
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.079987  0.5  12355
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.078816  0.5  12356
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                          0.078388  0.5  12357
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.078545  0.5  12358
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                          0.079386  0.5  12359
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.078658  0.5  12360
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.080004  0.5  12361
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.079382  0.5  12362
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.077931  0.5  12363
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.077279  0.5  12364
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.078623  0.5  12365
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.078677  0.3  12355
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                          0.080736  0.3  12356
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.080484  0.3  12357
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.079238  0.3  12358
Intercept nEDU nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.076551  0.3  12359
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.078715  0.3  12360
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.078733  0.3  12361
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.080345  0.3  12362
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.076677  0.3  12363
Intercept nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                      0.073484  0.3  12364
Intercept nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                      0.079388  0.3  12365
Intercept nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                      0.078125  0.4  12355
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.078616  0.4  12356
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                          0.079300  0.4  12357
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                          0.078627  0.4  12358
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                          0.079279  0.4  12359
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.077146  0.4  12360
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.079368  0.4  12361
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.079521  0.4  12362
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.080004  0.4  12363
Intercept nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                      0.078413  0.4  12364
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.078751  0.4  12365
Intercept nAGE nCON nMON nPD nPRE nEVR nCPI nNRE                               0.077290  0.5  12355
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.080957  0.5  12356
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.077578  0.5  12357
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.077748  0.5  12358
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.080160  0.5  12359
Intercept nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                 0.078552  0.5  12360
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.079939  0.5  12361
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.077997  0.5  12362
Intercept nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR                      0.079063  0.5  12363
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.079725  0.5  12364
Intercept nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR                               0.079760  0.5  12365
;


proc sort data=seleccion; by modelo;
proc print data=seleccion;
proc freq data=seleccion; tables modelo;run;




/* modelo 1 */ 
proc glmselect data=banco plots=all;
	class nAGE nJOB nCON nMON 
	campaign nPD nPRE nEVR nCPI nEUR; 
	model SUSCRITO = nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR
	/ selection=none details=all  stats=all;
run;   



/* modelo 2 */ 
proc glmselect data=banco plots=all;
	class nJOB nCON nMON nPD 
	nPRE nEVR nCPI nEUR; 
	model SUSCRITO = nCON nMON nPD nPRE nEVR nCPI nJOB*nEUR
	/ selection=none details=all  stats=all;
run;   




/* modelo 2 analais GLM*/ 
proc glm data=banco;
	class nAGE nJOB nCON nMON 
	campaign nPD nPRE nEVR nCPI nEUR; 
	model SUSCRITO = nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR
	/ solution e;
run;






/* Con el modelo seleccionado, predecimos los valores */
proc glm data=banco;
	class nAGE nJOB nCON nMON ;
	model SUSCRITO = nAGE nCON nMON campaign nPD nPRE nEVR nCPI nJOB*nEUR;
	output out=banco_pred p=SUSCRITO_PRED r=resid stdr=eresid;
run;




/* Nos quedamos con el 10% (4116 muestras) de los mejores resultados */
proc sql outobs=4116;
	CREATE TABLE seleccion10 AS 
		SELECT * 
		FROM banco_pred
		WHERE resid > 0
		ORDER BY SUSCRITO_PRED DESC;
run;
/* Imprimimos resultado */
proc print data=seleccion10 (obs=10);


/* Nos quedamos con el 5% de una muestra aleatoria */
proc surveyselect 
	data=banco_pred 
	out=seleccion5  
	seed=1234 
	method=srs 
	rate=.05;	
run;
/* Imprimimos resultado */
proc print data=seleccion5 (obs=10);



