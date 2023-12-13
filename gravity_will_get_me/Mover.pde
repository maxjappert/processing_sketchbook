class Mover {
  PVector loc, vel, acc;
  float mass;
  
  Mover(float x, float y, float mass) {
    loc = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    
    this.mass = mass;
  }
  
  void applyForce(PVector force) {
    acc.add(force.div(mass));
  }
  
  void update() {
    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
    
    circle(loc.x, loc.y, mass*10);
  }
}
