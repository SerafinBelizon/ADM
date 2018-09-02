/* Creamos la libreria */
libname lib  '/home/serafinbelizon0/serafinbelizongomez/my_project';

/* Realizamos el paso data */
data banco (drop= y);
	set lib.bank_additional_full;
	
	if y = 'yes' then SUSCRITO = 1;
		else if y = 'no' then SUSCRITO = 0;	
run;

/* Analisis frecuencias */
proc freq data=banco;
run;




/* ********************* */
/* ANALISIS DE VARIABLES */
/* ********************* */

/* AGE */
/* Analisis variable */
proc univariate data=banco normal plot;
	 var age;
	 qqplot age / NORMAL (MU=EST SIGMA=EST COLOR=RED L=1);
	 HISTOGRAM /NORMAL(COLOR=MAROON W=4) CFILL = BLUE CFRAME = LIGR;
	 INSET MEAN STD /CFILL=BLANK FORMAT=5.2;
run;

/* Analisis variable en funcion de target */
proc sgpanel data=banco;
	title "Histograma de edad por SUSCRITO";
	panelby SUSCRITO / layout=rowlattice;
	histogram age;
	density age;
run;
proc sgpanel data=banco;
	title "Boxplot de edad por SUSCRITO";
	panelby SUSCRITO / layout=rowlattice;
	hbox age;
run;

/* Tramificamos y categorizamos variable age */
data banco (drop=age);
	set banco;
	
	if age < 18 then DELETE;
		else if age >=18 and age <= 30 then nAGE = 1; /* de 18 a 30 */
		else if age > 30 and age <= 40 then nAGE = 2; /* de 30 a 40 */
		else if age > 40 and age <= 50 then nAGE = 3; /* de 40 a 50 */
		else if age > 50 and age <= 60 then nAGE = 4; /* de 50 a 60 */
		else if age > 60 then nAGE = 5; /* de 61 o mas */
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nAGE) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos con one-hot encoding */
*Ordenar las categorias de la variable;
proc sort data=banco; 
	BY nAGE;
run;
*Creacion de varSiables;
data banco (drop=i);
	 set banco;
	 array dummys age_1 - age_5;
	  do i=1 to 5;	 
	   if nAGE = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
*Visualizacion de las variables;
proc freq data=banco; 
	tables nAGE*age_1*age_2*age_3*age_4*age_5
	/  LIST NOCUM; 
run;




/* JOB */
/* Codificamos variable job */
data banco (drop=job);
	set banco;
	
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
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nJOB) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos variable job con one-hot encoding */
*Ordenar las categorias de la variable;
proc sort data=banco; 
	BY nJOB;
run;
*Creacion de variables ;
data banco (drop=i);
	 set banco;
	 array dummys job_1 - job_11;	  
	  do i=1 to 11;
	   if nJOB = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
*Visualizacion de las variables ;
proc freq data=banco; 
	tables nJOB*job_1*job_2*job_3*job_4*job_5*job_6*job_7*job_8*job_9*job_10*job_11
	/  LIST NOCUM; 
run;




/* MARITAL */
/* Codificamos variable marital */
data banco (drop=marital);
	set banco;
	
	if marital = 'divorced' then nMARITAL = 1;
		else if marital = 'married' then nMARITAL = 2;
		else if marital = 'single' then nMARITAL = 3;
		else if marital = 'unknown' then nMARITAL = 2;
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nMARITAL) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos variable marital con one-hot encoding */
*Ordenar las categorias;
proc sort data=banco; 
	BY nMARITAL;
run;
*Creacion de variables;
data banco (drop=i);
	 set banco;
	 array dummys marital_1 - marital_3;
	  do i=1 to 3;
	   if nMARITAL = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
*Visualizacion de las variables ;
proc freq data=banco; 
	tables nMARITAL*marital_1*marital_2*marital_3
	/  LIST NOCUM; 
run;




/* EDUCATION */
/* Codificamos variable education */
data banco (drop=education);
	set banco;
	
	if education = 'basic.4y' then nEDUCATION = 1;
		else if education = 'basic.6y' then nEDUCATION = 2;
		else if education = 'basic.9y' then nEDUCATION = 3;
		else if education = 'high.school' then nEDUCATION = 4;
		else if education = 'illiterate' then DELETE;
		else if education = 'professional.course' then nEDUCATION = 5;
		else if education = 'university.degree' then nEDUCATION = 6;
		else if education = 'unknown' then nEDUCATION = 6;
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nEDUCATION) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos variable education con one-hot encoding */
*Ordenar las categorias;
proc sort data=banco; 
	BY nEDUCATION;
