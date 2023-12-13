class Ball {
  PVector loc, vel;
  float size = 5;
  float speed = 2;
  int score = 0;
  
  Ball() {
    loc = new PVector(width/2, height/2);
    float r = random(1);
    
    if (r < 0.25) {
      vel = new PVector(speed, speed);
    } else if (r < 0.5) {
      vel = new PVector(speed, -speed);
    } else if (r < 0.75) {
      vel = new PVector(-speed, -speed);
    } else {
      vel = new PVector(-speed, speed);
    }
  }
  
  int update(Paddle p1, Paddle p2) {
  
    if (loc.y <= 0) {
      vel.y = speed;
    }
    
    if (loc.y >= width) {
      vel.y = -speed;
    }
    
    if (loc.x <= p1.loc.x+p1.wid) {
      score++;
      vel.x = speed;
    }
    
    if (loc.x + size >= p2.loc.x) {
      score++;
      vel.x = -speed;
    }
    
    
    loc.add(vel);
    
    if ((loc.x <= p1.loc.x+p1.wid) && (loc.y < p1.loc.y-size || loc.y > p1.loc.y+p1.len)) {
      p2.score = score -1;
      score = 0;
      return 2;
    }
    
    if ((loc.x + size >= p2.loc.x) && (loc.x + size >= p2.loc.x || loc.y > p2.loc.y+p2.len)) {
      p1.score = score-1;
      score = 0;
      return 1;
    }

    return 0;
  }
  
  void display() {
    stroke(255);
    fill(255);
    square(loc.x, loc.y, size);
  }
}
