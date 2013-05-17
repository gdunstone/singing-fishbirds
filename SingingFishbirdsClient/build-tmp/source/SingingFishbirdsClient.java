import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import supercollider.*; 
import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SingingFishbirdsClient extends PApplet {

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






/* all the variables: */

float localfreqModulation = 100;
float localreverbvar = 1;
float localneighbordist = 1000.0f;
float localsizemod = 10;
float localsweight = 1;
float localpanmod = 1;
float localseparationforce = 1.5f;
float localalignmentforce = 1.0f;
float localcohesionforce = 1.4f;
float localmaxspeed = 2;
float localseparationdistance = 100.0f;
float localsoundmodevar = 3;
float localvisualsize = 0;
float localhue = 80;
float localsaturation = 0;
float localbrightness = 255;
float localalpha = 200;
float localmode = 1.0f;
float localellipsemode = 0.0f;

float localstartedval=0.0f;
float localexitval = 0;
float attractionval = 0.0f;
float localforexport = 0.0f;
float localframerate = 60.0f;

float localxyweight = 0.0f;
float localxlocation = 0.0f;
float localylocation = 0.0f;
float toggleattractionval = 0.0f;
float xlocationreturn = 0.0f;
float ylocationreturn = 0.0f;

float localbackgroundalpha = 120;
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

public void setup() {
  if (frame != null) {
    frame.setResizable(true);
  }
  size(1300,800);

  colorMode(HSB);
        ellipseMode(RADIUS);

  /*setup oscp5 for send and recieve*/
  oscP5 = new OscP5(this,12000);
  oschost = new OscP5(this,9000);

  //change this to the ip of the host
  hostlocation = new NetAddress("169.254.170.253",10000);

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
  oscP5.plug(this,"framerateFunc","/mech/framerate");

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
  oscP5.plug(this,"glowThing","/visual/glow");

  reverb = new Synth("fx_rev_gverb");
  reverb.set("wet", 0.0f);
  reverb.set("reverbtime", 1.5f);
  reverb.set("damp", 0.3f);
  reverb.addToTail();
  
  flock = new Flock();

  //add initial
  for (int i=0; i<number; i++) {
   // flock.addBoid(new Boid(random(width),random(height)));
   flock.addBoid(new Boid(width/2, height/2));
  }
  returnMessage();
  startAudio();
}

/*some global variables*/

int x = 1;
int numberOfPoints = 5;
float[] numbers = new float[numberOfPoints];

/*DRAW*/

public void draw() {
    frameRate(localframerate);
  if (localstartedval==1.0f)
    {
      if (localforexport==0.0f){
        fill(localbghue, localbgsaturation,localbgbrightness, localbackgroundalpha);
        rect(0,0, width,height);
      }
      flock.run();
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

public void exit()
{
    for (int i=0; i<flock.synths.size(); i++) {
      flock.synths.get(i).set("freq", 0);
      flock.synths.get(i).free();
    }
    super.exit();
}
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
  localxyweight=0.0f;
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
  localmode=3.0f;
}
public void circle(){
  localmode=2.0f;
}
public void bezier(){
  localmode=1.0f;
}
public void entropic(){
  localmode=0.0f;
}

/*SOUNDMODES*/
public void wind(){
  localsoundmodevar=3.0f;
}
public void windMONO(){
  localsoundmodevar=2.0f;
}
public void some(){
  localsoundmodevar=1.0f;
}
public void someINVERT(){
  localsoundmodevar=0.0f;
}

/*MISC functions*/
public void startandstop(float in){
  localstartedval=in;
}

public void killtheclient(){
  if(localexitval==0.0f){
    localexitval=1.0f;
  }
}
public void forexport(float in){
  localforexport=in;
}

public void glowThing(float in){
  localellipsemode=in;
}


/*oscEvent, for stuff that i couldnt oscP5.plug()*/

public void oscEvent(OscMessage theOscMessage) {
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

public void returnMessage() {
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
  OscMessage glowreturn = new OscMessage("/visual/glow");

 
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
  glowreturn.add(localellipsemode);

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
    oschost.send(glowreturn,hostlocation);
    oschost.send(xyreturn,hostlocation);
    oschost.send(bgsaturationreturn, hostlocation);
    oschost.send(bgbrightnessreturn, hostlocation);
    oschost.send(bghuereturn, hostlocation);  
    oschost.send(frameratereturn, hostlocation);   

}
/*The boid class. watch out this ones a banger!*/

class Boid {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float colour;
  float diameter;
  float maxforce; //maximum steering force
  float maxspeed; //max speed
  //float localseparationdistance = 40.0;

  Boid(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    maxspeed = localmaxspeed;
    maxforce = 0.03f;
  }

  //run the system
  public void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  public void applyForce(PVector force) {
    acceleration.add(force);
  }

  //we accumulate a new acceleration each time base on 3 rules

  public void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids); //separation
    PVector ali = align(boids); //alignment
    PVector coh = cohesion(boids); //cohesion
    PVector xy = xy(boids);
    //arbitrarily weight these forces
    sep.mult(localseparationforce);
    ali.mult(localalignmentforce);
    coh.mult(localcohesionforce);
    xy.mult(localxyweight);
    //add the force vectors to accel
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(xy);
  }
  public void update() {
    //update velocity
    velocity.add(acceleration);
    //limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    //reset acceleration to 0 each cycle45
    acceleration.mult(0);
  }

  //a method that calculates and applies a steering force towards a target
  // steer = desired minus velocity
  public PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location); //a vector pointing from the location to the target
    //normalie desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    //steering = desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce); //limit to the maximum steering force
    return steer;
  }