run;
*Creacion de variables;
data banco (drop=i);
	 set banco;
	 array dummys education_1 - education_6;
	  do i=1 to 6;	 
	   if nEDUCATION = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
*Visualizacion de las variables ;
proc freq data=banco; 
	tables nEDUCATION*education_1*education_2*education_3*education_4*education_5*education_6
	/  LIST NOCUM; 
run;




/* DEFAULT */
/* La descartamos por la baja calidad de los datos aportados */




/* HOUSING */
/* Codificamos variable housing */
data banco (drop=housing);
	set banco;
	
	if housing = 'yes' then nHOUSING = 1;
		else if housing = 'no' then nHOUSING = 0;
		else if housing = 'unknown' then nHOUSING = 1;
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nHOUSING) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;




/* LOAN */
/* Codificamos variable loan */
data banco (drop=loan);
	set banco;
	
	if loan = 'yes' then nLOAN = 1;
		else if loan = 'no' then nLOAN = 0;
		else if loan = 'unknown' then nLOAN = 0;
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nLOAN) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;




/* CONTACT */
/* Codificamos variable de contacto */
data banco (drop=contact);
	set banco;
	
	if contact = 'cellular' then nCONTACT = 0;
		else if contact = 'telephone' then nCONTACT = 1;
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nCONTACT) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;




/* MONTH */
/* Codificamos variable month */
data banco (drop=month);
	set banco;
	
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
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nMONTH) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos variable month con one-hot encoding */
*Ordenar las categorias;
proc sort data=banco; 
	BY nMONTH;
run;
*Creacion de variables;
data banco (drop=i);
	 set banco;
	 array dummys month_1 - month_10;
	  do i=1 to 10;	 
	   if nMONTH = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
*Visualizacion de las variables ;
proc freq data=banco; 
	tables nMONTH*month_1*month_2*month_3*month_4*month_5*month_6*month_7*month_8*month_9*month_10
	/  LIST NOCUM; 
run;




/* DAY OF WEEK */
/* Codificamos variable day_of_week */
data banco (drop=day_of_week);
	set banco;
	
	if day_of_week = 'mon' then nDAY = 1;
		else if day_of_week = 'tue' then nDAY = 2;
		else if day_of_week = 'wed' then nDAY = 3;
		else if day_of_week = 'thu' then nDAY = 4;
		else if day_of_week = 'fri' then nDAY = 5;
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nDAY) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos variable month con one-hot encoding */
*Ordenar las categorias;
proc sort data=banco; 
	BY nDAY;
run;
*Creacion de variables;
data banco (drop=i);
	 set banco;
	 array dummys day_1 - day_5;
	  do i=1 to 5;	 
	   if nDAY = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
*Visualizacion de las variables;
proc freq data=banco; 
	tables nDAY*day_1*day_2*day_3*day_4*day_5
	/  LIST NOCUM; 
run;




/* DURATION */
/* Analisis variable */
proc univariate data=banco normal plot;
	 var duration;
	 qqplot duration / NORMAL (MU=EST SIGMA=EST COLOR=RED L=1);
	 HISTOGRAM /NORMAL(COLOR=MAROON W=4) CFILL = BLUE CFRAME = LIGR;
	 INSET MEAN STD /CFILL=BLANK FORMAT=5.2;
run;

/* Analisis variable en funcion de target */
proc sgpanel data=banco;
	title "Histogram of duration by y";
	panelby SUSCRITO / layout=rowlattice;
	histogram duration;
	density duration;
run;
proc sgpanel data=banco;
	title "Boxplot of duration by y";
	panelby SUSCRITO / layout=rowlattice;
	hbox duration;
run;
/* Descartamos la variable duration ya que no aporta información para obtener un modelo predictivo realista */




/* CAMPAIGN */
/* Analisis variable */
proc univariate data=banco normal plot;
	 var campaign;
	 qqplot campaign / NORMAL (MU=EST SIGMA=EST COLOR=RED L=1);
	 HISTOGRAM /NORMAL(COLOR=MAROON W=4) CFILL = BLUE CFRAME = LIGR;
	 INSET MEAN STD /CFILL=BLANK FORMAT=5.2;
