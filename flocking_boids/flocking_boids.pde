ArrayList<Boid> boids;

void setup() {
  size(1920, 1080, P2D);
  boids = new ArrayList<Boid>();
}

void draw() {
  background(255);
  
  for (int i = 0; i < 1500; i++) {
    boids.add(new Boid(random(width), random(height)));
  }
  
  for (Boid b : boids) {
    b.flock(boids);
    b.update();
  }
  
  ArrayList<Integer> toRemove = new ArrayList<Integer>();
  
  for (Boid b : boids) {
    if (b.loc.x < width && b.loc.x >= 0 && b.loc.y < height && b.loc.y >= 0) {
      b.display();
    } else {
      toRemove.add(boids.indexOf(b));
    }
  }
  
  int counter = 0;
  for (Integer i : toRemove) {
    boids.remove(boids.get(i-counter));
    counter++;
  }
  
  saveFrame("frames/####.png");
}
