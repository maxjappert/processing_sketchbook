class Vehicle {
  PVector loc, vel, acc;
  Path path;
  float maxSpeed, maxForce;
  
  Vehicle(float x, float y, Path path) {
    maxSpeed = 0.5;
    maxForce = 0.02;
    
    loc = new PVector(x, y);
    vel = new PVector(maxSpeed, 0);
    acc = new PVector();
    this.path = path;
  }
  
  PVector getNormalPoint(PVector predictedLoc) {    
    // step 2: check if predicted future location is on path
    PVector a = PVector.sub(predictedLoc, path.start);
    PVector b = PVector.sub(path.end, path.start);
    b.normalize();
    b.mult(a.dot(b));
    return PVector.add(path.start, b);
  }
  
  void steer() {
    PVector predict = vel.copy();
    predict.normalize();
    predict.mult(50);
    PVector predictedLoc = PVector.add(loc, predict);
    
    PVector normalPoint = getNormalPoint(predictedLoc);
    
    // If the predicted future point doesn't lie on the path we need to steer
    if (PVector.dist(predictedLoc, normalPoint) > path.radius) {
      PVector dir = PVector.sub(path.end, path.start);
      dir.normalize();
      dir.mult(1);
      PVector target = PVector.add(normalPoint, dir);
      seek(target);
    }
            
    update();
  }
  
  void seek(PVector target) {
    PVector toTarget = PVector.sub(target, loc);
    PVector force = PVector.sub(toTarget, vel);
    force.limit(maxForce);
    acc.add(force);
  }
  
  void update() {
    vel.add(acc);
    acc.mult(0);
    loc.add(vel);
    point(loc.x, loc.y);
  }
  
  boolean onPath() {
    
    return PVector.dist(loc, getNormalPoint(loc)) < path.radius;
  }
}
