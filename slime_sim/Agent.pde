class Agent {
  PVector loc, dir;
  
  Agent(PVector loc, PVector dir) {
    this.loc = loc;
    this.dir = dir;
    this.dir.setMag(1);
  }
  
  void display() {
    stroke(255);
    fill(255);
    //circle(loc.x, loc.y, 10);
    point(loc.x, loc.y);
  }
  
  
}
