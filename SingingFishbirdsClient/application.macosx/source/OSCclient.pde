/*
OSC,
The facilitator of communication.
*/

OscP5 oscP5;
OscP5 oschost;
NetAddress myRemoteLocation;
NetAddress hostlocation;

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
public void attraction(float attractionin){
  localxyweight=attractionin;
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
public void backgroundalpha(float in){
  localbackgroundalpha=in;
}
public void backgroundhue(float in){
  localbghue=in;
}
public void backgroundsaturation(float in){
  localbgsaturation=in;
}
public void backgroundbrightness(float in){
  localbgbrightness=in;
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

public void location(float ylocationin, float xlocationin){
  println("x variable="+xlocationin);
  localxlocation=xlocationin*width;
  println("y variable="+ylocationin);
  localylocation=height-ylocationin*height;
  returnMessage();
}

public void toggleAttraction(){
  localxyweight=0.0; 
  returnMessage();   
}