public void render() {

  /*soundmodes */
  //soundmode that uses y location for boid frequency and x location for panning.
    if (localsoundmodevar==0.0f){
      for (int i=0; i<number; i++) {
       flock.synths.get(i).set("freq", (height-flock.boids.get(i).location.y)+localfreqModulation);
        flock.synths.get(i).set("pan",  (flock.boids.get(i).location.x-width)/(width*2)*localpanmod);
      }
    }
  //soundmode that uses y location for frequency and reverse diameter for amplitude (the larger the group the louder they are)
    else if (localsoundmodevar==1.0f) {
      for (int i=0; i<number; i++) {
      flock.synths.get(i).set("freq", (height-flock.boids.get(i).location.y)+localfreqModulation);
       flock.synths.get(i).set("amp",  1-flock.boids.get(i).diameter/100);
      }
    }
  //soundmode that uses x location for panning, and size for frequency.
    else if (localsoundmodevar==2.0f) {
      for (int i=0; i<number; i++) {
        flock.synths.get(i).set("pan",  (flock.boids.get(i).location.x-width)/(width*2)*localpanmod);
        flock.synths.get(i).set("freq", (flock.boids.get(i).diameter)*localfreqModulation);
      }
    }
    else {
      for (int i=0; i<number; i++) {
        flock.synths.get(i).set("pan",  (flock.boids.get(i).location.x-width)/(width*2)*localpanmod);
        flock.synths.get(i).set("freq", 440-(flock.boids.get(i).diameter)*localfreqModulation);
      }
    }
    //smooth();
    noFill();
    //pushMatrix();
    //translate(location.x, location.y);

    /*RENDERMODE! */
    if(localmode == 0.0f)
    {
      pushMatrix();
      translate(location.x, location.y);
        for (int i = 0; i<numberOfPoints; i++){
        numbers[i]=random(2,diameter+localvisualsize);
        }
        stroke(localhue, localsaturation, localbrightness, localalpha);
        strokeWeight(localsweight);
        
        beginShape();
        for (int i=0; i<numberOfPoints; i++)
        {
          if(i<numberOfPoints-1)
          {
            vertex(numbers[i], numbers[i+1]);
          }
          else
          {vertex(numbers[numberOfPoints-1],numbers[0]);}
        }
        endShape();
        popMatrix();
     }
    else if(localmode ==1.0f)
    {
      pushMatrix();translate(location.x, location.y);
      float theta = velocity.heading2D() + radians(210);
      stroke(localhue, localsaturation, localbrightness, localalpha);
      strokeWeight(localsweight);
      rotate(theta);
      bezier(0, 0, localvisualsize*noise(10+diameter), localvisualsize*noise(10+diameter), -localvisualsize*noise(50+diameter), localvisualsize*noise(200+diameter), 0, 0);
      bezier(0, 0, -localvisualsize*noise(50+diameter), -localvisualsize*noise(200+diameter), localvisualsize*noise(10+diameter), -localvisualsize*noise(10+diameter), 0, 0);
      popMatrix();
    }
    else if(localmode == 2.0f)
    {
      noStroke();
/*      fill(localhue, localsaturation,localbrightness, localalpha);
      ellipse(0, 0, diameter+localvisualsize, diameter+localvisualsize);
*/
      if (localellipsemode==0.0f){
       fill(localhue, localsaturation,localbrightness, localalpha);
       ellipse(location.x, location.y, diameter+localvisualsize, diameter+localvisualsize);
      }

      else{
        drawGradient(location.x, location.y, diameter+localvisualsize, localhue, localsaturation, localbrightness, localalpha);
      }
    }
    else if(localmode == 3.0f)
    {
      noStroke();

      if (localellipsemode==0.0f){
       fill(diameter*10, localsaturation,localbrightness, localalpha);
       ellipse(location.x, location.y, diameter+localvisualsize, diameter+localvisualsize);
      }

      else{
        drawGradient(location.x, location.y, diameter+localvisualsize, diameter*10, localsaturation, localbrightness, localalpha);
      }

    }
  //popMatrix();
  //noStroke();
}

  //wraparound 