run;

/* Analisis variable en funcion de target */
proc sgpanel data=banco;
	title "Histogram of campaign by y";
	panelby SUSCRITO / layout=rowlattice;
	histogram campaign;
	density campaign;
run;
proc sgpanel data=banco;
	title "Boxplot of campaign by y";
	panelby SUSCRITO / layout=rowlattice;
	hbox campaign;
run;

/* Agrupamos valores con poca frecuencia */
data banco;
	set banco;
	if campaign > 5 then campaign = 6;
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (campaign) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos variable campaign con one-hot encoding */
*Ordenar las categorias;
proc sort data=banco; 
	BY campaign;
run;
*Creacion de variables;
data banco (drop=i);
	 set banco;
	 array dummys campaign_1 - campaign_6;
	  do i=1 to 6;	 
	   if campaign = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
*Visualizacion de las variables;
proc freq data=banco; 
	tables campaign*campaign_1*campaign_2*campaign_3*campaign_4*campaign_5*campaign_6
	/  LIST NOCUM; 
run;



/* PDAYS */
/* Analisis variable */
proc univariate data=banco normal plot;
	 var pdays;
	 qqplot pdays / NORMAL (MU=EST SIGMA=EST COLOR=RED L=1);
	 HISTOGRAM /NORMAL(COLOR=MAROON W=4) CFILL = BLUE CFRAME = LIGR;
	 INSET MEAN STD /CFILL=BLANK FORMAT=5.2;
run;

/* Categorizamos variable pdays */
data banco (drop=pdays);
	set banco;
	
	if pdays = 999 then nPDAYS = 0;
		else nPDAYS = 1;
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nPDAYS) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;



/* PREVIOUS */
/* Analisis variable */
proc univariate data=banco normal plot;
	 var previous;
	 qqplot previous / NORMAL (MU=EST SIGMA=EST COLOR=RED L=1);
	 HISTOGRAM /NORMAL(COLOR=MAROON W=4) CFILL = BLUE CFRAME = LIGR;
	 INSET MEAN STD /CFILL=BLANK FORMAT=5.2;
run;

/* Codificamos variable previous */
data banco (drop=previous);
	set banco;
	
	if previous = 0 then nPREVIOUS = 0;
		else nPREVIOUS = 1;
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nPREVIOUS) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;



/* POUTCOME */
/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (poutcome) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;
/* Descartada por la baja calidad de los datos aportados */




/* Para que nos permita usar caracteres especiales */
options validvarname=any;

/* EMP.VAR.RATE */
/* Renombramos variable emp.var.rate */
data banco (drop='emp.var.rate'n);
	set banco;
	emp_var_rate = 'emp.var.rate'n;
run;

/* Analisis variable */
proc univariate data=banco normal plot;
	 var emp_var_rate;
	 qqplot emp_var_rate / NORMAL (MU=EST SIGMA=EST COLOR=RED L=1);
	 HISTOGRAM /NORMAL(COLOR=MAROON W=4) CFILL = BLUE CFRAME = LIGR;
	 INSET MEAN STD /CFILL=BLANK FORMAT=5.2;
run;

/* Tramificamos y codificamos variable emp.var.rate con one-hot encoding */
data banco (drop=emp_var_rate);
	set banco;
	
	/* Tramificamos la emp.var.rate */
	if emp_var_rate > -3.5 and emp_var_rate <= -1.8 then nEMPVARRATE = 1;
		else if emp_var_rate > -1.8 and emp_var_rate <= 1.1 then nEMPVARRATE = 2; 
		else if emp_var_rate > 1.1 and emp_var_rate <= 1.4 then nEMPVARRATE = 3; 

run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nEMPVARRATE) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos variable con one-hot encoding */
/* Ordenar las categorias de la variable */
proc sort data=banco; 
	BY nEMPVARRATE;
run;
/* Creacion de variables */
data banco (drop=i);
	 set banco;
	 array dummys empvarrate_1 - empvarrate_3;
	  do i=1 to 3;	 
	   if nEMPVARRATE = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
/* Visualizacion de las variables */
proc freq data=banco; 
	tables nEMPVARRATE*empvarrate_1*empvarrate_2*empvarrate_3
	/  LIST NOCUM; 
run;




