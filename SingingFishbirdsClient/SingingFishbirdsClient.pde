/*
Copyright (C) 2013, Gareth Dunstone 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, pulverize, distribute, 
synergize, compost, defenestrate, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
subject to the following conditions: 

- The above copyright notice and this permission notice, or one of similar effect, shall be included in all copies or substantial portions of the Software. 

- If the Author of the Software (the "Author") needs a place to crash and you have a sofa available, you should maybe give the Author a break and let him sleep on your couch. 

- If you are caught in a dire situation wherein you only have enough time to save one person out of a group, and the Author is a member of that group, you must save the Author. 

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO BLAH BLAH BLAH ISN'T IT FUNNY HOW UPPER-CASE MAKES IT SOUND 
LIKE THE LICENSE IS ANGRY AND SHOUTING AT YOU?!?

 Flocking Code from:
 http://processing.org/learning/topics/flocking.html
 by Daniel Shiffman

 SuperCollider and oscP5 libraries from: 
 http://www.erase.net/projects/processing-sc/ and http://www.sojamo.de/code/
 With integration by Gareth Dunstone

 Control interface using controlP5 from:
 http://www.sojamo.de/code/

 Other code by Gareth Dunstone
*/

import supercollider.*;

import oscP5.*;
import netP5.*;
  float localfreqModulation = 200;
  float localreverbvar = 1;
  float localneighbordist = 1000.0;
  float localsizemod = 10;
  float localsweight = 1;
  float localpanmod = 1;
  float localseparationforce = 1.5;
  float localalignmentforce = 1.0;
  float localcohesionforce = 1.4;
  float localmaxspeed = 2;
  float localseparationdistance = 40.0;
  float localsoundmodevar = 3;
  float localvisualsize = 2;
  float localhue = 80;
  float localsaturation = 255;
  float localbrightness = 255;
  float localalpha = 100;
  float localmode = 3.0;
  float localstartedval=0.0;
  float localexitval = 0;

  float localsavescreen = 0;
  float attractionval = 0.0;
  float localforexport = 0.0;
  float localmousex = 0.0;
  float localmousey = 0.0;
  float localxyweight = 0.0;
  float localxlocation = 0.0;
  float localylocation = 0.0;
  float toggleattractionval = 0.0;
  float xlocationreturn = 0.0;
  float ylocationreturn = 0.0;

  float localbackgroundalpha = 10;
  float localbgsaturation = 0;
  float localbgbrightness = 0;
  float localbghue = 0;
  String address;
float number = 22;
Synth reverb;
Flock flock;

void setup() {
  size(400,800);
  colorMode(HSB);
  oscP5 = new OscP5(this,12000);
  oschost = new OscP5(this,10000);
  hostlocation = new NetAddress("192.168.1.106",10000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);

  /*sound plugs*/
  oscP5.plug(this,"freq","/sound/Freq");
  oscP5.plug(this,"reverb","/sound/reverb");
  oscP5.plug(this,"panmod","/sound/PanWeight");

  /*mech plugs*/
  oscP5.plug(this,"maxspeed","/mech/maxspeed");
  oscP5.plug(this,"alignmentforce","/mech/alignment");
  oscP5.plug(this,"separationforce","/mech/separation");
  oscP5.plug(this,"separationdistance","/mech/sepdistance");
  oscP5.plug(this,"cohesionforce","/mech/cohesion");
  oscP5.plug(this,"neighbordist","/mech/neighbor");
  oscP5.plug(this,"attraction","/mech/attraction");

  /*visual plugs*/
  oscP5.plug(this,"sizemod","/visual/sizemod");
  oscP5.plug(this,"sweight","/visual/strokeweight");
  oscP5.plug(this,"hue","/visual/hue");
  oscP5.plug(this,"saturation","/visual/saturation");
  oscP5.plug(this,"brightness","/visual/brightness");
  oscP5.plug(this,"alpha","/visual/alpha");
  oscP5.plug(this,"visualsize","/visual/visualsize");
  oscP5.plug(this,"backgroundalpha","/visual/bgalpha");
  oscP5.plug(this,"backgroundbrightness","/visual/bgbrightness");
  oscP5.plug(this,"backgroundsaturation","/visual/bgsaturation");
  oscP5.plug(this,"backgroundhue","/visual/bghue");
  oscP5.plug(this,"location","/mech/xy");

  /*buttons*/
  oscP5.plug(this,"startandstop","/radio/startstop/1/1");
   //oscP5.plug(this,"toggleattraction","/mech/toggleattraction");
  oscP5.plug(this,"killtheclient","/visual/bgalpha");

  reverb = new Synth("fx_rev_gverb");
  reverb.set("wet", 0.0);
  reverb.set("reverbtime", 1.5);
  reverb.set("damp", 0.3);
  reverb.addToTail();
  
  flock = new Flock();
  //add initial
  for (int i=0; i<number; i++) {
    //flock.addBoid(new Boid(random(0,100)),random(0,100));
    flock.addBoid(new Boid(random(width),random(height)));
  }
returnMessage();
  startAudio();
}

