void setup() {
  size(600, 600);
}

void draw() {
  background(255);
  stroke(0);
  line(200, 400, 400, 400);
  line(200, 400, mouseX, mouseY);
  PVector A = new PVector(200, 0);
  PVector B = PVector.sub(new PVector(mouseX, mouseY), new PVector(200, 400));
  float theta = acos(A.dot(B)/(A.mag()*B.mag()));
  fill(0);
  text(str(map(theta, 0, TWO_PI, 0, 360)), 50, 50, 300, 300);
  
  A.normalize();
  float d = A.dot(B);
  A.mult(d);
  A.add(new PVector(200, 400));
  circle(A.x, A.y, 5);
}

//map(theta, 0, TWO_PI, 0, 360)
