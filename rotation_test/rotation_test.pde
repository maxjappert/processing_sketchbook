PVector v;

void setup() {
  size(600, 600);
  v = new PVector(0, 100);
}

void draw() {
  background(255);
  line(width/2, height/2, width/2+v.x, height/2+v.y);
  v.rotate(QUARTER_PI/4);
}
