class Particle {
  PVector v;
  
  Particle(PVector v) {
    this.v = v;
  }
  
  void display() {
    stroke(0);
    circle(v.x, v.y, 10);
  }
}
