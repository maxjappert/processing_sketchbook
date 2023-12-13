import processing.video.*;

Mover[] movers;
PVector force;
Capture video;
float t, speed;

  void captureEvent(Capture video) {
  // Step 4. Read the image from the camera.
    video.read();
  }

void setup() {
  size(1500, 1500);
  background(0);
  
  movers = new Mover[10000];
  
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(random(width), random(height));
  }
  
  force = new PVector(0, 0.1);
  t = 0;
  speed = 5;
  
  video = new Capture(this, width, height);
  video.start();
}

void draw() {
  t += 0.05;
  video.loadPixels();
  
  for(int i = 0; i < movers.length; i++) {
    force = new PVector((noise(t+i/10)-0.5) * speed, (noise(t+1)-0.5+i/10)*speed);
    movers[i].applyForce(force);
    movers[i].update();
    
    stroke(video.pixels[floor(movers[i].loc.x) + floor(movers[i].loc.y)*width]);  
    fill(video.pixels[floor(movers[i].loc.x) + floor(movers[i].loc.y)*width]);
    square(movers[i].loc.x, movers[i].loc.y, 10);
  }
}
