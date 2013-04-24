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

int number = 22;
import oscP5.*;
import netP5.*;
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;

private ControlP5 cp5;

ControlFrame cf;

OscP5 oscP5;


NetAddress myRemoteLocation;

void setup() {
  size(1,1);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,13000);
  oscP5.plug(this,"test","/test");

  cp5 = new ControlP5(this);
  cf = addControlFrame("controls", 500,500);
  cf.addAddress(new NetAddress("127.0.0.1",12000));
}


void draw() {
  background(0);
  message();
  cf.exitval = 0;
  cf.savescreen = 0;
}


void message() {
  /* createan osc message with address pattern /test */
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(cf.freqModulation);
  myMessage.add(cf.reverb);
  myMessage.add(cf.neighbordist);
  myMessage.add(cf.sizemod);
  myMessage.add(cf.sweight);
  myMessage.add(cf.panmod);
  myMessage.add(cf.separationforce);
  myMessage.add(cf.alignmentforce);
  myMessage.add(cf.cohesionforce);
  myMessage.add(cf.maxspeed);
  myMessage.add(cf.separationdistance);
  myMessage.add(cf.soundmodevar);
  myMessage.add(cf.visualsize);
  myMessage.add(cf.hue);
  myMessage.add(cf.saturation);
  myMessage.add(cf.brightness);
  myMessage.add(cf.alpha);
  myMessage.add(cf.mode);
  myMessage.add(cf.startedval);
  myMessage.add(cf.exitval);
  myMessage.add(cf.forexport);
  myMessage.add(cf.backgroundalpha);
  myMessage.add(cf.savescreen);


  //send the message to the 
  for(int i=0; i<cf.addresslist.size(); i++){
    oscP5.send(myMessage, cf.addresslist.get(i));
  }
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
  */  
  if(theOscMessage.isPlugged()==false) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  println("### addrpattern\t"+theOscMessage.addrPattern());
  println("### typetag\t"+theOscMessage.typetag());
  }
}
