*include goptions;
** formated for a slide;
goptions hsize=7in vsize=4in htext=2;
*goptions hsize=3.5in vsize=3.25in htext=2.5 htitle=3;

%include data(galton);
/* 
proc corr;
	var child parent;
	weight frequency;
run;
*/
proc summary data=galton;
	var child parent;
	freq frequency;
	output out=gstats mean=mc mp std=sc sp;
run;
data gstats;
	set gstats;
	drop _type_ _freq_;
	lchild   = mc - sc; uchild=mc + sc;
	lparent  = mp - sp; uparent = mp + sp;
	fac2 = sqrt(2.28); drop fac2;
	lchild2  = mc - fac2*sc; uchild2=mc + fac2*sc;
	lparent2 = mp - fac2*sp; uparent2 = mp + fac2*sp;
proc print data=gstats;

	*-- Define axes;
   axis1 order = (61 to 75 by 2)  label=(a=90 r=0) minor = none;
   axis2 order = (61 to 75 by 2)  offset=(1,2) minor = none;

	*-- Data ellipses;
*include macros(ellipses25);
%ellipses(data=galton, 
	x=child, y=parent, weight=frequency,
	pvalue=.40 .68 .95, std=std, colors=blue red black, line=1 5 20, width=3 2 1,
	out=ellipse, plot=no);


	*-- regression of x on y: fit, then exchange X,Y;
%regline(data=galton,
	y=child, x=parent, weight=frequency,
	color=gray, width=2,
	xmin=62, xmax=74,
	out=regline2
	);
data regline2;
	set regline2;
	drop tmp;
	tmp = y;
	y = x;
	x = tmp;


data arrows;
	retain xsys ysys '2';
	color='black'; line=5; when='A';
	length text $30;
	x = 73;  y= 68.30;  function = 'move    ';  output;
	x = 75;  y= 68.30;  function = 'draw    ';  output;

	x = 74.5; yh = 45.969 + .328*x; 
	x = 73;    y=yh;	function = 'move    ';  output;	
	x = 74.5;  y=yh;	function = 'draw    ';  output;	
	
	x = 71;  y= 72.75;  function = 'move    ';  output;
	x = 75;  y= 72.75;  function = 'draw    ';  output;

	text='r'; size=4;
	x = 74.6;  y=70.2;  function = 'label   ';  output; 
	line=1; size=2.7;
	%arrow(74.3, 68.3, 74.3, yh,  vechead=0.2 0.1, vtoh=4/7);
	%arrow(75,   68.3, 75, 72.75, vechead=0.2 0.1, vtoh=4/7);

	color='blue';
	set gstats(keep=mc lchild uchild lchild2 uchild2);
	drop mc lchild uchild lchild2 uchild2;
/*
	x=lchild; y=62; function = 'move    ';  output;
	x=uchild; y=62; function = 'draw    ';  output;
*/
	hy=62.8; drop hy;
	%arrow(lchild, hy, uchild, hy, vechead=0.1 0.1);
	%arrow(uchild, hy, lchild, hy, vechead=0.1 0.1);
	x = mc; y=hy; position='2'; function='label';
	text = '(0.40) Univariate: mean ± 1s';  output;
/*
	text = '(0.40) Univariate: mean' || '00'x; output;
	style = 'math'; text='G'; x=.;  output;
	style = ' '; text='00'x ||'  1s';  x=.;  output;
*/	

	hy=61.3;
	color='red';
	%arrow(lchild2, hy, uchild2, hy, vechead=0.1 0.1);
	%arrow(uchild2, hy, lchild2, hy, vechead=0.1 0.1);
	x = mc; y=hy; position='2'; function='label';
	text = '(0.68) Bivariate: mean ± 1.5s'; function='label'; output;

	*-- show vertical tangents;
	color='black'; size=1;
	x = lchild2; yh = 45.969 + .328*x;
	y = yh - 1; function='move'; output;
	y = yh + 1; function='draw'; output;
	x = uchild2; yh = 45.969 + .328*x;
	y = yh - 1; function='move'; output;
	y = yh + 1; function='draw'; output;

	run;
*proc print;

	*-- regression of y on x;
%regline(data=galton,
	x=child, y=parent, weight=frequency,
/*	color=red, width=3, */
	color=black, width=2,
	xmin=61, xmax=75,
	in= /* lowess */ ellipse regline2 arrows,
	out=regline	);


*title 'Galton data';
title;
%sunplot(data=galton, x=child, y=parent, count=frequency,
	hsym=3.5,
	vaxis=axis1, haxis=axis2, color=gray,
	anno=regline
	);


