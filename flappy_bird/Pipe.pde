class Pipe {
  float x;
  float bottomY;
  float gap;
  float speed;
  float size;
  int screenWidth;
  int screenHeight;
  static final int minDistanceToEdgeOfScreen = 50;
  
  Pipe(int screenWidth, int screenHeight, float gap, float pipeWidth, float speed) {
    this.speed = speed;
    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;
    x = screenWidth;
    this.gap = gap;
    this.size = pipeWidth;
    bottomY = random(minDistanceToEdgeOfScreen + gap, screenHeight - minDistanceToEdgeOfScreen);
  }
  
  void update() {
    x -= speed;
  }
  
  boolean isRedundant() {
    return x + size < 0;
  }
  
  void display() {
    rect(x, -20, size, bottomY - gap);
    rect(x, bottomY  , size, screenHeight - bottomY);
  }
}
