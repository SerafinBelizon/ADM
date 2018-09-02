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
	if marital = 'divorced' then nMARITAL = 1;
		else if marital = 'married' then nMARITAL = 2;
		else if marital = 'single' then nMARITAL = 3;
		else if marital = 'unknown' then nMARITAL = 2;

	/* Codificamos variable de educacion */
	if education = 'basic.4y' then nEDUCATION = 1;
		else if education = 'basic.6y' then nEDUCATION = 2;
		else if education = 'basic.9y' then nEDUCATION = 3;
		else if education = 'high.school' then nEDUCATION = 4;
		else if education = 'illiterate' then DELETE;
		else if education = 'professional.course' then nEDUCATION = 5;
		else if education = 'university.degree' then nEDUCATION = 6;
		else if education = 'unknown' then nEDUCATION = 6;

		
	/* Codificamos variable de contacto */
	if contact = 'cellular' then nCONTACT = 0;
		else if contact = 'telephone' then nCONTACT = 1;

	/* Codificamos variable de mes */
	if month = 'mar' then nMONTH = 1;
		else if month = 'apr' then nMONTH = 2;
		else if month = 'may' then nMONTH = 3;
		else if month = 'jun' then nMONTH = 4;
		else if month = 'jul' then nMONTH = 5;
		else if month = 'aug' then nMONTH = 6;
		else if month = 'sep' then nMONTH = 7;
		else if month = 'oct' then nMONTH = 8;
		else if month = 'nov' then nMONTH = 9;
		else if month = 'dec' then nMONTH = 10;
		
		
	/* Agrupamos valores con poca frecuencia */
	if campaign > 5 then campaign = 6;
	
	/* Codificamos variable pdays */
	if pdays = 999 then nPDAYS = 0;
		else nPDAYS = 1;
		
	/* Codificamos variable previous */
	if previous = 0 then nPREVIOUS = 0;
		else nPREVIOUS = 1;
	
	/* Renombramos y tramificamos variables con caracteres especiales */
	emp_var_rate = 'emp.var.rate'n;
	/* Tramificamos la emp.var.rate */
	if emp_var_rate > -3.5 and emp_var_rate <= -1.8 then nEMPVARRATE = 1;
		else if emp_var_rate > -1.8 and emp_var_rate <= 1.1 then nEMPVARRATE = 2; 
		else if emp_var_rate > 1.1 and emp_var_rate <= 1.4 then nEMPVARRATE = 3; 
		
	cons_price_idx = 'cons.price.idx'n;
	/* Tramificamos la variable */
	if cons_price_idx > 92.200 and cons_price_idx <= 93.369	 then nCONSPRICEIDX = 1;
		else if cons_price_idx > 93.369 and cons_price_idx <= 93.918 then nCONSPRICEIDX = 2;
		else if cons_price_idx > 93.918 and cons_price_idx <= 94.767 then nCONSPRICEIDX = 3;

	cons_conf_idx = 'cons.conf.idx'n;
	/* Tramificamos la variable */
	if cons_conf_idx > -51 and cons_conf_idx <= -42.7	 then nCONSCONFIDX = 1;
		else if cons_conf_idx > -42.7 and cons_conf_idx <= -37.5 then nCONSCONFIDX = 2; 
		else if cons_conf_idx > -37.5 and cons_conf_idx <= -26.9 then nCONSCONFIDX = 3; 
	
	/* Tramificamos y codificamos variable euribor */
	if euribor3m > 0 and euribor3m < 1 then nEURIBOR = 1;
		else if euribor3m > 0.99 and euribor3m <= 2 then nEURIBOR = 2;
		else if euribor3m > 2 then nEURIBOR = 3;
	
	/* Renombramos variables con caracteres especiales */
	nr_employed = 'nr.employed'n;
	if nr_employed > 4962 and nr_employed <= 5099.1 then nNREMPLOYED = 1;
		else if nr_employed > 5099.1	 and nr_employed <= 5195.8 then nNREMPLOYED = 2; 
		else if nr_employed > 5195.8 and nr_employed <= 5228.1 then nNREMPLOYED = 3; 
run;



/* Analisis frecuencias */
proc freq data=banco;
run;




/* MACRO VALIDACIÓN CRUZADA PARA REGRESIÓN NORMAL */
%macro cruzada(archivo,vardepen,ngrupos,varindepen);
	data final; run;
	%do semilla=1234 %to 1250;
	data dos; set &archivo; u=ranuni(&semilla);
	proc sort data=dos; by u; run;
	data dos ; retain grupo 1; set dos nobs=nume;
	 if _n_>grupo*nume/&ngrupos then grupo=grupo+1; run;
	data fantasma; run;
	%do exclu=1 %to &ngrupos;
	data tres; set dos; if grupo ne &exclu then vardep=&vardepen;
	proc reg data=tres noprint;
	model vardep=&varindepen;
	output out=sal p=predi; run;
	data sal;set sal;resi2=(&vardepen-predi)**2;if grupo=&exclu then output;run;
	data fantasma;set fantasma sal;run;
	%end;
	proc means data=fantasma sum noprint; var resi2;
	output out=sumaresi sum=suma; run;
	data sumaresi; set sumaresi; semilla=&semilla;
	data final (keep=suma semilla); set final sumaresi; if suma=. then delete; run;
	%end;
	proc print data=final;run;
%mend;

%cruzada(banco,SUSCRITO,5,nAGE nJOB nMARITAL nEDUCATION nCONTACT nMONTH 
campaign nPDAYS nPREVIOUS nEMPVARRATE nCONSPRICEIDX nEURIBOR nNREMPLOYED);
data final1; set final; modelo=1; run;

%cruzada(banco,SUSCRITO,5,nAGE nJOB nMARITAL nEDUCATION nCONTACT nMONTH 
campaign nPDAYS nPREVIOUS nNREMPLOYED);
data final2; set final; modelo=2; run;

%cruzada(banco,SUSCRITO,5,nAGE nJOB nMARITAL nEDUCATION 
nEMPVARRATE nCONSPRICEIDX nEURIBOR nNREMPLOYED);
data final3; set final; modelo=3; run;

/*estadisticos*/
proc means data=final1; run;
proc means data=final2; run;
proc means data=final3; run;



/* Regresión lineal */
proc reg data=banco;
model SUSCRITO = nAGE nJOB nMARITAL nEDUCATION nCONTACT nMONTH 
campaign nPDAYS nPREVIOUS nEMPVARRATE nCONSPRICEIDX nEURIBOR nNREMPLOYED;
run;


/* Regresión lineal (descartando variables con t-value > 0.05) */
proc reg data=banco;
model SUSCRITO = nAGE nMARITAL nEDUCATION nCONTACT nMONTH 
campaign nPDAYS nPREVIOUS nCONSPRICEIDX nEURIBOR;
run;


