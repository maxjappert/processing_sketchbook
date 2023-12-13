float d;

void setup() {
  background(255);
  size(1920, 1080);
  d = 1;
}

void draw() {
  foo(width/2, height/2, d);
  d *= 1.04;
  if (d > 5000) {
    d /= 2;
  }
  
}

void foo(float x, float y, float d) {
  circle(x, y, d);
  if (d > 1) {
    foo(x, y, d/2);
  }
}
