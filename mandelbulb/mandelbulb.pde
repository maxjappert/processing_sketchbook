import peasy.*;

PeasyCam cam;
int DIM;
int n;

void setup() {
  size(1000, 1000, P3D);
  background(0);
  stroke(255);
  n = 8;
  DIM = 64;
  
  cam = new PeasyCam(this, 500);
}

void draw() {
    background(0);

    for (int i = 0; i < DIM; i++) {
    for (int j = 0; j < DIM; j++) {
      boolean edge = false;
      for (int k = 0; k < DIM; k++) {
        
        float x = map(i, 0, DIM, -1, 1);
        float y = map(j, 0, DIM, -1, 1);
        float z = map(k, 0, DIM, -1, 1);
        
        PVector c = new PVector(x, y, z);
        PVector v = new PVector(0, 0, 0);
        
        for (int l = 0; l < 10; l++) {
          v = convert_to_vn(v, n);
          v = v.add(c);
        }
        
        if (sqrt(v.x*v.x + v.y*v.y + v.z*v.z) < 16) {
          if (!edge) {
            //float cl = map(sqrt(v.x*v.x + v.y*v.y + v.z*v.z), 0, 16, 0, 255);
            //cl = abs(cl-255);
            //stroke(cl);
            point(x*100, y*100, -z*100);
            edge = true;
          }
        } else {
          edge = false;
        }
      }  
    }
  }
}

PVector convert_to_vn(PVector v, int n) {
  float x = v.x;
  float y = v.y;
  float z = v.z;
  float r = sqrt(x*x + y*y + z*z);
  float rho = atan2(y, x); 
  float theta = atan2(sqrt(x*x + y*y), z);
    
  PVector vn = new PVector(sin(n*theta)*cos(n*rho), sin(n*theta)*sin(n*rho), cos(n*theta));
  vn = vn.mult(pow(r, n));
  return vn;
}
