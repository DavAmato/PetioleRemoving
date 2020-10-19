setBatchMode(true);
run("Set Measurements...", "area centroid perimeter bounding fit shape feret's display invert add redirect=None decimal=3");
path = getDirectory("image");
usIndex=lastIndexOf(path,"_");
label=substring(path,usIndex+1);
label=substring(label,0,5);
run("Measure");
run("Clear Results");
saveAs("Results", path+label+".txt");
if(File.exists(path+label+"\\")!=1){
File.makeDirectory(path+label+"\\");
}
if(File.exists(path+"Lamina\\")!=1){
File.makeDirectory(path+"Lamina\\");
} 
list = getFileList(path);
len=((lengthOf(list)-3));

for (i=1; i<=len; i++) {
title=getTitle();
dotIndex=lastIndexOf(title, ".");
ext=substring(title,dotIndex);
title = substring(title,0,dotIndex);
orient=0;
run("8-bit");
setAutoThreshold("Mean");
//run("Threshold...");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Keep Largest Region");
run("Fill Holes (Binary/Gray)");
run("Create Selection");
roiManager("Add");
roiManager("Select", 0);
roiManager("Measure");
width=getResult("Width");
height=getResult("Height");
 if (width<=height) {
      a=width*0.02;
   } 
 else {
      a=height*0.02;
   }  
roiManager("Select", 0);
roiManager("Delete");
IJ.deleteRows(nResults-1, nResults-1);
run("Morphological Filters", "operation=[White Top Hat] element=Square radius=a");
run("Keep Largest Region");
selectWindow(title+"-largest-fillHoles-White-largest");
run("Create Selection");
roiManager("Add");
roiManager("Select", 0);
roiManager("Measure");
petX=getResult("X");
petY=getResult("Y");
IJ.deleteRows(nResults-1, nResults-1);
roiManager("Select", 0);
roiManager("Delete");
imageCalculator("Subtract create", title+"-largest-fillHoles",title+"-largest-fillHoles-White-largest");
selectWindow("Result of "+title+"-largest-fillHoles");
run("Keep Largest Region");
close("Result of "+title+"-largest-fillHoles");
run("Create Selection");
roiManager("Add");
roiManager("Select", 0);
roiManager("Measure");
centrX=getResult("X");
centrY=getResult("Y");
IJ.deleteRows(nResults-1, nResults-1);
run("Select None");
deltaX=petX-centrX;
deltaY=petY-centrY;

if(abs(deltaY)< abs(deltaX)){

	if(deltaX<0){
		run("Rotate 90 Degrees Right");
		run("Rotate 90 Degrees Right");
		orient=1;
	}
}
else {

	if(deltaY<0){
		run("Rotate 90 Degrees Left");
		orient=2;
	}
	else{
		run("Rotate 90 Degrees Right");
		orient=3;
	}
}
roiManager("Select", 0);
roiManager("Delete");
run("Create Selection");
roiManager("Add");
selectWindow(title+ext);
run("Revert");

if(orient==1){
		run("Rotate 90 Degrees Right");
		run("Rotate 90 Degrees Right");
}

if(orient==2){
		run("Rotate 90 Degrees Left");
}

if(orient==3){
		run("Rotate 90 Degrees Right");
}

roiManager("Select", 0);
run("Make Inverse");
setForegroundColor(255, 255, 255);
run("Fill", "slice");
roiManager("Select", 0);
run("Measure");
setResult("Label", nResults-1, label);
setResult("Reps",nResults-1,nResults);
saveAs("XY Coordinates", path+label+"\\"+title+".txt");
roiManager("Delete");
close("\\Others");
saveAs("Tiff", path+"Lamina"+"\\"+title+".tif");
run("Open Next");
run("Select None");

}
saveAs("Results", path+label+".txt");
run("Clear Results");
close();
print("This macro was created and distributed by Davide Amato");
print("All images have been successfully elaborated. Thank you")
