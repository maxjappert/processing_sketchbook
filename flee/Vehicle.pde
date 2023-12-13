class Vehicle {
  PVector loc, vel, acc;

  Vehicle(float x, float y) {
    loc = new PVector(x, y);
    vel = new PVector(random(-1, 1), random(-1, 1));
    acc = new PVector();
  }
  
  void flee(ArrayList<Vehicle> vehicles) {
    ArrayList<Vehicle> neigh = new ArrayList<Vehicle>();
    
    for (Vehicle v : vehicles) {
      if (abs(PVector.sub(v.loc, this.loc).mag()) < 25 && PVector.sub(v.loc, this.loc).mag() != 0) {
        neigh.add(v);
      }
    }
    
    PVector cum = new PVector(0, 0);
    
    for (Vehicle v : neigh) {
      cum.add(PVector.mult(PVector.sub(v.loc, this.loc), -1));
    }
    
    if (neigh.size() != 0) {
      cum.div(neigh.size());
      cum.limit(0.1);
      applyForce(cum);
    }
  }
  
  void applyForce(PVector force) {
    acc.add(force);
  }
  
  void update() {
    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
    stroke(0);
    circle(loc.x, loc.y, 25);
  }
}
