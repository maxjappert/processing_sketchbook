ArrayList<Agent> agents;
float rateOfDecay = 0.001;
float[][] trailMap;
float sensoryLength = 9;
int spawnRadius = 10;
float f;
float sensoryAngle = QUARTER_PI;
float rotationAngle = QUARTER_PI / 2;
boolean enable_random_gen = false;

void setup() {
  size(512, 512);
  f = 0;
  agents = new ArrayList<Agent>();
  
  for (int i = 0; i < 10000; i++) {
    //PVector loc = new PVector(random(width/2-spawnRadius, width/2+spawnRadius), random(height/2-spawnRadius, height/2+spawnRadius));
    PVector loc = PVector.add(new PVector(width/2, height/2), PVector.mult(PVector.random2D(), spawnRadius));
    //PVector loc = new PVector(random(width), random(height));
    //PVector dir = PVector.sub(new PVector(width/2, height/2), loc);
    PVector dir = PVector.random2D();
    agents.add(new Agent(loc, dir));
  }
  
  trailMap = new float[width][height];
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      trailMap[x][y] = 0;
    }
  }  
}

void draw() {
  background(0);
  f += 0.03;
  
  if (enable_random_gen) {
    for (int i = 0; i < 200; i++) {
      //PVector loc = new PVector(random(width/2-spawnRadius, width/2+spawnRadius), random(height/2-spawnRadius, height/2+spawnRadius));
      PVector loc = new PVector(random(width), random(height));
      //PVector loc = new PVector(random(width), random(height));
      //PVector dir = PVector.sub(new PVector(width/2, height/2), loc);
      PVector dir = PVector.random2D();
      agents.add(new Agent(loc, dir));
    }
  }
  
  //loadPixels();
  for (int i = 2; i < height-2; i++) {
   for (int j = 2; j < width-2; j++) {
     trailMap[j][i] = blur(i, j, 2);
     
     if (trailMap[j][i] < 0) {
       trailMap[j][i] = 0;
     }
     
     //pixels[i*width+j] = color(map(trailMap[j][i], 0, 1, 0, 255));
   }
  }
  //updatePixels();
  
  for (int i = 0; i < 1000; i++) {
    //agents.add(new Agent(new PVector(width/2, height/2), PVector.fromAngle(map(noise(f), 0, 1, 0, TWO_PI))));
  }
  
  for (Agent a : agents) {
    a.display();
  }

  
  for (Agent a : agents) {    
    // Motor stage
    PVector newCoords = PVector.add(a.loc, a.dir);
    if (successfulMoveForward(newCoords)) {
      a.loc.add(a.dir);
      trailMap[floor(newCoords.x)][floor(newCoords.y)] += 5;
    } else {
      while(!successfulMoveForward(newCoords)) {
        a.dir = PVector.random2D();
        newCoords = PVector.add(a.loc, a.dir);
      }
    }
    
    // Sensory stage
    
    // Sample trail map values
    PVector dirCopy = PVector.mult(a.dir, sensoryLength);
    dirCopy.rotate(-sensoryAngle);
    PVector newCoordsLeft = PVector.add(a.loc, dirCopy); 
    dirCopy = PVector.mult(a.dir, 9);
    dirCopy.rotate(sensoryAngle);
    PVector newCoordsRight = PVector.add(a.loc, dirCopy);
    
    float F = getLegalTrailMapEntry(newCoords);
    float FL = getLegalTrailMapEntry(newCoordsLeft);
    float FR = getLegalTrailMapEntry(newCoordsRight);
        
    if (F > FL && F > FR) {
      // all good, continue facing the same direction!
    } else if (F < FL && F < FR) {
      float pFL = FL / (FL+FR);
      if (random(1) < pFL) {
        a.dir.rotate(-rotationAngle);
      } else {
        a.dir.rotate(rotationAngle);
      }
    } else if (FL < FR) {
      a.dir.rotate(rotationAngle);
    } else if (FR < FL) {
      a.dir.rotate(-rotationAngle);
    }
  }
  
  filter(BLUR);
  //saveFrame("frames/#####.png");
}

float getLegalTrailMapEntry(PVector coords) {
  
  if (floor(coords.x) < 0) {
    coords.x = 0;
  }
  
  if (floor(coords.x) > width-1) {
    coords.x = width-1;
  }
  
  if (floor(coords.y) < 0) {
    coords.y = 0;
  }
  
  if (floor(coords.y) > height-1) {
    coords.y = height-1;
  }
  
  return trailMap[floor(coords.x)][floor(coords.y)];
}

boolean successfulMoveForward(PVector newCoords) {
  return newCoords.x >= 0 && newCoords.x <= width-1 && newCoords.y >= 0 && newCoords.y <= height-1;
}

float blur(int index_i, int index_j, int degree) {
  float value = 0;
  int normaliser = 0;
  for (int i = index_i-degree; i <= index_i+degree; i++) {
    for (int j = index_j-degree; j <= index_j+degree; j++) {
      value += trailMap[i][j];
      normaliser++;
    }
  }
  
  return value / normaliser;
}

void keyPressed() {
  if (keyCode == UP) {
    sensoryLength++;
    println("Sensory length: " + sensoryLength);
  } else if (keyCode == DOWN) {
    sensoryLength--;
    println("Sensory length: " + sensoryLength);
  } else if (key == 'w' || key == 'W') {
    sensoryAngle += PI/16;
    println("Sensory angle: " + sensoryAngle);
  } else if (key == 's' || key == 'S') {
    sensoryAngle -= PI/16;
    println("Sensory angle: " + sensoryAngle);
  }  else if (key == 'e' || key == 'E') {
    rotationAngle += PI/16;
    println("Rotation angle: " + rotationAngle);
  } else if (key == 'd' || key == 'D') {
    rotationAngle -= PI/16;
    println("Rotation angle: " + rotationAngle);
  } else if (keyCode == ENTER) {
    for (int i = 0; i < agents.size(); i++) {
      agents.get(i).dir =  PVector.random2D();
    }
  } else if (key == 'u') {
    for (int i = 0; i < 10000; i++) {
      //PVector loc = new PVector(random(width/2-spawnRadius, width/2+spawnRadius), random(height/2-spawnRadius, height/2+spawnRadius));
      PVector loc = PVector.add(new PVector(width/2, height/2), PVector.mult(PVector.random2D(), spawnRadius));
      //PVector loc = new PVector(random(width), random(height));
      //PVector dir = PVector.sub(new PVector(width/2, height/2), loc);
      PVector dir = PVector.random2D();
      agents.add(new Agent(loc, dir));
    }
  } else if (key == 'p') {
    enable_random_gen = !enable_random_gen;
  }
}
