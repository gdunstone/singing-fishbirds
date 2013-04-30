/*
OSC,
The facilitator of communication.
*/

/*all the functions*/

/*SOUND*/
public void freq(float in){
  localfreqModulation=in;
}
public void reverb(float in){
  localreverbvar=in;
}
public void panmod(float in){
  localpanmod=in;
}

/*MECHANICS*/
public void maxspeed(float in){
  localmaxspeed=in;
}
public void separationforce(float in){
  localseparationforce=in;
}
public void alignmentforce(float in){
  localalignmentforce=in;
}
public void cohesionforce(float in){
  localcohesionforce=in;
}
public void separationdistance(float in){
  localseparationdistance=in;
}

public void neighbordist(float in){
  localneighbordist=in;
}
public void visualsize(float in){
  localvisualsize=in;
}
public void framerateFunc(float in){
  localframerate=in;
}

/*xyPad + associated attraction*/

public void location(float yin, float xin){
  localxlocation=xin*width;
  localylocation=height-yin*height;
}
public void toggleAttraction(){
  localxyweight=0.0;
}
public void attraction(float in){
  localxyweight=in;
}

/*VISUAL/RENDERING*/
public void sizemod(float in){
  localsizemod=in;
}
public void sweight(float in){
  localsweight=in;
}
public void hue(float in){
  localhue=in;
}
public void saturation(float in){
  localsaturation=in;
}
public void brightness(float in){
  localbrightness=in;
}
public void alpha(float in){
  localalpha=in;
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

/*RENDERMODES*/
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

/*SOUNDMODES*/
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

/*MISC functions*/
public void startandstop(float in){
  localstartedval=in;
}

public void killtheclient(){
  if(localexitval==0.0){
    localexitval=1.0;
  }
}
public void forexport(float in){
  localforexport=in;
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

/*send the current state back to the device when a message is recieved*/
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

//kill the client
  if(theOscMessage.addrPattern().equals("/visual/killtheclient")) { 
    killtheclient();
  }

//save dat pic!
  if(theOscMessage.addrPattern().equals("/visual/save")) { 
    saveFrame();
  }

//reset attraction on xyPad
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
  OscMessage frameratereturn = new OscMessage("/mech/framerate");
  OscMessage xyreturn = new OscMessage("/mech/xy");

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
  frameratereturn.add(localframerate);

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
    oschost.send(frameratereturn, hostlocation);   

}