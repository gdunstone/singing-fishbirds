/*
OSC,
The facilitator of communication.
*/

/*all the functions*/

public void neighbordist(float neighbordistin){
  localneighbordist=neighbordistin;
}
public void freq(float freqModulationin){
  localfreqModulation=freqModulationin;
}
public void reverb(float reverbin){
  localreverbvar=reverbin;
}
public void sizemod(float sizemodin){
  localsizemod=sizemodin;
}
public void sweight(float sweightin){
  localsweight=sweightin;
}
public void panmod(float panmodin){
  localpanmod=panmodin;
}
public void maxspeed(float maxspeedin){
  localmaxspeed=maxspeedin;
}
public void separationforce(float separationforcein){
  localseparationforce=separationforcein;
}
public void alignmentforce(float alignmentforcein){
  localalignmentforce=alignmentforcein;
}
public void cohesionforce(float cohesionforcein){
  localcohesionforce=cohesionforcein;
}
public void separationdistance(float separationdistancein){
  localseparationdistance=separationdistancein;
}
public void attraction(float attractionin){
  localxyweight=attractionin;
}
public void visualsize(float visualsizein){
  localvisualsize=visualsizein;
}
public void hue(float huein){
  localhue=huein;
}
public void saturation(float saturationin){
  localsaturation=saturationin;
}
public void brightness(float brightnessin){
  localbrightness=brightnessin;
}
public void alpha(float alphain){
  localalpha=alphain;
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
}
public void circle(){
  localmode=2.0;
}
public void bezier(){
  localmode=1.0;
}
public void entropic(){
  localmode=0.0;
}

//soundmodes

public void wind(){
  localsoundmodevar=3.0;
}
public void windMONO(){
  localsoundmodevar=2.0;
}
public void some(){
  localsoundmodevar=1.0;
}
public void someINVERT(){
  localsoundmodevar=0.0;
}


public void startandstop(float startedvalin){
  localstartedval=startedvalin;
}

public void killtheclient(){
  if(localexitval==0.0){
    localexitval=1.0;
  }
}

public void forexport(float in){
  localforexport=in;
}

public void savescreenin(){
    saveFrame();
}

/*x & y */

public void location(float ylocationin, float xlocationin){
  localxlocation=xlocationin*width;
  localylocation=height-ylocationin*height;
}

public void toggleAttraction(){
  localxyweight=0.0;
}


/*oscEvent, for stuff that i couldnt oscP5.plug()*/

void oscEvent(OscMessage theOscMessage) {
  /* Debugging stuff */
  /*
  address = theOscMessage.netAddress().address();
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  println("recieved from: "+address);
  */

  //send the current state back to the device
  returnMessage();

/* render modes */
  if(theOscMessage.addrPattern().equals("/visual/rendermode/1/1")) { 
    rainbow();//3
  }
  if(theOscMessage.addrPattern().equals("/visual/rendermode/2/1")) { 
    circle();//2
  }
  if(theOscMessage.addrPattern().equals("/visual/rendermode/3/1")) { 
    bezier();//1
  }
  if(theOscMessage.addrPattern().equals("/visual/rendermode/4/1")) { 
    entropic();//0
  }

/* sound modes */
  if(theOscMessage.addrPattern().equals("/sound/soundmode/1/1")) { 
    wind();//3
      }
  if(theOscMessage.addrPattern().equals("/sound/soundmode/2/1")) { 
    windMONO();//2
  }
  if(theOscMessage.addrPattern().equals("/sound/soundmode/3/1")) { 
    some();//1
  }
  if(theOscMessage.addrPattern().equals("/sound/soundmode/4/1")) { 
    someINVERT();//0
  }

  if(theOscMessage.addrPattern().equals("/visual/killtheclient")) { 
    killtheclient();
  }

/*savescreen*/

  if(theOscMessage.addrPattern().equals("/visual/save")) { 
    savescreenin();
  }

/*attraction reset*/
  if(theOscMessage.addrPattern().equals("/mech/toggleattraction")) { 
    toggleAttraction();
  }
}

/*return messages, this is required to get current states on TouchOSC*/

