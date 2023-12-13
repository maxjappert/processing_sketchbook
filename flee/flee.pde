ArrayList<Vehicle> vehicles;

void setup() {
  size(600, 600);
  vehicles = new ArrayList<Vehicle>();
  
    for (int i = 0; i < 100; i++) {
    vehicles.add(new Vehicle(random(width), random(height)));
  }
}  

void draw() {
  background(255);
  
  for (Vehicle v : vehicles) {
    v.flee(vehicles);
    v.update();
  }
}

void mouseDragged() {
  vehicles.add(new Vehicle(mouseX, mouseY));
}
