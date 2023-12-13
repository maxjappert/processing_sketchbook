class Vehicle {
  float maxSpeed, maxForce;
  PVector loc, vel, acc;
  
  Vehicle(float x, float y) {
    maxSpeed = 1;
    maxForce = 0.1;
    
    loc = new PVector(x, y);
    vel = new PVector(random(-maxSpeed, maxSpeed), random(-maxSpeed, maxSpeed));
    acc = new PVector();
  }
  
  void update(PVector target) {
    
    PVector toTarget = PVector.sub(target, loc);
    PVector force = PVector.sub(toTarget, vel);
    force.limit(maxForce);
    vel = vel.add(force);
    loc = loc.add(vel);
    
    stroke(255);
    circle(loc.x, loc.y, 1);
    line(loc.x, loc.y, loc.x + vel.x, loc.y + vel.y);
    
    if (abs(target.x - loc.x) < 50 && abs(target.y - loc.y) < 50) {
      vel = vel.div(2);
    }
  }
}