void returnMessage() {
  xlocationreturn = localxlocation/width;
  ylocationreturn = 1-localylocation/height;

  /*sound plugs*/
  OscMessage freqreturn = new OscMessage("/sound/Freq");
  OscMessage reverbreturn = new OscMessage("/sound/reverb");
  OscMessage panreturn = new OscMessage("/sound/PanWeight");

  /*mech plugs*/
  OscMessage maxspeedreturn = new OscMessage("/mech/maxspeed");
  OscMessage alignmentreturn = new OscMessage("/mech/alignment");
  OscMessage separationreturn = new OscMessage("/mech/separation");
  OscMessage sepdistancereturn = new OscMessage("/mech/sepdistance");
  OscMessage cohesionreturn = new OscMessage("/mech/cohesion");
  OscMessage neighborreturn = new OscMessage("/mech/neighbor");
  OscMessage attractionreturn = new OscMessage("/mech/attraction");

  /*visual plugs*/
  OscMessage sizemodreturn = new OscMessage("/visual/sizemod");
  OscMessage strokeweightreturn = new OscMessage("/visual/strokeweight");
  OscMessage huereturn = new OscMessage("/visual/hue");
  OscMessage saturationreturn = new OscMessage("/visual/saturation");
  OscMessage brightnessreturn = new OscMessage("/visual/brightness");
  OscMessage alphareturn = new OscMessage("/visual/alpha");
  OscMessage visualsizereturn = new OscMessage("/visual/visualsize");
  OscMessage bgalphareturn = new OscMessage("/visual/bgalpha");
  OscMessage bgsaturationreturn = new OscMessage("/visual/bgsaturation");
  OscMessage bghuereturn = new OscMessage("/visual/bghue");
  OscMessage bgbrightnessreturn = new OscMessage("/visual/bgbrightness");
  OscMessage forexportreturn = new OscMessage("/visual/lockbg");
  OscMessage xyreturn = new OscMessage("/mech/xy");
 
  /*buttons*/
  OscMessage startstopreturn = new OscMessage("/radio/startstop/1/1");
  startstopreturn.add(localstartedval);


  freqreturn.add(localfreqModulation);
  panreturn.add(localpanmod);
  reverbreturn.add(localreverbvar);

  neighborreturn.add(localneighbordist);
  sizemodreturn.add(localsizemod);
  strokeweightreturn.add(localsweight);
  separationreturn.add(localseparationforce);
  alignmentreturn.add(localalignmentforce);
  cohesionreturn.add(localcohesionforce);
  maxspeedreturn.add(localmaxspeed);
  sepdistancereturn.add(localseparationdistance);

  visualsizereturn.add(localvisualsize);
  huereturn.add(localhue);
  saturationreturn.add(localsaturation);
  brightnessreturn.add(localbrightness);
  alphareturn.add(localalpha);
  attractionreturn.add(localxyweight);

  bgalphareturn.add(localbackgroundalpha);
  bgsaturationreturn.add(localbgsaturation);
  bghuereturn.add(localbghue);
  bgbrightnessreturn.add(localbgbrightness);
  forexportreturn.add(localforexport);
  xyreturn.add(ylocationreturn);
  xyreturn.add(xlocationreturn);


  //send the message to the client
    oschost.send(freqreturn, hostlocation);
    oschost.send(neighborreturn, hostlocation);
    oschost.send(sizemodreturn, hostlocation);
    oschost.send(strokeweightreturn, hostlocation);
    oschost.send(panreturn, hostlocation);
    oschost.send(separationreturn, hostlocation);
    oschost.send(alignmentreturn, hostlocation);
    oschost.send(cohesionreturn, hostlocation);
    oschost.send(maxspeedreturn, hostlocation);
    oschost.send(sepdistancereturn, hostlocation);
    oschost.send(visualsizereturn, hostlocation);
    oschost.send(huereturn, hostlocation);
    oschost.send(saturationreturn, hostlocation);
    oschost.send(brightnessreturn, hostlocation);
    oschost.send(alphareturn, hostlocation);
    oschost.send(bgalphareturn, hostlocation);
    oschost.send(startstopreturn, hostlocation);
    oschost.send(attractionreturn,hostlocation);
    oschost.send(forexportreturn,hostlocation);
    oschost.send(xyreturn,hostlocation);
    oschost.send(bgsaturationreturn, hostlocation);
    oschost.send(bgbrightnessreturn, hostlocation);
    oschost.send(bghuereturn, hostlocation);    

}