// Code from http://processing.org/learning/topics/flocking.html
// by Daniel Shiffman
//
// Other code from Arcc.cc


Flock flock;
int numberOfBoids = 120;
void setup() {
  size(900, 500);
  flock = new Flock();
  //add initial
  for (int i=0; i<numberOfBoids; i++) {
    //flock.addBoid(new Boid(random(0,100)),random(0,100));
    flock.addBoid(new Boid(random(1000), random(500)));
  }
}

float mouseWeight=0.4;
int numberOfPoints = 5;
float[] numbers = new float[numberOfPoints];
boolean started = false;

void draw() {
  frameRate(60);
  if (started==true)
    flock.run();
  fill(0, 20);
  rect(0, 0, width, height);
  ellipse(mouseX,mouseY,10,10);
}


void mousePressed() {
  //flock.addBoid(new Boid(mouseX,mouseY));
  if (started==false) {
    started = true;
  }
  else {
    started = false;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) 
    {
      mouseWeight = mouseWeight+0.1;
    } 
    else if (keyCode == DOWN) 
    {
      mouseWeight = mouseWeight-0.1;
    }
  }
}

//boid class

class Boid {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float colour;
  float diameter;
  float r;
  float maxforce; //maximum steering force
  float maxspeed; //max speed

    Boid(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    r = 2.0;
    maxspeed = 2;
    maxforce = 0.03;
  }

  //run the system
  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  //we accumulate a new acceleration each time base on 3 rules

  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids); //separation
    PVector ali = align(boids); //alignment
    PVector coh = cohesion(boids); //cohesion
    PVector mouse = mouse(boids); //mouse
    //arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    mouse.mult(mouseWeight);
    //add the force vectors to accel
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(mouse);
  }

  void update() {
    //update velocity
    velocity.add(acceleration);
    //limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    //reset acceleration to 0 each cycle
    acceleration.mult(0);
  }

  //a method that calculates and applies a steering force towards a target
  // steer = desired minus velocity
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location); //a vector pointing from the location to the target
    //normalie desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    //steering = desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce); //limit to the maximum steering force
    return steer;
  }

  void render() {
    smooth();
    noStroke();
    //fill (colour*((cModA+cModB)/2), colour*cModA, colour*cModB, 120);
    noFill();
    pushMatrix();
    translate(location.x, location.y);
  for (int i = 0; i<numberOfPoints; i++){
  numbers[i]=random(0,7-diameter/30);
  }
  stroke(255);
  strokeWeight(2);
  

  beginShape();
  for (int i=0; i<numberOfPoints; i++){
    if(i<numberOfPoints-1)
    {vertex(numbers[i], numbers[i+1]);}
    else
    {vertex(numbers[numberOfPoints-1],numbers[0]);}
  }
  
  endShape();
    popMatrix();
  }

  //wraparound 
void borders() {
   
   
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
  PVector separate(ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    //for every boid in the system chech if its too close
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      //if the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      diameter = d;
      colour = d-200;
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
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
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
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
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
  //mouse attraction/revulsion
    PVector mouse (ArrayList<Boid> boids) {
    float distan = 15;
    PVector sum = new PVector(mouseX, mouseY);
    int count = 0;
    for (Boid other : boids) {
      float d= PVector.dist(location, other.location);
      if ((d > 0) && (d < distan)) {
        sum = sum; //add location
        count++;
      }
      
    }
      /*if (location.x> mouseX-40 && location.x<mouseX+40)
      {
        if (location.y>mouseY-40&& location.y<mouseY+40)
        {velocity.sub(velocity);
         velocity.normalize();
        }
      }*/
    if (count > 0) {
      
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

  Flock() {
    boids = new ArrayList<Boid>(); //initialize the arraylist
  }
  void run() {
    for (Boid b : boids) {
      b.run(boids); //Passing the entire list of boids to each boid individually
    }
  }
  void addBoid(Boid b) {
    boids.add(b);
  }
}


