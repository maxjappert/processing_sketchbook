float maxSpeed = 3;
float maxForce = 0.1;
float neighDist = 50;

class Boid {
  PVector loc, vel, acc;
  
  Boid(float x, float y) {
    loc = new PVector(x, y);
    vel = new PVector(random(-maxSpeed, maxSpeed), random(-maxSpeed, maxSpeed));
    acc = new PVector();
  } 
  
  void applyForce(PVector force) {
    acc.add(force);
  }
  
  void update() {
    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
  }
  
  void flock(ArrayList<Boid> boids) {
  
    ArrayList<Boid> selectedBoids = new ArrayList<Boid>();
    
    for (Boid b : boids) {
      float d = PVector.dist(b.loc, loc);
      if (d <= neighDist && d > 0) {
        selectedBoids.add(b);
      }
    }
    
    PVector sep = separate(selectedBoids);
    PVector ali = align(selectedBoids);
    PVector coh = cohesion(selectedBoids);
    
    // apply arbitrary weights
    sep.mult(1);
    ali.mult(2);
    coh.mult(2);
  
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
  PVector align(ArrayList<Boid> boids) {
    PVector force = new PVector();
    int count = 0;
    
    for (Boid b : boids) {
      float d = PVector.dist(b.loc, loc);
      if (d <= neighDist && d > 0) {
        force.add(b.vel);
        count++;
      }
    }
    
    if (count > 0) {
      force.div(count);
      force.setMag(maxSpeed);
    
      force = PVector.sub(force, vel);
      force.limit(maxForce);
      return force;
    } else {
      return new PVector();
    }
  }
  
  PVector cohesion(ArrayList<Boid> boids) {
    PVector force = new PVector();
    int count = 0;
    
    for (Boid b : boids) {
      float d = PVector.dist(b.loc, loc);
      if (d <= neighDist && d > 0) {
        force.add(b.loc);
        count++;
      }
    }
    
    if (count > 0) {
      force.div(count);
      return seek(force);
    } else {
      return new PVector();
    }
  }
  
  PVector separate(ArrayList<Boid> boids) {
    float vicinity = 10;
    
    PVector force = new PVector();
    int count = 0;
    
    for (Boid b : boids) {
      float d = PVector.dist(loc, b.loc);
      if (d < vicinity && d > 0) {
        PVector diff = PVector.sub(loc, b.loc);
        diff.normalize();
        diff.div(d);
        
        force.add(diff);  
        count++;
      }
    }
    
    if (count > 0) {
      force.div(count);
      force.normalize();
      force.mult(maxSpeed);
      PVector steer = PVector.sub(force, vel);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector();
    }
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.setMag(maxSpeed);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    return steer;
  }
  
  void display() {
    //circle(loc.x, loc.y, 10);
    //line(loc.x, loc.y, loc.x + vel.x, loc.y + vel.y);
    point(loc.x, loc.y);
  }
}
