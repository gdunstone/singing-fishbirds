
/*One ControlFrame to rule them all, and in their methods bind them */

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
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
ListBox l;
RadioButton s;
RadioButton r;
public class ControlFrame extends PApplet {
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
  float separationdistance = 25.0f;
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

  
  public void setup() {
    addresslist = new ArrayList<NetAddress>();
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
      .setValue(0.5)
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
      .setRange(20,0.5)
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
      .setValue(1.5)
      .setPosition(160,90)
      .setRadius(20)
      .setDragDirection(Knob.VERTICAL)
      .setLabel("separationforce");

    cp5.addKnob("separationdistance")
      .setRange(0,50)
      .setValue(25.0)
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

      /*Multilist*/


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
        print(int(theEvent.getGroup().getArrayValue()[i]));
      }
      println("\t "+theEvent.getValue());
      mode = theEvent.getValue();
    }

    if(theEvent.isFrom(s)) {
      print("got an event from "+theEvent.getName()+"\t");
      for(int i=0;i<theEvent.getGroup().getArrayValue().length;i++) {
        print(int(theEvent.getGroup().getArrayValue()[i]));
      }
      println("\t "+theEvent.getValue());
      soundmodevar = theEvent.getValue();
    }

}
  public void draw() {
    background(0);
    address = cp5.get(Textfield.class,"input").getText();
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
      exitval =1;
      super.exit();
  }

  public void createIp()
  {
    addAddress(new NetAddress(address,12000));
    println("Added ip: "+address+" to the address list");
    println("address list:");
    for(int i=0; i<addresslist.size(); i++)
      {
        println(cf.addresslist.get(i));
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
      exitval = 1;
      super.exit();
  }


  ControlP5 cp5;

  Object parent;
    
} 