/* CONS.PRICE.IDX */
/* Renombramos variable cons.price.idx */
data banco (drop='cons.price.idx'n);
	set banco;
	cons_price_idx = 'cons.price.idx'n;
run;

/* Analisis variable */
proc univariate data=banco normal plot;
	 var cons_price_idx;
	 qqplot cons_price_idx / NORMAL (MU=EST SIGMA=EST COLOR=RED L=1);
	 HISTOGRAM /NORMAL(COLOR=MAROON W=4) CFILL = BLUE CFRAME = LIGR;
	 INSET MEAN STD /CFILL=BLANK FORMAT=5.2;
run;

/* Analisis variable en funcion de target */
proc sgpanel data=banco;
	title "Histogram of cons_price_idx by y";
	panelby SUSCRITO / layout=rowlattice;
	histogram cons_price_idx;
	density cons_price_idx;
run;
proc sgpanel data=banco;
	title "Boxplot of cons_price_idx by y";
	panelby SUSCRITO / layout=rowlattice;
	hbox cons_price_idx;
run;

/* Tramificamos y codificamos variable cons.price.idx con one-hot encoding */
data banco (drop=cons_price_idx);
	set banco;
	
	/* Tramificamos la variable */
	if cons_price_idx > 92.200 and cons_price_idx <= 93.369	 then nCONSPRICEIDX = 1;
		else if cons_price_idx > 93.369 and cons_price_idx <= 93.918 then nCONSPRICEIDX = 2;
		else if cons_price_idx > 93.918 and cons_price_idx <= 94.767 then nCONSPRICEIDX = 3; 
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nCONSPRICEIDX) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos variable con one-hot encoding */
/* Ordenar las categorias de la variable */
proc sort data=banco; 
	BY nCONSPRICEIDX;
run;
/* Creacion de variables */
data banco (drop=i);
 set banco;
 array dummys conspriceidx_1 - conspriceidx_3;
	  do i=1 to 3;	
	 	if nCONSPRICEIDX = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
/* Visualizacion de las variables */
proc freq data=banco; 
	tables nCONSPRICEIDX*conspriceidx_1*conspriceidx_2*conspriceidx_3
	/  LIST NOCUM; 
run;



/* CONS.CONF.IDX */
/* Renombramos variable cons.conf.idx */
data banco (drop='cons.conf.idx'n);
	set banco;
	cons_conf_idx = 'cons.conf.idx'n;
run;

/* Analisis variable */
proc univariate data=banco normal plot;
	 var cons_conf_idx;
	 qqplot cons_conf_idx / NORMAL (MU=EST SIGMA=EST COLOR=RED L=1);
	 HISTOGRAM /NORMAL(COLOR=MAROON W=4) CFILL = BLUE CFRAME = LIGR;
	 INSET MEAN STD /CFILL=BLANK FORMAT=5.2;
run;

/* Analisis variable en funcion de target */
proc sgpanel data=banco;
	title "Histogram of cons_conf_idx by y";
	panelby SUSCRITO / layout=rowlattice;
	histogram cons_conf_idx;
	density cons_conf_idx;
run;
proc sgpanel data=banco;
	title "Boxplot of cons_conf_idx by y";
	panelby SUSCRITO / layout=rowlattice;
	hbox cons_conf_idx;
run;

/* Tramificamos y codificamos variable cons.conf.idx con one-hot encoding */
data banco (drop=cons_conf_idx);
	set banco;
	
	/* Tramificamos la edad */
	if cons_conf_idx > -51 and cons_conf_idx <= -42.7	 then nCONSCONFIDX = 1;
		else if cons_conf_idx > -42.7 and cons_conf_idx <= -37.5 then nCONSCONFIDX = 2; 
		else if cons_conf_idx > -37.5 and cons_conf_idx <= -26.9 then nCONSCONFIDX = 3; 	
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nCONSCONFIDX) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos variable con one-hot encoding */
/* Ordenar las categorias de la variable */
proc sort data=banco; 
	BY nCONSCONFIDX;
run;
/* Creacion de las variables */
data banco (drop=i);
	 set banco;
	 array dummys consconfidx_1 - consconfidx_3;
	  do i=1 to 3;	 
	   if nCONSCONFIDX = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
/* Visualizacion de las variables */
proc freq data=banco; 
	tables nCONSCONFIDX*consconfidx_1*consconfidx_2*consconfidx_3
	/  LIST NOCUM; 
