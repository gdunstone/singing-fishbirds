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

import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;



int inputNumber =0;
float inputValue = 0;
int number = 22;
import oscP5.*;
import netP5.*;
import controlP5.*;

MidiBus myBus; // The MidiBus

ControlP5 cp5;

OscP5 oscP5;

NetAddress myRemoteLocation;

RadioButton s;
RadioButton r;

ArrayList<NetAddress> addresslist;
  int w, h;
  int freqModulation = 0;
  int reverb = 0;
  int neighbordist = 0;
  float sizemod = 0;
  float sweight = 0;
  float panmod = 1;
  float separationforce = 0.0;
  float alignmentforce = 0.0;
  float cohesionforce = 0.0;
  float maxspeed = 0.0;
  float separationdistance = 40.0f;
  float soundmodevar = 0;
  int visualsize = 0;
  int hue = 0;
  int saturation = 0;
  int brightness = 0;
  int alpha = 0;
  float mode = 0;
  int exitval = 0;
  int startedval = 0;
  float forexport = 0.0;
  int backgroundalpha = 10;
  int savescreen = 0;
  String address;

void setup() {
  size(500,500);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,13000);
  oscP5.plug(this,"test","/test");

  cp5 = new ControlP5(this);
  //cf = addControlFrame("controls", 500,500);
  PFont pfont = createFont("Arial",20,true);
  ControlFont font = new ControlFont(pfont,241);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 0); // Create a new MidiBus object
  addresslist = new ArrayList<NetAddress>();
  addAddress(new NetAddress("127.0.0.1",12000));

    frameRate(25);
    cp5.addSlider("freqModulation")
      .setRange(1, 440)
      .setValue(1)
      .setPosition(10,10)
      .setLabel("Frequency range");

    cp5.addSlider("reverb")
      .plugTo("freqModulation","reverb")
      .setRange(0, 1)
      .setPosition(10,30);

    cp5.addSlider("sweight")
      .plugTo("freqModulation","sweight")
      .setRange(0, 1)
      .setValue(0.5)
      .setPosition(10,50)
      .setLabel("stroke weight");

    cp5.addSlider("panmod")
      .plugTo("freqModulation","panmod")
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
      .setLabel("Exit Both");

    cp5.addBang("exitClient")
      .setPosition(325, 20)
      .setSize(50, 50)
      .setLabel("Exit Client");

    cp5.addBang("export")
      .setPosition(400, 330)
      .setSize(50, 50)
      .setLabel("Lock BG");

    cp5.addBang("saveScreen")
      .setPosition(400, 260)
      .setSize(50, 50)
      .setLabel("save");

    cp5.addSlider("backgroundalpha")
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
      .setRange(2,10)
      .setValue(10)
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
      .setValue(1.5)
      .setPosition(160,90)
      .setRadius(20)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("separationforce");

    cp5.addKnob("separationdistance")
      .setRange(0,500)
      .setValue(40.0)
      .setPosition(240,90)
      .setRadius(20)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("separationdistance");

    cp5.addKnob("alignmentforce")
      .setRange(0,2)
      .setValue(1.0)
      .setPosition(160,160)
      .setRadius(20)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("alignmentforce");

    cp5.addKnob("cohesionforce")
      .setRange(0,2)
      .setValue(1.1)
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

    /*textfield for network address*/

    cp5.addTextfield("input")
      .setPosition(10,400)
      .setSize(100,20)
      .setFocus(true)
      .setLabel("add ip address to list");

    cp5.addBang("createIp")
      .setPosition(120, 400)
      .setSize(30, 20)
      .setLabel("add");
                 
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


void controlEvent(ControlEvent theEvent) {

    if (theEvent.isGroup()) {
      // an event from a group e.g. scrollList
      println(theEvent.group().value()+" from "+theEvent.group());
    }
    
    if(theEvent.isFrom(r)) {
      print("got an event from "+theEvent.getName()+"\t");
      for(int i=0;i<theEvent.getGroup().getArrayValue().length;i++) {
        print(int(theEvent.getGroup().getArrayValue()[i]));
      }
      println("\t "+theEvent.getValue());
      mode = theEvent.getValue();
    }

    else if(theEvent.isFrom(s)) {
      print("got an event from "+theEvent.getName()+"\t");
      for(int i=0;i<theEvent.getGroup().getArrayValue().length;i++) {
        print(int(theEvent.getGroup().getArrayValue()[i]));
      }
      println("\t "+theEvent.getValue());
      soundmodevar = theEvent.getValue();
    }

}
  
  public void startStop(){
    if(startedval==1)
    {startedval = 0;
          /*for (int i=0; i<number; i++) {
            flock.synths.get(i).set("freq", 0);
          }*/
    }
    else
    {startedval = 1;}
  }

  public void exitClient(){
    exitval = 1;
  }


  public void exitNow()
  {
      super.exit();
  }

  public void createIp()
  {
    addAddress(new NetAddress(address,12000));
    println("Added ip: "+address+" to the address list");
    println("address list:");
    for(int i=0; i<addresslist.size(); i++)
      {
        println(addresslist.get(i));
      }
  }

  public void addAddress(NetAddress a){
      addresslist.add(a);
  }

  public void export(){
    if (forexport==0.0){forexport=1.0;}
    else{forexport=0.0;}
  }

  public void saveScreen(){
    savescreen = 1;
  }

  void exit()
  {
      super.exit();
  }

