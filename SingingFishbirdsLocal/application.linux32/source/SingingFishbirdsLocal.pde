// Flocking Code from:
// http://processing.org/learning/topics/flocking.html
// by Daniel Shiffman
//
// SuperCollider and oscP5 libraries from: 
// http://www.erase.net/projects/processing-sc/ and http://www.sojamo.de/code/
// With integration by Gareth Dunstone
//
// Control interface using controlP5 from:
// http://www.sojamo.de/code/
//
// Other code by Gareth Dunstone

import supercollider.*;

import oscP5.*;
import netP5.*;
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;

private ControlP5 cp5;

ControlFrame cf;
Synth reverb;
Flock flock;
int number = 22;
void setup() {
  size(1024,768);
  colorMode(HSB);
  cp5 = new ControlP5(this);
  cf = addControlFrame("controls", 500,500);
  reverb = new Synth("fx_rev_gverb");
  reverb.set("wet", 1.0);
  reverb.set("reverbtime", 1.5);
  reverb.set("damp", 0.7);
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
boolean started = false;

void draw() {
  
  frameRate(25);
  if(cf.mode==1){
    background(0);
  }
  if (cf.started==true)
    {
      if (cf.forexport==0){
      fill(0, 0, 0, cf.backgroundalpha);
      rect(0,0, width,height);}
      flock.run();
    }
  else 
    {background(0);
      for (int i=0; i<flock.synths.size(); i++) {
            flock.synths.get(i).set("freq", 0);
          }
    }

  if (cf.savescreen==1){
    saveFrame(); 
    cf.savescreen=0;
  }
  reverb.set("damp", 0.7*cf.reverbvar);
  if (cf.exitval==1){
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

void exit()
{
    for (int i=0; i<number; i++) {
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