run;




/* EURIBOR3M */
/* Analisis variable */
proc univariate data=banco normal plot;
	 var euribor3m;
	 qqplot euribor3m / NORMAL (MU=EST SIGMA=EST COLOR=RED L=1);
	 HISTOGRAM /NORMAL(COLOR=MAROON W=4) CFILL = BLUE CFRAME = LIGR;
	 INSET MEAN STD /CFILL=BLANK FORMAT=5.2;
run;

/* Analisis variable en funcion de target */
proc sgpanel data=banco;
	title "Histogram of euribor3m by y";
	panelby SUSCRITO / layout=rowlattice;
	histogram euribor3m;
	density euribor3m;
run;
proc sgpanel data=banco;
	title "Boxplot of euribor3m by y";
	panelby SUSCRITO / layout=rowlattice;
	hbox euribor3m;
run;

/* Codificamos variable euribor3m con one-hot encoding */
data banco (drop=euribor3m);
	set banco;
	
	/* Tramificamos y codificamos variable euribor */
	if euribor3m > 0 and euribor3m < 1 then nEURIBOR = 1;
		else if euribor3m > 0.99 and euribor3m <= 2 then nEURIBOR = 2;
		else if euribor3m > 2 then nEURIBOR = 3;
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nEURIBOR) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos variable con one-hot encoding */
/* Ordenar las categorias */
proc sort data=banco; 
	BY nEURIBOR;
run;
/* Creacion de variables */
data banco (drop=i);
	 set banco;
	 array dummys euribor_1 - euribor_3;
	  do i=1 to 3;	 
	   if nEURIBOR = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
/* Visualizacion de las variables */
proc freq data=banco; 
	tables nEURIBOR*euribor_1*euribor_2*euribor_3
	/  LIST NOCUM; 
run;




/* NR.EMPLOYED */
/* Renombramos variable nr.employed */
data banco (drop='nr.employed'n);
	set banco;
	nr_employed = 'nr.employed'n;
run;

/* Analisis variable */
proc univariate data=banco normal plot;
	 var nr_employed;
	 qqplot nr_employed / NORMAL (MU=EST SIGMA=EST COLOR=RED L=1);
	 HISTOGRAM /NORMAL(COLOR=MAROON W=4) CFILL = BLUE CFRAME = LIGR;
	 INSET MEAN STD /CFILL=BLANK FORMAT=5.2;
run;

/* Analisis variable en funcion de target */
proc sgpanel data=banco;
	title "Histogram of nr_employed by y";
	panelby SUSCRITO / layout=rowlattice;
	histogram nr_employed;
	density nr_employed;
run;
proc sgpanel data=banco;
	title "Boxplot of nr_employed by y";
	panelby SUSCRITO / layout=rowlattice;
	hbox nr_employed;
run;

/* Tramificamos y codificamos variable nr.employed con one-hot encoding */
data banco (drop=nr_employed);
	set banco;
	
	if nr_employed > 4962 and nr_employed <= 5099.1 then nNREMPLOYED = 1;
		else if nr_employed > 5099.1	 and nr_employed <= 5195.8 then nNREMPLOYED = 2; 
		else if nr_employed > 5195.8 and nr_employed <= 5228.1 then nNREMPLOYED = 3; 
run;

/* Analisis variable en funcion de target */
ods noproctitle; 
proc freq data=banco;
	tables  (nNREMPLOYED) *(SUSCRITO) / missing nopercent nocum plots(only)=(freqplot mosaicplot); 
run;

/* Codificamos variable con one-hot encoding */
/* Ordenar las categorias de la variable */
proc sort data=banco; 
	BY nNREMPLOYED;
run;
/* Creacion de variables */
data banco (drop=i);
	 set banco;
	 array dummys nremployed_1 - nremployed_3;
	  do i=1 to 3;	 
	   if nNREMPLOYED = i then dummys(i)= 1; else dummys(i)= 0;
	  end;
run;
/* Visualizacion de las variables */
proc freq data=banco; 
	tables nNREMPLOYED*nremployed_1*nremployed_2*nremployed_3
	/  LIST NOCUM; 
run;




/*Analisis de Correlacion*/
proc corr data=banco;
var SUSCRITO nAGE nJOB nMARITAL nEDUCATION nCONTACT nMONTH campaign 
nPDAYS nPREVIOUS nEMPVARRATE nCONSPRICEIDX nEURIBOR nNREMPLOYED;
run;





