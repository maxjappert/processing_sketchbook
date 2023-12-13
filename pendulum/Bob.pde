class Bob {
  PVector loc, origin;
  float len, theta, vel, acc;
  
  Bob(PVector origin, float len, float theta) {
    this.origin = origin;
    this.loc = new PVector();
    this.vel = 0;
    this.acc = 0;
    this.len = len;
    this.theta = theta;
    
    loc.x = origin.x + sin(theta)*len;
    loc.y = origin.y + cos(theta)*len;
  }
  
  void update(float gravity, float extraForce) {
    vel += gravity*sin(theta);
    theta += vel + extraForce;
    //loc = loc.add(vel);
    loc.x = origin.x + sin(theta)*len;
    loc.y = origin.y + cos(theta)*len;
    line(origin.x, origin.y, loc.x, loc.y);
    circle(loc.x, loc.y, 10);
  }
}
