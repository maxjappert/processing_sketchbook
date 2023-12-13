//PVector bob;
float len;
float theta;
Bob bob1, bob2;
ArrayList<PVector> locs;
PGraphics canvas;

void setup() {
  size(2000, 2000);
  PVector origin = new PVector(width/2, 0);
  len = height/2;
  //bob = new PVector(0, 0);
  bob1 = new Bob(origin, len, PI/4);
  bob2 = new Bob(bob1.loc, len/2, PI/3);
  locs = new ArrayList<PVector>();
  canvas =  createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
}

void draw() {
  //background(255);
  image(canvas, 0, 0);
  bob1.update(-0.01, 0);
  bob2.origin = bob1.loc;
  bob2.update(-0.04, -bob1.vel);
  
  //locs.add(bob2.loc); //<>//
  
  canvas.beginDraw();
  canvas.stroke(0);
  canvas.strokeWeight(4);
  canvas.point(bob2.loc.x, bob2.loc.y);
  canvas.endDraw();
    
  //for (int i = 1; i < locs.size(); i++) {
  //  stroke(0);
  //  line(locs.get(i-1).x, locs.get(i-1).y, locs.get(i).x, locs.get(i).y);
  //}
    
  //theta = map(mouseX, 0, width, -PI, PI);
  //bob.x = origin.x + sin(theta)*len;
  //bob.y = origin.y + cos(theta)*len;
  //line(origin.x, origin.y, bob.x, bob.y);
  //circle(bob.x, bob.y, 10);
}

void adder(PVector v) {
  locs.add(v); //<>//
}
