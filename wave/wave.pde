float x_ = 0;

void setup() {
  size(600, 600);
}

void draw() {
  background(255);
  translate(0, height/2);
  stroke(0);
  fill(0);
  
  float x = 0;
  
  while (x < width) {
    circle(x, waveFunction(x_), 10);
    x += 0.1;
    x_ += 0.001;
  }
}

float waveFunction(float x) {
  return 100 * sin(x);// * cos(x/2);
}
