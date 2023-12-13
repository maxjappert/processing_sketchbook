int init = 0;
int reso = 600;
int gen = 0;

void setup() {
  size(600, 600);
}

void draw() {
  loadPixels();
  for (int i = 0; i < reso; i++) {
    for (int j = 0; j < reso; j++) {
      pixels[i*reso+j] = color(map(noise(i*0.01, j*0.01+1, gen*0.01+2), 0, 1, 0, 255));
    }
  }
  updatePixels();
  gen++;
  println(gen);
}
