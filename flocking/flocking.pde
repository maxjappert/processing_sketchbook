PVector target;
ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
float noiseIndex = 0;

void setup() {
  size(600, 600);
  target = new PVector(width/2, height/2);
  
  for (int i = 0; i < 100; i++) {
    //vehicles.add(new Vehicle(random(600), random(600)));
  }
  
  background(0);
}

void draw() {
  //background(255);
  ArrayList<Integer> toRemove = new ArrayList<Integer>();
  
  for (Vehicle vehicle : vehicles) {
    vehicle.update(target);
    
    if (abs(vehicle.loc.x - target.x) < 3 && abs(vehicle.loc.y - target.y) < 3) {
      toRemove.add(vehicles.indexOf(vehicle));
    }
  }
  
  for (int index : toRemove) {
    vehicles.remove(index);
  }
  
  for (int i = 0; i < 2; i++) {
    vehicles.add(new Vehicle(random(width, width+200), random(height)));
    vehicles.add(new Vehicle(random(-200, 0), random(height)));
    vehicles.add(new Vehicle(random(width), random(-200, 0)));
    vehicles.add(new Vehicle(random(width), random(height, height+200)));
    vehicles.add(new Vehicle(random(width, width+200), random(height, height + 200)));
    vehicles.add(new Vehicle(random(-200, 0), random(-200, 0)));
  }
  
  filter(BLUR);
}
