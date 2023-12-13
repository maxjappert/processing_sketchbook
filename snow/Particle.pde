class Particle {
  PVector loc, vel, acc;
  
  Particle(PVector loc) {
    this.loc = loc;
    this.vel = new PVector();
  }
  
  void update(PVector force) {
    vel = vel.add(force);
    loc = loc.add(vel);
    translate(loc.x, loc.y, loc.z);
    sphere(1);
    translate(-loc.x, -loc.y, -loc.z);
    
    if (loc.y >= height) {
      print("loc.y");
      vel = vel.mult(-1);
    }
  }
}
