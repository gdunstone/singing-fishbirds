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





  int localfreqModulation = 0;
  int localreverbvar = 0;
  int localneighbordist = 0;
  float localsizemod = 0;
  float localsweight = 0;
  float localpanmod = 1;
  float localseparationforce = 0.0f;
  float localalignmentforce = 0.0f;
  float localcohesionforce = 0.0f;
  float localmaxspeed = 0.0f;
  float localseparationdistance = 25.0f;
  float localsoundmodevar = 0;
  int localvisualsize = 0;
  int localhue = 0;
  int localsaturation = 0;
  int localbrightness = 0;
  int localalpha = 0;
  float localmode = 0.0f;
  int localstartedval=0;
  int localexitval = 0;
  float localforexport = 0;
  int localbackgroundalpha = 10;
  int localsavescreen = 0;
int number = 22;
Synth reverb;
Flock flock;

public void setup() {
  size(1024,768);
  colorMode(HSB);
  oscP5 = new OscP5(this,12000);

  myRemoteLocation = new NetAddress("127.0.0.1",12000);

  oscP5.plug(this,"test","/test");
  reverb = new Synth("fx_rev_gverb");
  reverb.set("wet", 1.0f);
  reverb.set("reverbtime", 1.5f);
  reverb.set("damp", 0.7f);
  reverb.addToTail();
  
  flock = new Flock();
  //add initial
  for (int i=0; i<number; i++) {
    //flock.addBoid(new Boid(random(0,100)),random(0,100));
    flock.addBoid(new Boid(random(width),random(height)));
  }

  startAudio();
}

/*some global variables*/

int x = 1;
int numberOfPoints = 5;
float[] numbers = new float[numberOfPoints];

/*DRAW*/

public void draw() {
  
  frameRate(25);
  if(localmode==1){
    background(0);
  }
  if (localstartedval==1)
    {
      if (localforexport==0){
      fill(0, 0, 0, localbackgroundalpha);
      rect(0,0, width,height);}
      flock.run();
    }
  else 
    {background(0);
      for (int i=0; i<flock.synths.size(); i++) {
            flock.synths.get(i).set("freq", 0);
          }
    }

  if (localsavescreen==1){
    saveFrame(); 
  }
  reverb.set("damp", 0.7f*localreverbvar);
  if (localexitval==1){
    exit();
  }
}

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
/*
OSC,
The facilitator of communication.
*/

OscP5 oscP5;
NetAddress myRemoteLocation;

public void test( int freqModulationin
  ,int reverbin
  ,int neighbordistin
  ,float sizemodin
  ,float sweightin
  ,float panmodin
  ,float separationforcein
  ,float alignmentforcein
  ,float cohesionforcein
  ,float maxspeedin
  ,float separationdistancein
  ,float soundmodevarin
  ,int visualsizein
  ,int huein
  ,int saturationin
  ,int brightnessin
  ,int alphain
  ,float modein
  ,int startedvalin
  ,int exitvalin
  ,float forexportin
  ,int backgroundalphain
  ,int savescreenin) {

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

/*The boid class. watch out this ones a banger!*/

class Boid {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float colour;
  float diameter;
  float maxforce; //maximum steering force
  float maxspeed; //max speed
  float localseparationdistance = 25.0f;

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
    //arbitrarily weight these forces
    sep.mult(localseparationforce);
    ali.mult(localalignmentforce);
    coh.mult(localcohesionforce);
    //add the force vectors to accel
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
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
    smooth();
    noFill();
    pushMatrix();
    translate(location.x, location.y);

    /*RENDERMODE! */

    if(localmode == 0.0f)
    {
        for (int i = 0; i<numberOfPoints; i++){
        numbers[i]=random(2,diameter+localvisualsize);
        }
        stroke(255);
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
     }
    else if(localmode ==1.0f)
    {
      float theta = velocity.heading2D() + radians(120);
      stroke(255);
      strokeWeight(localsweight);
      rotate(theta);
      bezier(0, 0, random(0,localvisualsize), random(0,-localvisualsize), random(0,-localvisualsize), random(0,localvisualsize), 0, 0);
    }
    else if(localmode == 2.0f)
    {
      noStroke();
      fill(localhue, localsaturation,localbrightness, localalpha);
      ellipse(0, 0, diameter+localvisualsize, diameter+localvisualsize);
    }
    else if(localmode == 3.0f)
    {
      noStroke();
      fill(diameter*10, localsaturation,localbrightness, localalpha);
      ellipse(0, 0, diameter+localvisualsize, diameter+localvisualsize);
    }
  popMatrix();
  noStroke();
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
      float d = PVector.dist(location, other.location);
      //if the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      diameter = d/localsizemod;
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
}
// The FLOCK, a list of Boid objects


class Flock {
  ArrayList<Boid> boids; //an arraylist for the boids to live in
  ArrayList<Synth> synths;
  ArrayList<Synth> pulsesynths;
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
    String[] appletArgs = new String[] { "SingingFishbirdsClient" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
