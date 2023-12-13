double range = 0.05;
double yOffset = 0.8;
double xOffset = 0;

void setup() {
  size(300, 300);
  noLoop();
 
  println("done");
}

void draw() {
    loadPixels();
  
  for (int i = 0; i < width; i++) {
     for (int j = 0; j < height; j++) {
       ComplexNumber c = new ComplexNumber(-range + xOffset + ((2*range)/width)*i, -range + yOffset + ((2*range)/height)*j);
      // PVector c = new PVector((float)(-range + xOffset + ((2*range)/width)*i), (float)(-range + yOffset + ((2*range)/height)*j));
       //PVector z = new PVector(0, 0);
       ComplexNumber z = new ComplexNumber(0, 0);
       
       for (int k = 0; k < 100; k++) {
         //z = PVector.add(new PVector(z.x*z.x - z.y*z.y, z.y*z.x + z.x*z.y), c);
         z = z.mult(z).add(c);
       }
       
       if (z.absSquared() < 1000*1000) {
         pixels[j*width+i] = color(0);
       } else {
         pixels[j*width+i] = color(255);
       }
     }
  }
  
  updatePixels();
}

void keyPressed() {
  if (key == 'u') {
    range += range/100;
  } else if (key == 'j') {
    range -= range/100;
  } else if (key == 'a') {
    xOffset -= range/100;
  } else if (key == 'd') {
    xOffset += range/100;
  } else if (key == 'w') {
    yOffset -= range/100;
  } else if (key == 's') {
    yOffset += range/100;
  }
  
  draw();
}
