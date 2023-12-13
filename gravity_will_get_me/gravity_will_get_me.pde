Mover attractor;
Mover[] movers = new Mover[1];
float G = 0.1;

void setup() {
  size(3000, 2000);
  attractor = new Mover(width/2, height/2, 5);
  
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(random(width), random(height), random(1)*5);
  }
  
  background(255);
}

void draw() {
  background(255);
  
  for (Mover mover : movers) {
    PVector r = PVector.sub(attractor.loc, mover.loc);
    float d = r.mag();
    r.normalize();
    PVector F1 = r.mult((G*attractor.mass*mover.mass)/d*d);
    mover.applyForce(new PVector(random(-1, 1), random(-1, 1)));
    
    r = PVector.sub(mover.loc, attractor.loc);
    d = r.mag();
    r.normalize();
    PVector F2 = r.mult((G*attractor.mass*mover.mass)/d*d);
    
    mover.applyForce(F1);
    attractor.applyForce(F2);
    
    mover.update();
    attractor.update();
  }
}
