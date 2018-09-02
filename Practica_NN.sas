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

	/* Codificamos variable de housing */
	if housing = 'yes' then nHOUSING = 1;
		else if housing = 'no' then nHOUSING = 0;
		else if housing = 'unknown' then nHOUSING = 1;
		
	/* Codificamos variable de loan */
	if loan = 'yes' then nLOAN = 1;
		else if loan = 'no' then nLOAN = 0;
		else if loan = 'unknown' then nLOAN = 0;
		
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
		
	/* Codificamos variable de dia */
	if day_of_week = 'mon' then nDAY = 1;
		else if day_of_week = 'tue' then nDAY = 2;
		else if day_of_week = 'wed' then nDAY = 3;
		else if day_of_week = 'thu' then nDAY = 4;
		else if day_of_week = 'fri' then nDAY = 5;
		
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
	/* Tramificamos la edad */
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




/* 
	t_input  = Tabla Input
	vardepen = Variable Dependiente
	nparam   = Numero de Parametros
	nnodos   = Numero de Nodos
	semi_ini = Valor Inicial de la semilla
	semi_fin = Valor Final de la semilla
	factiva = funcion de activacion (tanh=tangente hiperbolica; LIN=funcion de activacion lineal).NORMALMENTE PARA DATOS NO LINEALES MEJOR ACT=TANH
	varindep = Variable(s) Independiente(s)
*/
%macro cruzaneural(t_input,vardepen,nparam,nnodos, semi_ini, semi_fin, factiva, varindep);
	data t_output;run;
	%do semilla=&semi_ini. %to &semi_fin.;
	data dos;set &t_input.; u=ranuni(&semilla.); run;
	proc sort data=dos; by u; run;
	
	data dos;
	retain grupo 1;
	set dos nobs=nume;
	if _n_>grupo*nume/&nparam. then grupo=grupo+1;
	run;
	
	data fantasma;run;
	%do exclu=1 %to &nparam.;
	data trestr tresval;
	set dos;if grupo ne &exclu. then output trestr; else output tresval; run;
	
	PROC DMDB DATA=trestr dmdbcat=catatres;
	target &vardepen.;
	var &vardepen. &varindep.; run;
	
	proc neural data=trestr dmdbcat=catatres random=789 
	validata=tresval;
	input &varindep.;
	
	target &vardepen.;
	hidden &nnodos. / act=&factiva.;
	prelim 30;
	train maxiter=1000 outest=mlpest technique=dbldog;
	score data=tresval role=valid out=sal ;
	run;
	
	data sal;set sal;resi2=(p_&vardepen.-&vardepen.)**2;run;
	data fantasma;set fantasma sal;run;
	%end;
	proc means data=fantasma sum noprint;var resi2;
	output out=sumaresi sum=suma;
	run;
	data sumaresi;set sumaresi;semilla=&semilla.;
	data t_output (keep=suma semilla);set t_output sumaresi;if suma=. then delete;run;
	%end;
	proc sql; drop table dos,trestr,tresval,fantasma,mlpest,sumaresi,sal,_namedat; quit;
%mend;



/* Modelo 1 (6 nodos, tangente hiperbolica) */   
%cruzaneural(banco, SUSCRITO, 4, 6, 12345, 12350, tanh,
nAGE nJOB nMARITAL nEDUCATION nCONTACT nMONTH nDAY 
campaign nPDAYS nPREVIOUS nEMPVARRATE nCONSPRICEIDX nEURIBOR nNREMPLOYED);

data modelo1; set t_output; modelo='Modelo 1';
run;


/* Modelo 2 (4 nodos, función lineal) */  
%cruzaneural(banco, SUSCRITO, 4, 4, 12345, 12350, LIN,
nAGE nJOB nMARITAL nEDUCATION nCONTACT nMONTH nDAY 
campaign nPDAYS nPREVIOUS nEMPVARRATE nCONSPRICEIDX nEURIBOR nNREMPLOYED);

data modelo2; set t_output; modelo='Modelo 2';
run;



/*union de las tablas*/ 
data t_output; set modelo1 modelo2; run;
/* Analisis de sumas de los errores */
proc means data=t_output; class modelo; var suma; run;
/* Grafico box plot */
proc boxplot data=t_output; plot suma*modelo; run;




/* ejecucion del modelo */
/* primero carga el catalogo */
proc dmdb data=banco dmdbcat=archivocat;
	target SUSCRITO;
	var  SUSCRITO nAGE nJOB nMARITAL nEDUCATION nCONTACT nMONTH nDAY 
	campaign nPDAYS nPREVIOUS nEMPVARRATE nCONSPRICEIDX nEURIBOR nNREMPLOYED;
run;

/* modelo RNA (el que mejor resultado ha dado es el de 4 nodos, con funcion activacion Linear */
/* ya que presenta menos variabilidad */
proc neural data=banco dmdbcat=archivocat random=789;
	input nAGE nJOB nMARITAL nEDUCATION nCONTACT nMONTH nDAY 
	campaign nPDAYS nPREVIOUS nEMPVARRATE nCONSPRICEIDX nEURIBOR nNREMPLOYED;
	target SUSCRITO;
	hidden 4 / act=LIN;
	prelim 30;
	train maxiter=1000 outest=mlpest technique=dbldog;
	score data=banco role=valid out=sal_prediccion;
run;


