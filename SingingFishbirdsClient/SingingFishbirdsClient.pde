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

/* all the variables: */

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
float attractionval = 0.0;
float localforexport = 0.0;

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
//this is only used for debugging.
String address;

/*this variable changes the number of boids and synths created,
Supercollider can only handle a certain amount of input though,
and oscP5 seems to take up a large amount of stuff...*/
float number = 22;

OscP5 oscP5;
OscP5 oschost;

NetAddress hostlocation;

Synth reverb;
Flock flock;

void setup() {
  size(1300,800);
  frameRate(120);
  colorMode(HSB);

  /*setup oscp5 for send and recieve*/
  oscP5 = new OscP5(this,12000);
  oschost = new OscP5(this,9000);

  //change this to the ip of the host
  hostlocation = new NetAddress("192.168.1.106",10000);

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
  oscP5.plug(this,"killtheclient","/visual/bgalpha");
  oscP5.plug(this,"forexport","/visual/lockbg");

  reverb = new Synth("fx_rev_gverb");
  reverb.set("wet", 0.0);
  reverb.set("reverbtime", 1.5);
  reverb.set("damp", 0.3);
  reverb.addToTail();
  
  flock = new Flock();

  //add initial
  for (int i=0; i<number; i++) {
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
  if (localstartedval==1.0)
    {
      flock.run();

      if (localforexport==0.0){
        fill(localbghue, localbgsaturation,localbgbrightness, localbackgroundalpha);
        rect(0,0, width,height);
      }
    }

  else //turn off synths and make bg 0
    {
      background(0);
      for (int i=0; i<flock.synths.size(); i++) {
            flock.synths.get(i).set("freq", 0);
          }
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