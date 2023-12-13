class Paddle {
  PVector loc;
  int score = 0;
  float len = 80;
  float wid = 5;
  float speed = 15;
  Brain brain;
  
  Paddle(Brain brain) {
    loc = new PVector(-1, -1);
    this.brain = brain;
  }  
  
  Paddle() {
    loc = new PVector();
    this.brain = new Brain();
  }
  
  void makeP1() {
    loc.y = height/2 - len/2;
    loc.x = 100;
  }
  
  void makeP2() {
    loc.y = height/2 - len/2;
    loc.x = width - 100;
  }
  
  void moveUp() {
    if (loc.y > speed) {
     loc.y -= speed;
    }
  }
  
  void moveDown() {
    if (loc.y < height - len) {
      loc.y += speed;
    }
  }
  
  void display() {
    stroke(255);
    fill(255);
    
    rect(loc.x, loc.y, wid, len);
  }
  
  void update(Ball ball) {
    // 0: x distance to ball
    // 1: top y distance to ball
    // 2: bottom y distance to ball
    
    float xDistance = abs(loc.x - ball.loc.x);
    float topYDistance = loc.y - ball.loc.y;
    float bottomYDistance = loc.y + len - ball.loc.y;
    
    float[] input = new float[3];
    
    input[0] = map(xDistance, 0, width, 0, 1);
    input[1] = map(topYDistance, -height, height, -1, 1);
    input[2] = map(bottomYDistance, -height, height, -1, 1);
    
    float[] thought = brain.feedforward(input);
    
    if (thought[0] > thought[1] && thought[0] > thought[2]) {
      moveUp();
    } else if (thought[1] > thought[0] && thought[1] > thought[2]) {
      moveDown();
    }
  }
}  
