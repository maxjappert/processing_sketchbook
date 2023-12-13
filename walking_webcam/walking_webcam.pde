import processing.video.*;

float x, y, speed;
Capture video;

void setup() {
  size(600, 600);
  x = width / 2;
  y = height / 2;
  speed = 150;
  video = new Capture(this, width, height);
  video.start();
  frameRate(100);
}

  void captureEvent(Capture video) {
  // Step 4. Read the image from the camera.
    video.read();
  }

void draw() {
  for (int i = 0; i < 100; i++) {
    loadPixels();
    video.loadPixels();
  
    x += random(-speed, speed);
    y += random(-speed, speed);
    
    if (x <= 0 || y <= 0 || x >= width || y >= height) {
      x = random(floor(width));
      y = random(floor(height));
    }
    
    stroke(video.pixels[floor(x) + floor(y)*width]);  
    fill(video.pixels[floor(x) + floor(y)*width]);
    circle(x, y, 10);
  }
}