public void borders() {

   if (location.x > width) {
      velocity.x = -velocity.x;
    } 
    else if (location.x < 0) {
      velocity.x = -velocity.x;
    } // X
    
    if (location.y > height) {
      velocity.y = -velocity.y;
    } else if (location.y < 0) {
      velocity.y = -velocity.y;
    }// Y
    
 }
  //Separation
  //method checks for nearby boids and steers away
  public PVector separate(ArrayList<Boid> boids) {
   float desiredseparation = localseparationdistance;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    //for every boid in the system chech if its too close
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location); diameter = d/localsizemod;
      //if the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        //calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d); //weight by distance.
        steer.add(diff);
        count++; //keep track of how many times separation occurs
      }
    }
    //Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    //as long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement reynolds: steering = Desired - velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  //Alignment
  //For every nearby boid in the system, calculate the average velocity
  public PVector align (ArrayList<Boid> boids) {
    float neighbordist = 30+localneighbordist;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d>0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  //cohesion
  // for the average location (ie center) of all nearby boids, calculate steering vetor towards that location
  public PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 70+localneighbordist;
    PVector sum = new PVector(0, 0); //start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {
      float d= PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); //add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum); //steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }

  //attraction/revulsion
    public PVector xy (ArrayList<Boid> boids) {
    float neighbordist = 70+localneighbordist;
    PVector sum = new PVector(localxlocation, localylocation);
    int count = 0;
    for (Boid other : boids) {
      float d= PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum = sum; //add location
        count++;
      }
      
    }
    if (count > 0) {
      
      return seek(sum); //steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }
}

// 
public void drawGradient(float x, float y, float radius, float ghue, float gsat, float gbri, float galp) {
  
  int r2 = PApplet.parseInt(radius);
  float h = 0;

  fill(ghue, gsat, gbri, galp);
  ellipse(x,y,radius,radius);

    for (int r = r2+15; r > 0; --r)
    {
      fill(ghue, gsat, gbri, h);
      ellipse(x, y, r+5, r+5);
      h = (h + 1) % 50;
    }

}
/*
void drawGradient(float radius, float ghue, float gsat, float gbri, float galp) {
  
  int r2 = int(radius);
  float h = 0;

  fill(ghue, gsat, gbri, galp);
  ellipse(x,y,radius,radius);

    for (int r = r2; r > 0; --r)
    {
      fill(ghue, gsat, gbri, h);
      ellipse(0, 0, 40-r*r, 40-r*r);
      h = (h + 1) % 50;
    }

}
*/
// The FLOCK, a list of Boid objects


class Flock {
  ArrayList<Boid> boids; //an arraylist for the boids to live in
  ArrayList<Synth> synths;
  Flock(){
    boids = new ArrayList<Boid>(); //initialize the arraylist
    synths = new ArrayList<Synth>();
  }
  public void run() {
    for (Boid b : boids) {
      b.run(boids); //Passing the entire list of boids to each boid individually
    }
  }
  public void addBoid(Boid b) {
    boids.add(b);
  }
  public void addSynth(Synth s){
    synths.add(s);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "SingingFishbirdsClient" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
