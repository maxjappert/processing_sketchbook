class Bird {
  Brain brain;
  float x = 100;
  float y, yAcc, yVel;
  int ceiling;
  int radius = 20;
  float terminalVel = 5;
  float maxVel = -10;
  float distanceTravelled;
  boolean alive;
  
  Bird(int ceiling, float startPosY, Brain brain) {
     this.brain = brain;
     y = startPosY;
     this.ceiling = ceiling;
     yAcc = 0;
     yVel = 0;
     distanceTravelled = 0;
     alive = true;
  }
  
  void applyYForce(float force) {
    yAcc += force;
  }
  
  void update(float speed) {
    yVel += yAcc;
    
    if (yVel > terminalVel) {
      yVel = terminalVel;
    } else if (yVel < maxVel) {
      yVel = maxVel;
    }
    
    y += yVel;
    yAcc = 0;
    distanceTravelled += speed;
  }
  
  Pipe getNextPipe(ArrayList<Pipe> pipes) {
    Pipe pipe = pipes.get(pipes.size()-1);
    
    for (Pipe p : pipes) {
      if (p.x + p.size > this.x && abs(p.x - this.x) < abs(pipe.x - this.x)) {
        pipe = p;
      }
    }
    
    return pipe;
  }
  
  void display() {
    circle(x, y, radius);
  }
  
  void flap() {
    applyYForce(-15);
  }
  
  boolean hasCollided(ArrayList<Pipe> pipes) {
    for (Pipe p : pipes) {
      if (x < p.x || x > p.x + p.size) {
        continue;
      } else {
        return y + radius/2 >= p.bottomY || y + radius/2 <= p.bottomY - p.gap;
      }
    }
    
    return false;
  }
}
