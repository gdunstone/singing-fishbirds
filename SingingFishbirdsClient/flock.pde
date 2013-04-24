// The FLOCK, a list of Boid objects


class Flock {
  ArrayList<Boid> boids; //an arraylist for the boids to live in
  ArrayList<Synth> synths;
  ArrayList<Synth> pulsesynths;
  Flock(){
    boids = new ArrayList<Boid>(); //initialize the arraylist
    synths = new ArrayList<Synth>();
  }
  void run() {
    for (Boid b : boids) {
      b.run(boids); //Passing the entire list of boids to each boid individually
    }
  }
  void addBoid(Boid b) {
    boids.add(b);
  }
  void addSynth(Synth s){
    synths.add(s);
  }
}