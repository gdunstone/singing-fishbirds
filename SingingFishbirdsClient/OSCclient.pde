/*
OSC,
The facilitator of communication.
*/

OscP5 oscP5;
OscP5 oschost;
NetAddress myRemoteLocation;
NetAddress hostlocation;

public void test( 
  float freqModulationin
  ,float reverbin
  ,float neighbordistin
  ,float sizemodin
  ,float sweightin
  ,float panmodin
  ,float separationforcein
  ,float alignmentforcein
  ,float cohesionforcein
  ,float maxspeedin
  ,float separationdistancein
  ,float soundmodevarin
  ,float visualsizein
  ,float huein
  ,float saturationin
  ,float brightnessin
  ,float alphain
  ,float modein
  ,float startedvalin
  ,float exitvalin
  ,float forexportin
  ,float backgroundalphain
  ,float savescreenin) {

   localfreqModulation = freqModulationin;
   localreverbvar = reverbin;
   localneighbordist = neighbordistin;
   localsizemod = sizemodin;
   localsweight = sweightin;
   localpanmod = panmodin;
   localseparationforce = separationforcein;
   localalignmentforce = alignmentforcein;
   localcohesionforce = cohesionforcein;
   localmaxspeed = maxspeedin;
   localseparationdistance = separationdistancein;
   localsoundmodevar = soundmodevarin;
   localvisualsize = visualsizein;
   localhue = huein;
   localsaturation = saturationin;
   localbrightness = brightnessin;
   localalpha = alphain;
   localmode = modein;
   localstartedval = startedvalin;
   localexitval = exitvalin;
   localforexport = forexportin;
   localbackgroundalpha = backgroundalphain;
   localsavescreen = savescreenin;
}


/*all the values*/

public void neighbordist(float neighbordistin){
  localneighbordist=neighbordistin;
  println(localneighbordist);
}
public void freq(float freqModulationin){
  localfreqModulation=freqModulationin;
  println(localfreqModulation);
}
public void reverb(float reverbin){
  localreverbvar=reverbin;
  println(reverbin);
}
public void sizemod(float sizemodin){
  localsizemod=sizemodin;
  println(sizemodin);
}
public void sweight(float sweightin){
  localsweight=sweightin;
  println(sweightin);
}
public void panmod(float panmodin){
  localpanmod=panmodin;
  println(panmodin);
}
public void maxspeed(float maxspeedin){
  localmaxspeed=maxspeedin;
  println(maxspeedin);
}
public void separationforce(float separationforcein){
  localseparationforce=separationforcein;
  println(separationforcein);
}
public void alignmentforce(float alignmentforcein){
  localalignmentforce=alignmentforcein;
  println(alignmentforcein);
}
public void cohesionforce(float cohesionforcein){
  localcohesionforce=cohesionforcein;
  println(cohesionforcein);
}
public void separationdistance(float separationdistancein){
  localseparationdistance=separationdistancein;
  println(separationdistancein);
}
public void attraction1(float attractionin){
  localxyweight1=attractionin;
  println(attractionin);
}
public void attraction2(float attractionin){
  localxyweight2=attractionin;
  println(attractionin);
}
public void visualsize(float visualsizein){
  localvisualsize=visualsizein;
  println(visualsizein);
}
public void hue(float huein){
  localhue=huein;
  println(huein);
}
public void saturation(float saturationin){
  localsaturation=saturationin;
  println(saturationin);
}
public void brightness(float brightnessin){
  localbrightness=brightnessin;
  println(brightnessin);
}
public void alpha(float alphain){
  localalpha=alphain;
  println(alphain);
}
public void backgroundalpha(float backgroundalphain){
  localbackgroundalpha=backgroundalphain;
  println(backgroundalphain);
}

/*Radio buttons*/

public void rainbow(){
  localmode=3.0;
  println("mode: " +localmode);
}
public void circle(){
  localmode=2.0;
  println("mode: " +localmode);
}
public void bezier(){
  localmode=1.0;
  println("mode: " +localmode);
}
public void entropic(){
  localmode=0.0;
  println("mode: " +localmode);
}
//soundmodes

public void wind(){
  localsoundmodevar=3.0;
  println("mode: " +localsoundmodevar);
}
public void windMONO(){
  localsoundmodevar=2.0;
  println("mode: " +localsoundmodevar);
}
public void some(){
  localsoundmodevar=1.0;
  println("mode: " +localsoundmodevar);
}
public void someINVERT(){
  localsoundmodevar=0.0;
  println("mode: " +localsoundmodevar);
}


public void startandstop(float startedvalin){
  localstartedval=startedvalin;
  println("localstartedvalin");
}
public void killtheclient(){
  if(localexitval==0.0){
    localexitval=1.0;
  }
  else {
  localexitval=0.0; 
  }
}
public void forexport(){
  if (localforexport==0.0)
  {
    localforexport=1.0;
  }
  else
  {
    localforexport=0.0;
  }
  
}

public void savescreenin(){
  if (localsavescreen==0.0){
    localsavescreen=1.0;
  }
  else {
    localsavescreen=0.0;
    }
}

/*x & y */

public void location1(float ylocationin, float xlocationin){
  println("xlocation1="+localxlocation1);
  localxlocation1=xlocationin*width;
  println("ylocation1="+localylocation1);
  localylocation1=height-ylocationin*height;
  returnMessage();
}
public void location2(float ylocationin,float xlocationin){
    println("xlocation2="+localxlocation2);
  localxlocation2=xlocationin*width;
  println("ylocation2="+localylocation2);
  localylocation2=height-ylocationin*height;
  returnMessage();
}

public void toggleAttraction(){
  localxyweight1=0.0; 
  localxyweight2=0.0;
  returnMessage();   
}
