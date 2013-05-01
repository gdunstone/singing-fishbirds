#Singing FishBirds Readme

---

![screenshot](http://p.arcc.cc/fishbird.png)

---

##Table Of Contents

1. Version
2. Setup
3. Network
4. Rendering Modes and Variables
5. Flocking Variables
6. SuperCollider
7. Sound Modes and Variables
8. Other Useful Features
9. Extra Code
10. Credits

---

###Version

At the time of writing there are **4** branches of **Singing FishBirds**:

[master](https://github.com/stormaes/singing-fishbirds) - The master. It has everything, midi, TouchOSC, control, networked. The whole kit.

[local](https://github.com/stormaes/singing-fishbirds/tree/local) - Very basic. Comes with a control program that is hardwired to the client.

[NetworkedMIDI](https://github.com/stormaes/singing-fishbirds/tree/NetworkedMidiControlBranch) - Just a client and a control program. The control can be connected to with a MIDI controller.

[TouchOSC-ONLY](https://github.com/stormaes/singing-fishbirds/tree/TouchOSC-ONLY) - TouchOSC-ONLY was made specifically for TouchOSC, it has only the client, and TouchOSC layouts. TouchOSC-ONLY is the most up to date and feature rich branch.


---

###Setup
**Singing FishBirds** was written in Processing, a branch of java, as you can export java applications from Processing it is available as both a OSX app and as .pde files for Processing.

If you are using a version with networking support then you must start the control app first and then the client app.

If you are using TouchOSC-ONLY then you do not need to worry about starting which first, however if you are going to resize the window I recommend you do so before starting flock, the fish get stuck out of bounds sometimes.

If you are using **SuperCollider** then you must start it and boot the server before starting anything else.

---

###Network
If you have a version of **Singing FishBirds** that has networking support, you can use the control app to control one or more clients over a network.

Once you have started the control program you need to input the IP addresses of computers running the client, and click the add button.

The computers running the client need to have the port ***12000*** open to receive connections otherwise the OSC communications will not be received.

For TouchOSC, the client needs to be able to send return messages to the host, this means editing the sketch to include the ip address of the host then building the application using Processing. The port that it should be listening on is ***10000***.

Also if you are running **SuperCollider** with the networked version, it needs to be running on the client machine. This is because the client sends control commands for **SuperCollider** to the local machine.

---

##Rendering Modes and Variables

There are a number of different ways in which **Singing FishBirds** can render the flock, and there are variables which affect the appearance of this. 

###Modes

```
ENTROPIC
The fish are rendered as a series of random straight lines. 
```
```
BEZIER
The fish are rendered as a random bezier curve with the beginning and end in the same location, pointed in the direction that the fish is heading.
Note: this mode does not listen to SIZEMOD, also VISUALSIZE needs to be increased for fish to be visible.
```	
```
CIRCLE
Each fish is drawn as a circle that changes size based on its proximity to other fish. You can change the hue, saturation, brightness and alpha with the knobs at the bottom of the control panel.
```	
```
RAINBOW
Works the same as CIRCLE, only in this mode the hue of each fish is affected by the size of the fish. To get the most out of this mode, some tweaking of the SIZEMOD variable is necessary.
```

###Variables
```
SIZEMOD
Changes how much proximity affects the size of the fish. 
Note: Does not apply to BEZIER rendermode.
```	
```
VISUALSIZE
Adds extra size, on top of SIZEMOD.
```	
```
STROKEWEIGHT
Changes how strong lines are drawn. 
Note: This does not apply to rendermodes CIRCLE and RAINBOW, as they have no lines.
```	
---

##Flocking Variables
Flocking variables in **Singing BirdFish** enable you to control how the fish behave in relation to each other.

###Variables
```
SEPARATIONFORCE
Controls the strength of the force that pushes other fish away when they get close.
```	

```
ALIGNMENTFORCE
Modifies the force that makes the fish move in the same direction as the rest of the flock.
```	

```
COHESIONFORCE
Changes the strength of the force that pulls the fish together.
```	

```
SEPARATIONDISTANCE
Changes the distance between each other that each fish will try and keep.
```	

```
MAXSPEED
Is the maximum speed the fish are allowed to move at.
```

```
NEIGHBORDIST
The distance at which fish can see each other. In other words the distance at which each fishes forces act upon one another.
```	

```
XYPad (TouchOSC-ONLY)
Controls the location of a vector linked to the fish. Works as a general purpose force.
```	

```
ATTRACTIONWEIGHT (TouchOSC-ONLY)
The weight of the force controlled by XYPad.
```	

---
##SuperCollider
The word singing was included in the name of this program because it was designed to be auditory as well as purely visual.

There are 3 types of control signals that **Singing FishBirds** sends to **SuperCollider**:

- Frequency
- Panning
- Amplitude

**Singing FishBirds** has these signals for each fish.
Unfortunately **SuperCollider** cannot handle the amount of data to control all these at once for each fish (the maximum number of fish with 2 control signals is 22).

###Setup
To get started with **SuperCollider**, you first need to [download](http://supercollider.sourceforge.net/downloads/) and install it.

Once you have installed **SuperCollider** start it up and copy the SynthDef code in the "extra code" section of this readme into the area on the left.

Start up your server by pressing *Command + B* on a Mac, or by clicking *Language -> Boot Server*.

Once you have the server started up, `highlight` the SynthDef on the left and press *Enter*. Note this is not the same as *Return* most Macs now have return and enter as the same key and you must hold *Shift* or *fn* to get *Enter*.

If successful the right hand page should have "**a SynthDef**" at the most recent readout.

If unsuccessful, check that you copied the SynthDef in full that your server is booted, and you used the correct input to run the SynthDef.

###Issues
As I explained earlier **SuperCollider** cannot handle the number of signals I want to throw at it. So you will most likely see errors pop up in the **SuperCollider** console. Also if you exit **Singing FishBirds** and continue to hear sounds, just turn off **SuperCollider** or restart the server if you wish to re-open **Singing FishBirds**.

---

##Sound Modes and Variables

In the control program I have built in a number of ways of changing the way that **Singing FishBirds** outputs control signals to **SuperCollider**. This lets us get around the pesky problem of control signal limits, and gives us the opportunity to further experiment with the different ways that the fish can sing.

###Sound Modes

```
WIND
The fish sing higher or lower frequencies based on their Y position on screen plus FREQUENCYRANGE, their X position controls their individual panning.

```

```
MONOWIND
Is the same as WIND only instead of the X location determining panning, the amplitude of each fish is determined by its size. 
Note: The volume can get out of control. Turn your speakers down.
```
	
```
SOME
The fish sing at a multiple of FREQUENCYRANGE modified by their size (proximity to other fish) and their X location controls their panning.
	
```
```
SOMEINVERT
The fish sing at an inverted method of SOME, i.e. they no longer get lower in a group but higher.
Note: Untested. I have no idea how well this works, use it at your own risk.
```

###Sound Variables

```
FREQUENCYRANGE
Changes the global frequency modifier. For WIND and MONOWIND it is additive, for SOME and SOMEINVERT it is multiplicative.
```	

```
REVERB
Controls the reverb. Duh.
```	

```
PANWEIGHT
Controls the strength of panning.
```	

---
##Other Useful Features

I have built in a couple of other useful features that have made things easier for me in using **Singing FishBirds**.

```
SAVE
Saves an uncompressed .tiff image to the folder that the program resides in. If using the networked version then it is saved on the client side.
```	

```
LOCKBG
Stops redrawing the background. This causes the fishes tails to become permanent, at least until you press it again.
Note: Does not apply to BEZIER.
```	

```
BACKGROUNDALPHA
Changes the strength of the background. If maxed out, the fish will have no tails, if 0 the tails will stay.
```	

```
FRAMERATE (TouchOSC-ONLY)
Changes the frameRate, allows slowing down of the fish so that you may input other commands.
	
```
---
##Extra Code

**SuperCollider** Synthdef:


	SynthDef(\sine_harmonic, { |outbus = 0, freq = 0, amp = 0.1, pan = 0|
		var data, env;
		data = SinOsc.ar(freq, 0, amp);
		data = Pan2.ar(data, pan);
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
---
##Credits
This project would not have been possible without the contribution of thes special people:

**Daniel Shiffman** - [flocking algorithm](http://processing.org/learning/topics/flocking.html).

**Andreas Schlegel** - [controlP5](http://www.sojamo.de/libraries/controlP5/), [oscP5](http://www.sojamo.de/libraries/oscp5/)

**Whoever the hell designed TouchOSC** - [TouchOSC](http://hexler.net/)