import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import supercollider.*; 
import oscP5.*; 
import netP5.*; 
import java.awt.Frame; 
import java.awt.BorderLayout; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SingingFishbirdsLocal extends PApplet {

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









private ControlP5 cp5;

ControlFrame cf;
Synth reverb;
Flock flock;
int number = 22;
public void setup() {
  size(1024,768);
  colorMode(HSB);
  cp5 = new ControlP5(this);
  cf = addControlFrame("controls", 500,500);
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
boolean started = false;

public void draw() {
  
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
  reverb.set("damp", 0.7f*cf.reverbvar);
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

public void exit()
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
/*The boid class. watch out this ones a banger!*/

class Boid {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float colour;
  float diameter;
  float maxforce; //maximum steering force
  float maxspeed; //max speed

  Boid(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    maxspeed = cf.maxspeed;
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
    sep.mult(cf.separationforce);
    ali.mult(cf.alignmentforce);
    coh.mult(cf.cohesionforce);
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
    if (cf.soundmodevar==0.0f){
      for (int i=0; i<number; i++) {
       flock.synths.get(i).set("freq", (height-flock.boids.get(i).location.y)+cf.freqModulation);
        flock.synths.get(i).set("pan",  (flock.boids.get(i).location.x-width)/(width*2)*cf.panmod);
      }
    }
  //soundmode that uses y location for frequency and reverse diameter for amplitude (the larger the group the louder they are)
    else if (cf.soundmodevar==1.0f) {
      for (int i=0; i<number; i++) {
      flock.synths.get(i).set("freq", (height-flock.boids.get(i).location.y)+cf.freqModulation);
       flock.synths.get(i).set("amp",  1-flock.boids.get(i).diameter/100);
      }
    }
  //soundmode that uses x location for panning, and size for frequency.
    else if (cf.soundmodevar==2.0f) {
      for (int i=0; i<number; i++) {
        flock.synths.get(i).set("pan",  (flock.boids.get(i).location.x-width)/(width*2)*cf.panmod);
        flock.synths.get(i).set("freq", (flock.boids.get(i).diameter)*cf.freqModulation);
      }
    }
    else {
      for (int i=0; i<number; i++) {
        flock.synths.get(i).set("pan",  (flock.boids.get(i).location.x-width)/(width*2)*cf.panmod);
        flock.synths.get(i).set("freq", 440-(flock.boids.get(i).diameter)*cf.freqModulation);
      }
    }
    smooth();
    noFill();
    pushMatrix();
    translate(location.x, location.y);

    /*RENDERMODE! */

    if(cf.mode == 0.0f)
    {
        for (int i = 0; i<numberOfPoints; i++){
        numbers[i]=random(2,diameter+cf.visualsize);
        }
        stroke(255);
        strokeWeight(cf.sweight);
        
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
    else if(cf.mode ==1.0f)
    {
      float theta = velocity.heading2D() + radians(120);
      stroke(255);
      strokeWeight(cf.sweight);
      rotate(theta);
      bezier(0, 0, random(0,cf.visualsize), random(0,-cf.visualsize), random(0,-cf.visualsize), random(0,cf.visualsize), 0, 0);
    }
    else if(cf.mode == 2.0f)
    {
      noStroke();
      fill(cf.hue, cf.saturation,cf.brightness, cf.alpha);
      ellipse(0, 0, diameter+cf.visualsize, diameter+cf.visualsize);
    }
    else if(cf.mode == 3.0f)
    {
      noStroke();
      fill(diameter*10, cf.saturation,cf.brightness, cf.alpha);
      ellipse(0, 0, diameter+cf.visualsize, diameter+cf.visualsize);
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
    float desiredseparation = cf.separationdistance;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    //for every boid in the system chech if its too close
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      //if the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      diameter = d/cf.sizemod;
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
    float neighbordist = 30+cf.neighbordist;
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
    float neighbordist = 70+cf.neighbordist;
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

/*One ControlFrame to rule them all, and with their classes bind them */

public ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(50, 250);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}
RadioButton s;
RadioButton r;

public class ControlFrame extends PApplet {

  int w, h;
  int freqModulation = 0;
  int reverbvar = 0;
  int neighbordist = 0;
  float sizemod = 0;
  float sweight = 0;
  float panmod = 1;
  float separationforce = 0.0f;
  float alignmentforce = 0.0f;
  float cohesionforce = 0.0f;
  float maxspeed = 0.0f;
  float separationdistance = 25.0f;
  float soundmodevar = 0;
  int visualsize = 0;
  int hue = 0;
  int saturation = 0;
  int brightness = 0;
  int alpha = 0;
  float mode = 0;
  int exitval = 0;
  boolean started = false;
  float forexport = 0.0f;
  int backgroundalpha = 10;
  int savescreen = 0;

  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
    cp5.addSlider("freqModulation")
      .setRange(1, 440)
      .setValue(1)
      .setPosition(10,10)
      .setLabel("Frequency range");

    cp5.addSlider("reverb")
      .plugTo(parent,"reverb")
      .setRange(0, 1)
      .setPosition(10,30);

    cp5.addSlider("sweight")
      .plugTo(parent,"sweight")
      .setRange(0, 1)
      .setValue(0.5f)
      .setPosition(10,50)
      .setLabel("stroke weight");

    cp5.addSlider("panmod")
      .plugTo(parent,"panmod")
      .setRange(1, 2)
      .setPosition(10,70)
      .setLabel("pan weight");

    /*startstop and exit now*/

    cp5.addBang("startStop")
      .setPosition(250, 20)
      .setSize(50, 50)
      .setLabel("start stop");

    cp5.addBang("exitNow")
      .setPosition(400, 20)
      .setSize(50, 50)
      .setLabel("Exit");

    cp5.addBang("export")
      .setPosition(400, 330)
      .setSize(50, 50)
      .setLabel("Lock BG");

    cp5.addBang("saveScreen")
      .setPosition(400, 260)
      .setSize(50, 50)
      .setLabel("save");

    cp5.addSlider("backgroundalpha")
      .plugTo(parent,"backgroundalpha")
      .setSize(10,100)
      .setRange(0, 255)
      .setValue(10)
      .setPosition(370,300);

/* neighbor distance measuring, sizemod and actual size */
    cp5.addKnob("neighbordist")
      .setRange(0,2000)
      .setValue(0)
      .setPosition(20,90)
      .setRadius(20)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("neighbordist");

    cp5.addKnob("sizemod")
      .setRange(20,0.5f)
      .setValue(20)
      .setPosition(70,90)
      .setRadius(20)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("sizemod");

    cp5.addKnob("visualsize")
      .setRange(1,128)
      .setValue(1)
      .setPosition(25,150)
      .setRadius(40)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("visualsize");

    cp5.addKnob("separationforce")
      .setRange(0,2)
      .setValue(1.5f)
      .setPosition(160,90)
      .setRadius(20)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("separationforce");

    cp5.addKnob("separationdistance")
      .setRange(0,50)
      .setValue(25.0f)
      .setPosition(240,90)
      .setRadius(20)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("separationdistance");

    cp5.addKnob("alignmentforce")
      .setRange(0,2)
      .setValue(1.0f)
      .setPosition(160,160)
      .setRadius(20)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("alignmentforce");

    cp5.addKnob("cohesionforce")
      .setRange(0,2)
      .setValue(1.1f)
      .setPosition(160,230)
      .setRadius(20)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("cohesionforce");

    cp5.addKnob("maxspeed")
      .setRange(0,5)
      .setValue(2)
      .setPosition(240,160)
      .setRadius(20)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("maxspeed");

/* HSV values for flock color */

    cp5.addKnob("hue")
      .setRange(0,255)
      .setValue(190)
      .setPosition(20,300)
      .setRadius(30)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("hue");

    cp5.addKnob("saturation")
      .setRange(0,255)
      .setValue(190)
      .setPosition(100,300)
      .setRadius(30)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("saturation");

    cp5.addKnob("brightness")
      .setRange(0,255)
      .setValue(255)
      .setPosition(180,300)
      .setRadius(30)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("brightness");

    cp5.addKnob("alpha")
      .setRange(0,255)
      .setValue(110)
      .setPosition(260,300)
      .setRadius(30)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("alpha");
                 
    //radio button for soundmode
    s = cp5.addRadioButton("soundmodevar")
         
         .setPosition(400,130)
         .setSize(40,20)
         .setColorForeground(color(0))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setLabelPadding(10,0)
         .setItemWidth(20)
         .setItemHeight(20)
         .setItemsPerRow(1)
         .setSpacingRow(1)
         .addItem("Wind",0)
         .addItem("MonoWind",1)
         .addItem("Some",2)
         .addItem("SomeInvert",3)
         .setNoneSelectedAllowed(false)
         .activate(0)
         //.hideLabels()
         ;
     
     for(Toggle t:s.getItems()) {
       t.captionLabel().setColorBackground(color(255,80));
       t.captionLabel().style().moveMargin(-7,0,0,-3);
       t.captionLabel().style().movePadding(7,0,0,3);
       t.captionLabel().style().backgroundWidth = 45;
       t.captionLabel().style().backgroundHeight = 13;
     }

     r = cp5.addRadioButton("mode")
         
         .setPosition(320,130)
         .setSize(40,20)
         .setColorForeground(color(0))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setLabelPadding(10,0)
         .setItemWidth(20)
         .setItemHeight(20)
         .setItemsPerRow(1)
         .setSpacingRow(1)
         .addItem("Entropic",0)
         .addItem("Bezier",1)
         .addItem("Circle",2)
         .addItem("Rainbow",3)
         .setNoneSelectedAllowed(false)
         .activate(0)
         //.hideLabels()
         ;
     
     for(Toggle t:r.getItems()) {
       t.captionLabel().setColorBackground(color(255,80));
       t.captionLabel().style().moveMargin(-7,0,0,-3);
       t.captionLabel().style().movePadding(7,0,0,3);
       t.captionLabel().style().backgroundWidth = 45;
       t.captionLabel().style().backgroundHeight = 13;
     }
  }
 public void controlEvent(ControlEvent theEvent) {
  // ListBox is if type ControlGroup.
  // 1 controlEvent will be executed, where the event
  // originates from a ControlGroup. therefore
  // you need to check the Event with
  // if (theEvent.isGroup())
  // to avoid an error message from controlP5.



    if (theEvent.isGroup()) {
      // an event from a group e.g. scrollList
      println(theEvent.group().value()+" from "+theEvent.group());
    }
    
    if(theEvent.isFrom(r)) {
      print("got an event from "+theEvent.getName()+"\t");
      for(int i=0;i<theEvent.getGroup().getArrayValue().length;i++) {
        print(PApplet.parseInt(theEvent.getGroup().getArrayValue()[i]));
      }
      println("\t "+theEvent.getValue());
      mode = theEvent.getValue();
    }

    if(theEvent.isFrom(s)) {
      print("got an event from "+theEvent.getName()+"\t");
      for(int i=0;i<theEvent.getGroup().getArrayValue().length;i++) {
        print(PApplet.parseInt(theEvent.getGroup().getArrayValue()[i]));
      }
      println("\t "+theEvent.getValue());
      soundmodevar = theEvent.getValue();
    }

}
  public void draw() {
    background(0);
  }
  
  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }


  public ControlP5 control(){
    return cp5;
  }

  public void export(){
    if (forexport==0.0f){forexport=1.0f;}
    else{forexport=0.0f;}
  }

  public void saveScreen(){
    savescreen = 1;
  }


  public void startStop(){
    if(started==true)
    {started = false;
          for (int i=0; i<number; i++) {
            flock.synths.get(i).set("freq", 0);
          }
    }
    else
    {started = true;}
  }


  public void exitNow()
  {
      for (int i=0; i<flock.synths.size(); i++) {
        flock.synths.get(i).free();
      }
      super.exit();
  }


  public void exit()
  {
      for (int i=0; i<flock.synths.size(); i++) {
        flock.synths.get(i).free();
      }
      super.exit();
  }


  ControlP5 cp5;

  Object parent;
    
} 

/* The FLOCK, a list of Boid objects */


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
    String[] appletArgs = new String[] { "SingingFishbirdsLocal" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