/*Macro seleccion modelo: Procedimiento Logistico
t_input  = Tabla Input
vardepen = Variable Dependiente
varindep = Variable(s) Independiente(s)
interaccion  = Variable(s) que interaccionan
semi_ini = Valor Inicial de la semilla
semi_fin = Valor Final de la semilla 
 */
%macro logistic (t_input, vardepen, varindep, interaccion, semi_ini, semi_fin );
ods trace on /listing;
%do semilla=&semi_ini. %to &semi_fin.;

 ods output EffectInModel= efectoslog;		/*Test de Wald de efectos en el modelo*/
 ods output FitStatistics= ajustelog; 		/*"Estadisticos de ajuste", AIC */
 ods output ParameterEstimates= estimalog;	/*"Estimadores de parametro"*/
 ods output ModelBuildingSummary=modelolog;	/*Resumen modelo, efectos*/
 ods output RSquare=ajusteRlog; 			/*R-cuadrado y Max-rescalado R-cuadrado*/

 proc logistic data=&t_input. EXACTOPTIONS (seed=&semilla.) ;
  class &varindep.; 
  model &vardepen. = &varindep. &interaccion. 
     / selection=stepwise details rsquare NOCHECK;
 run;

 data un1; i=12; set efectoslog; set ajustelog; point=i; run;
 data un2; i=12; set un1; set estimalog; point=i; run;
 data un3; i=12; set un2; set modelolog; point=i; run;
 data union&semilla.; i=12; set un3; set ajusteRlog; point=i; run;

 proc append  base=t_models  data=union&semilla.  force; run;
 proc sql; drop table union&semilla.; quit; 

%end;
ods html close; 
proc sql; drop table efectoslog,ajustelog,ajusteRlog,estimalog,modelolog; quit;

%mend;




/* Ejecutamos macro (sin interacciones) */
%logistic (banco, SUSCRITO,
age_1-age_5 job_1-job_11 marital_1-marital_3 education_1-education_6 
nCONTACT month_1-month_10 campaign_1-campaign_6 
nPDAYS nPREVIOUS empvarrate_1-empvarrate_3 
conspriceidx_1-conspriceidx_3 euribor_1-euribor_3 nremployed_1-nremployed_3, ,
12345, 12350);

/*Analisis de los resultados obtenidos de la macro*/
proc freq data=t_models (keep=effect ProbChiSq);  tables effect*ProbChiSq /norow nocol nopercent; run;
proc sql; select distinct * from t_models (keep=effect nvalue1 rename=(nvalue1=RCuadrado)) order by RCuadrado desc; quit;
proc sql; select distinct * from t_models (keep=effect StdErr) order by StdErr;
quit;

/*Tabla de sensibilidad y especificidad para distintos puntos de corte y Curva ROC*/
ods graphics on;
proc logistic data=banco desc  PLOTS(MAXPOINTS=NONE); 
 model SUSCRITO = education_6 euribor_2 euribor_3 month_3 nPDAYS nPREVIOUS 
 /ctable pprob = (.05 to 1 by .05)  outroc=roc;
run;

/* Borramos resultados de ejcucion de macro */
proc sql;
	drop table un1,un2,un3,t_models;
run;