void draw() {
  background(0);
  message();
  exitval = 0;
  savescreen = 0;
    address = cp5.get(Textfield.class,"input").getText();

}


void message() {
  /* createan osc message with address pattern /test */
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(freqModulation);
  myMessage.add(reverb);
  myMessage.add(neighbordist);
  myMessage.add(sizemod);
  myMessage.add(sweight);
  myMessage.add(panmod);
  myMessage.add(separationforce);
  myMessage.add(alignmentforce);
  myMessage.add(cohesionforce);
  myMessage.add(maxspeed);
  myMessage.add(separationdistance);
  myMessage.add(soundmodevar);
  myMessage.add(visualsize);
  myMessage.add(hue);
  myMessage.add(saturation);
  myMessage.add(brightness);
  myMessage.add(alpha);
  myMessage.add(mode);
  myMessage.add(startedval);
  myMessage.add(exitval);
  myMessage.add(forexport);
  myMessage.add(backgroundalpha);
  myMessage.add(savescreen);


  //send the message to the client
  for(int i=0; i<addresslist.size(); i++){
    oscP5.send(myMessage, addresslist.get(i));
  }
}

void midiMessage(MidiMessage message) {

  println("");
  for(int i = 0;i < message.getMessage().length;i++) {
    println("Param "+(i)+": "+(int)(message.getMessage()[i] & 0xFF));
  }

  println("inputNumber: "+message.getMessage()[1]);
  println("inputValue"+message.getMessage()[message.getMessage().length-1]);

    inputNumber = message.getMessage()[1];
    inputValue = message.getMessage()[message.getMessage().length-1];
  //sliders from left to right range 0-127
  if (inputNumber==74){
    cp5.controller("visualsize").setValue(inputValue);
  }
  else if (inputNumber==71) {
    cp5.controller("hue").setValue(inputValue*2);
  }
  else if (inputNumber==91) {
    cp5.controller("saturation").setValue(inputValue*2);
  }
  else if (inputNumber==93) {
    cp5.controller("brightness").setValue(inputValue*2);
  }
  else if (inputNumber==73) {
    cp5.controller("alpha").setValue(inputValue*2);
  }
  else if (inputNumber==72) {
    cp5.controller("backgroundalpha").setValue(inputValue*2);
  }
  else if (inputNumber==5) {
    cp5.controller("sweight").setValue(inputValue);
  }
  else if (inputNumber==84) {
    cp5.controller("reverb").setValue(inputValue);
  }
  else if (inputNumber==7) {
    cp5.controller("freqModulation").setValue(inputValue);
  }

  //knobs from left to right range 0-127
  else if (inputNumber==75) {
    cp5.controller("separationforce").setValue(inputValue/65);
  }
  else if (inputNumber==10) {
    cp5.controller("alignmentforce").setValue(inputValue/65);
  }
  else if (inputNumber==76) {
    cp5.controller("cohesionforce").setValue(inputValue/65);
  }
  else if (inputNumber==77) {
    cp5.controller("neighbordist").setValue(inputValue*(2000/127));
  }
  else if (inputNumber==92) {
   cp5.controller("maxspeed").setValue(inputValue/(127/5)); 
  }
  else if (inputNumber==78) {
    cp5.controller("sizemod").setValue(2+inputValue/(127/8)); 
  }
  else if (inputNumber==95) {
    cp5.controller("separationdistance").setValue(inputValue*(600/127)); 
  }
  else if (inputNumber==79) {
    
  }
  //f10-f13 buttons left to right
  else if (inputNumber==0) {
    startedval=1;
  }
  else if (inputNumber==1) {
    export();
  }
  else if (inputNumber==2) {
    saveScreen();
  }
  else if (inputNumber==3) {
    //reserved for later
  }


  //p1-p4
  else if (inputNumber==36) {
    s.activate(0);
  }
  else if (inputNumber==38) {
    s.activate(1);
  }
  else if (inputNumber==42) {
    s.activate(2);
  }
  else if (inputNumber==46) {
    s.activate(3);
  }
  //p5-p8
  else if (inputNumber==50) {
    r.activate(0);
  }
  else if (inputNumber==45) {
    r.activate(1);
  }
  else if (inputNumber==51) {
    r.activate(2);
  }
  else if (inputNumber==49) {
    r.activate(3);
  }
  
}