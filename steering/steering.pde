ArrayList<Vehicle> vehicles;

void setup() {
  size(1920, 1080);
  
  vehicles = new ArrayList<Vehicle>();
  
  for (int i = 0; i < 100; i++) {
    //vehicles.add(new Vehicle(random(width), random(height), new Path(new PVector(0, 0), new PVector(600, 600), 50)));
  }
}

void draw() {
  background(255);
  
  for (int i = 0; i < 100; i++) {
    vehicles.add(new Vehicle(-200, random(height), new Path(new PVector(0, height/2), new PVector(width, height/4), 25)));
  }
  
  for (Vehicle vehicle : vehicles) {
    
    vehicle.steer();
    vehicle.update();
  }
  
  //saveFrame("frames/#####.png");
}
