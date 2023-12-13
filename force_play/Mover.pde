class Mover {
  PVector loc, vel, acc;
  float mass;
  
  Mover(float x, float y) {
    loc = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    
    mass = 1;
  }
  
  void applyForce(PVector force) {
    // F = M*A <=> A = F/M
    
    acc.add(force.div(mass));
  }
  
  void update() {
    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
    
    if(loc.y >= height) {
      loc.y = height-1;
      vel.y *= -1;
    }
    
    if (loc.y <= 0) {
      loc.y = 0;
      vel.y *= -1;
    }
    
    if (loc.x <= 0) {
      loc.x = 0;
      vel.x *= -1;
    }
    
    if (loc.x >= width) {
      loc.x = width-1;
      vel.x *= -1;
    }
  }  
}
