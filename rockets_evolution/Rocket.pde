class Rocket implements Comparable {
  PVector[] genes;
  PVector loc, vel, acc;
  
  Rocket(PVector[] genes, PVector loc) {
    this.genes = genes;
    this.loc = loc;
    
    this.vel = new PVector();
    this.acc = new PVector();
  }
  
  void show() {
    circle(loc.x, loc.y, 10);
  }
  
  void run(int iteration, Obsticle[] obsticles) {
    
    for (Obsticle o : obsticles) {
      
      if (o.isInside(PVector.add(loc, PVector.add(vel, PVector.add(acc, genes[iteration]))))) {
        return;
      }
    }
    
    acc.add(genes[iteration]);
    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
  }
  
  int compareTo(Object o) {
    float f1 = fitness(this);
    float f2 = fitness((Rocket) o);
    
    return (int)(f1 - f2);
  }
}  