/*some global variables*/

int x = 1;
int numberOfPoints = 5;
float[] numbers = new float[numberOfPoints];

/*DRAW*/

void draw() {

  frameRate(25);
  if (localstartedval==1.0)
    {
      if (localforexport==0.0){
        fill(localbghue, localbgsaturation,localbgbrightness, localbackgroundalpha);
        rect(0,0, width,height);
      }
      flock.run();
    }
  else 
    {background(0);
      for (int i=0; i<flock.synths.size(); i++) {
            flock.synths.get(i).set("freq", 0);
          }
    }

  if (localsavescreen==1.0){
    saveFrame(); 
  }

 if (localexitval==1){
    exit();
  }

  reverb.set("wet", 0+localreverbvar);

}

/*END DRAW*/

/*function to start the audio*/

public void startAudio(){
    for (int i=0; i<number; i++) {
      flock.addSynth(new Synth("sine_harmonic"));
      flock.synths.get(i).set("freq", 0);
      flock.synths.get(i).create();
    }
 
}

/*EXIT*/

void exit()
{
    for (int i=0; i<flock.synths.size(); i++) {
      flock.synths.get(i).set("freq", 0);
      flock.synths.get(i).free();
    }
    super.exit();
}

void oscEvent(OscMessage theOscMessage) {
  address = theOscMessage.netAddress().address();
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  println("recieved from: "+address);
/* render modes */
  if(theOscMessage.addrPattern().equals("/visual/rendermode/1/1")) { 
    rainbow();
  }
  if(theOscMessage.addrPattern().equals("/visual/rendermode/2/1")) { 
    circle();
  }
  if(theOscMessage.addrPattern().equals("/visual/rendermode/3/1")) { 
    bezier();
  }
  if(theOscMessage.addrPattern().equals("/visual/rendermode/4/1")) { 
    entropic();
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

/*lockbg radio*/
  if(theOscMessage.addrPattern().equals("/visual/lockbg")) { 
    forexport();
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


void returnMessage() {
  /* create an osc message with address pattern /test */
  //OscMessage myMessage = new OscMessage("/test");
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
  reverbreturn.add(localreverbvar);
  
  neighborreturn.add(localneighbordist);
  sizemodreturn.add(localsizemod);
  strokeweightreturn.add(localsweight);
  panreturn.add(localpanmod);
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

  //myMessage.add(mode);
  //sou.add(soundmodevar);

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

    if (localmode==0.0){

    }
    else if (localmode==1.0) {
      
    }
    else if (localmode==2.0) {
      
    }
    else if (localmode==3.0){
      
    }

}








/*

SynthDef(\sine_harmonic, { |outbus = 0, freq = 0, amp = 0.1, pan = 0|
  var data, env;
  
  data = SinOsc.ar(freq, 0, amp);
  
  data = Pan2.ar(data, pan);
  
  Out.ar(outbus, data);
}).store;


SynthDef(\pulser, { |freq = 50, amp = 0.1, pan = 0, outbus = 0|
  var data;
  
  data = Impulse.ar(freq, 0, amp);
  data = Pan2.ar(data, pan);
  data = Decay.ar(data, 0.005);
  data = data * SinOsc.ar(freq);
  
  Out.ar(outbus, data);
}).store;


// reverb
SynthDef(\fx_rev_gverb, { |inbus = 0, outbus = 0, wet = 0.5, fade = 1.0, roomsize = 50, reverbtime = 1.0, damp = 0.995, amp = 1.0|
  var in, out;
  
  wet = Lag.kr(wet, fade);
  wet = wet * 0.5;
  
  reverbtime = Lag.kr(reverbtime, fade) * 0.5;
  in = In.ar(inbus, 2) * amp;
  out = GVerb.ar(in, roomsize, reverbtime, damp);
  out = (wet * out) + ((1.0 - wet) * in);
  
  Out.ar(outbus, out);
}).store;

*/
