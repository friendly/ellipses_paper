// javascript array

var figlist = [
  {  fignum: " 2",	src: "fig/galton-reg3.png",		code: "SAS/galton-reg3.sas" },       
  {  fignum: " 3",	src: "fig/scatirisd1.png",			code: "SAS/scatirisd.sas" },          
  {  fignum: " 4",	src: "fig/ellipses-demo.png",		code: "R/ellipses-demo.R" },       
  {  fignum: " 5",	src: "fig/vis-reg-prestige1.png",	code: "R/vis-reg-prestige.R" }, 
  {  fignum: " 6",	src: "fig/contiris3.png",			code: "SAS/contiris.sas" },            
  {  fignum: " 7",	src: "fig/between-within1.png",	code: "R/between-within.R" },    
  {  fignum: " 8",	src: "fig/between-HE1.png",		code: "R/between-within.R" },        
  {  fignum: " 9",	src: "fig/levdemo21.png",			code: "SAS/levdemo2.sas" },                 
  {  fignum: "11",	src: "fig/vis-reg-coffee11.png",	code: "R/vis-reg-coffee1.R" },  
  {  fignum: "12",	src: "fig/vis-reg-coffee12a.png",	code: "R/vis-reg-coffee1.R" }, 
  {  fignum: "13",	src: "fig/vis-reg-coffee13.png",	code: "R/vis-reg-coffee1.R" },  
  {  fignum: "14",	src: "fig/coffee-stress1.png",		code: "R/coffee-stress.R" },        
  {  fignum: "15",	src: "fig/coffee-measerr.png", 	code: "R/coffee-measerr.R" },     
  {  fignum: "16",	src: "fig/coffee-avplot1.png", 	code: "R/coffee-avPlots.R" },     
  {  fignum: "17",	src: "fig/coffee-av3D-1.png",		code: "R/coffee-av3D.R" },         
  {  fignum: "18",	src: "fig/coffee-avplot3.png",		code: "R/coffee-avPlots.R" },       
  {  fignum: "19",	src: "fig/mtests.png",				code: "R/mtests.R" },                     
  {  fignum: "20",	src: "fig/heplot3a.png",			code: "SAS/heplot3a.sas" },             
  {  fignum: "21",	src: "fig/HE-contrasts-iris.png",	code: "R/HE-contrasts-iris.R" }, 
  {  fignum: "22",	src: "fig/HE-can-iris.png",		code: "R/HE-can-iris.R" },             
  {  fignum: "23",	src: "fig/kiss-demo.png",			code: "R/kiss-demo.R" },               
  {  fignum: "24",	src: "fig/kiss-demo2a.png",		code: "R/kiss-demo2.R" },            
  {  fignum: "25",	src: "fig/ridge-demo.png",			code: "R/ridge-demo.R" },             
  {  fignum: "26",	src: "fig/ridge2.png",				code: "R/ridge2.R" },                           
  {  fignum: "27",	src: "fig/hsbmix41.png",			code: "SAS/hsbmix4.sas" },              
  {  fignum: "28",	src: "fig/hsbmix43.png",			code: "SAS/hsbmix4.sas" },              
  {  fignum: "29",	src: "fig/mvmeta2a.png",			code: "R/mvmeta2.R" },                    
  {  fignum: "A.1",	src: "fig/gell3d-1.png",			code: "R/gell3d.R" },                  
  {  fignum: "A.2",	src: "fig/inverse.png",			code: "R/inverse.R" },                  
  {  fignum: "A.3",	src: "fig/conjugate1.png",			code: "R/conjugate.R" },             
  {  fignum: "A.4",	src: "fig/ellipse-geneig1.png",	code: "R/ellipse-geneig.R" }     
];


// display one figure in its own table
function Figure(num, src, code, width)
{
	cell = "<table align=center>"
	cell = cell + "<tr><td>Figure " + num + "</td></tr>"
	cell = cell + "<tr><td><a class='lightbox' href='" + code + "'> " + code + "</a></td></tr>"
	cell = cell + "<tr><td><a href='" + src + "'>"
	cell = cell + "<img src='" + src + "' width = " + width +  "></a></td></tr>"
	cell = cell + "</table>"
	return cell
	
}

$(document).ready(function(){
	var width=200;
	var cols=4;
	var table = "<table border=1 cellpadding=2><tr>"
	for (var index=0, figListItem; figListItem = figList[index]; ++i)
	{
		var entry = figlistItem;
		table = table + "<td>" + Figure(entry.fignum, entry.src, entry.code, width)
		table = table + "</td>"
		if (((index+1) % cols==0)) table = table + "</tr><tr>"
	}
	table = table + "</tr></table>"
	var figlistElem = document.getElementById('figlist');
	figlistElem.innerHTML = table;
});