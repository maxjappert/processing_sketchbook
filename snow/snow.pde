ArrayList<Particle> particles;

void setup() {
  size(1000, 1000, P3D);
  background(255);
  particles = new ArrayList<Particle>();
  
  //for (int i = 0; i < 10; i++) {
  //  for (int j = 0; j < 10; j++) {
  //    particles.add(new Particle(new PVector(i*100, 10, j*100)));
  //  }
  //}
}

void draw() {
  background(255);
  
  for (int i = 0; i < 10; i++) {
    particles.add(new Particle(new PVector(random(width), 10, random(height))));
  }
  
  for (Particle particle : particles) {
    stroke(0);
    particle.update(new PVector(0, 1, 0));
  }
}