/* Ejecutamos macro (con interacciones varias) */
%logistic (banco, SUSCRITO,
age_1-age_5 job_1-job_11 marital_1-marital_3 education_1-education_6 
nCONTACT month_1-month_10 campaign_1-campaign_6 
nPDAYS nPREVIOUS empvarrate_1-empvarrate_3 
conspriceidx_1-conspriceidx_3 euribor_1-euribor_3 nremployed_1-nremployed_3,
education_1*job_1 education_1*job_2 education_1*job_3 education_1*job_4 education_1*job_5 education_1*job_6 
education_1*job_7 education_1*job_8 education_1*job_9 education_1*job_10 education_1*job_11 
education_2*job_1 education_2*job_2 education_2*job_3 education_2*job_4 education_2*job_5 education_2*job_6 
education_2*job_7 education_2*job_8 education_2*job_9 education_2*job_10 education_2*job_11 
education_3*job_1 education_3*job_2 education_3*job_3 education_3*job_4 education_3*job_5 education_3*job_6 
education_3*job_7 education_3*job_8 education_3*job_9 education_3*job_10 education_3*job_11 
education_4*job_1 education_4*job_2 education_4*job_3 education_4*job_4 education_4*job_5 education_4*job_6 
education_4*job_7 education_4*job_8 education_4*job_9 education_4*job_10 education_4*job_11 
education_5*job_1 education_5*job_2 education_5*job_3 education_5*job_4 education_5*job_5 education_5*job_6 
education_5*job_7 education_5*job_8 education_5*job_9 education_5*job_10 education_5*job_11 
education_6*job_1 education_6*job_2 education_6*job_3 education_6*job_4 education_6*job_5 education_6*job_6 
education_6*job_7 education_6*job_8 education_6*job_9 education_6*job_10 education_6*job_11 
nremployed_1*job_1 nremployed_1*job_2 nremployed_1*job_3 nremployed_1*job_4 nremployed_1*job_5 nremployed_1*job_6 
nremployed_1*job_7 nremployed_1*job_8 nremployed_1*job_9 nremployed_1*job_10 nremployed_1*job_11 
nremployed_2*job_1 nremployed_2*job_2 nremployed_2*job_3 nremployed_2*job_4 nremployed_2*job_5 nremployed_2*job_6 
nremployed_2*job_7 nremployed_2*job_8 nremployed_2*job_9 nremployed_2*job_10 nremployed_2*job_11 
nremployed_3*job_1 nremployed_3*job_2 nremployed_3*job_3 nremployed_3*job_4 nremployed_3*job_5 nremployed_3*job_6 
nremployed_3*job_7 nremployed_3*job_8 nremployed_3*job_9 nremployed_3*job_10 nremployed_3*job_11 
empvarrate_1*nremployed_1 empvarrate_1*nremployed_2 empvarrate_1*nremployed_3 
empvarrate_2*nremployed_2 empvarrate_2*nremployed_2 empvarrate_2*nremployed_3 
empvarrate_3*nremployed_3 empvarrate_3*nremployed_3 empvarrate_3*nremployed_3 
age_1*marital_1 age_1*marital_2 age_1*marital_3 
age_2*marital_1 age_2*marital_2 age_2*marital_3 
age_3*marital_1 age_3*marital_2 age_3*marital_3 
age_4*marital_1 age_4*marital_2 age_4*marital_3 
age_5*marital_1 age_5*marital_2 age_5*marital_3 
marital_1*job_1 marital_1*job_2 marital_1*job_3 marital_1*job_4 marital_1*job_5 marital_1*job_6 
marital_1*job_7 marital_1*job_8 marital_1*job_9 marital_1*job_10 marital_1*job_11 
marital_2*job_1 marital_2*job_2 marital_2*job_3 marital_2*job_4 marital_2*job_5 marital_2*job_6 
marital_2*job_7 marital_2*job_8 marital_2*job_9 marital_2*job_10 marital_2*job_11 
marital_3*job_1 marital_3*job_2 marital_3*job_3 marital_3*job_4 marital_3*job_5 marital_3*job_6 
marital_3*job_7 marital_3*job_8 marital_3*job_9 marital_3*job_10 marital_3*job_11,
12345, 12350);

/*Analisis de los resultados obtenidos de la macro*/
proc freq data=t_models (keep=effect ProbChiSq);  tables effect*ProbChiSq /norow nocol nopercent; run;
proc sql; select distinct * from t_models (keep=effect nvalue1 rename=(nvalue1=RCuadrado)) order by RCuadrado desc; quit;
proc sql; select distinct * from t_models (keep=effect StdErr) order by StdErr;
quit;

/*Tabla de sensibilidad y especificidad para distintos puntos de corte y Curva ROC*/
ods graphics on;
proc logistic data=banco desc  PLOTS(MAXPOINTS=NONE); 
 model SUSCRITO = euribor_1 euribor_2 month_1 month_3 nPDAYS nPREVIOUS 
 /ctable pprob = (.05 to 1 by .05)  outroc=roc;
run;


/* Borramos resultados de ejcucion de macro */
proc sql;
	drop table un1,un2,un3,t_models;
run;



/* Comprobamos la bondad del modelo */
proc logistic data=banco descending;
 model SUSCRITO = euribor_1 euribor_2 month_1 month_3 nPDAYS nPREVIOUS
 / rsquare;
run;


