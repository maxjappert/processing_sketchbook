ArrayList<Pipe> pipes;
Bird[] birds;
float distanceBetweenPipes = 300*2;
float gap = 120*2;
float pipeWidth = 50;
float speed = 2;
int ceiling = 0;
float startPosX = 100;
float startPosY = 300;
float mutationProb = 0.1;
float mutationDeg = 0.5;
boolean newRound = false;
int populationSize = 100;
int generationCounter;
int framerate = 200;

void setup() {
  size(1200, 1200);
  pipes = new ArrayList<Pipe>();
  pipes.add(new Pipe(width, height, gap, pipeWidth, speed));
  birds = new Bird[populationSize];
  generationCounter = 0;
   
  for (int i = 0; i < populationSize; i++) {
    birds[i] = new Bird(0, height/2, new Brain());
  }
}

void draw() {
  background(255);
  frameRate(framerate);
  
  if (!newRound) {
    boolean birdAlive = false;
    
    for (Bird b : birds) {
      fitness(b);
      if (!b.hasCollided(pipes) && b.alive) {
        birdAlive = true;
        Pipe nextPipe = b.getNextPipe(pipes);
        
        float nextPipeX = map(nextPipe.x, b.x, width, 0, 1);
        float nextPipeTop = map(nextPipe.bottomY + gap, 0, height, 0, 1);
        float nextPipeBottom = map(nextPipe.bottomY, 0, height, 0, 1);
        float birdY = map(b.y, 0, height, 0, 1);
        float birdVel = map(b.yVel, b.maxVel, b.terminalVel, 0, 1);
          
        if (0.5 < b.brain.feedforward(new float[]{nextPipeX, nextPipeTop, nextPipeBottom, birdY, birdVel})) {
          b.flap();
        }
        
        b.applyYForce(1);
        b.update(speed);
        
        if (b.y < 0) {
          b.y = 0;
        } else if (b.y > height) {
          b.y = height;
        }
        
        b.display();  
      } else {
        b.alive = false;
      }
    }
    
    if (!birdAlive) {
      newRound = true;
    }
      
    for (Pipe p : pipes) {
      p.update();
      p.display();
    }
  
    if (pipes.get(pipes.size()-1).x < width - distanceBetweenPipes) {
      pipes.add(new Pipe(width, height, gap, pipeWidth, speed));
    }
    
    if (pipes.get(0).x + gap < 0) {
      pipes.remove(0);
    }
  } else {
    generationCounter++;
    Bird[] sortedPop = sortPop(birds);
    Bird[] best = new Bird[4];
    
    float normalisedFitness = 0;
    
    for (int i = 0; i < best.length; i++) {
      best[i] = sortedPop[i];
      normalisedFitness += fitness(best[i]);
    }
    
    Bird[] newPop = new Bird[populationSize];
    
    for (int i = 0; i < populationSize; i++) {
      Bird b1 = new Bird(0, height/2, new Brain());
      Bird b2 = new Bird(0, height/2, new Brain());
      
      float keepTrack = 0;
      float rand = random(1);
      for (Bird b : best) {
        float prob = fitness(b) / normalisedFitness;
        if (rand <= prob + keepTrack) {
          b1 = b;
          break;
        }
        keepTrack += prob;
      }
      
      keepTrack = 0;
      rand = random(1);
      for (Bird b : best) {
        float prob = fitness(b) / normalisedFitness;
        if (rand <= prob + keepTrack) {
          b2 = b;
          break;
        }
        keepTrack += prob;
      }

      newPop[i] = crossover(b1, b2);
    }
    
    println("Generation " + generationCounter + " with high score " + fitness(best[0]));
    
    birds = newPop; 
    pipes = new ArrayList<Pipe>();
    pipes.add(new Pipe(width, height, gap, pipeWidth, speed));
    newRound = false;
    //print("Best fitness: " + fitness(best[0]));
  }
}

void keyPressed() {
  if (key == ENTER) {
    birds[0].flap();
  } else if (keyCode == 'S') {
    framerate = ceil(framerate/2);
  } else if (keyCode == 'W') {
    framerate *= 2;  
  }
  
  println("Framerate: " + framerate);
}

float[][] product(float[][] a, float[][] b){
  if (a[0].length != b.length){
    return null;
  } else {
    float[][] result = new float[a.length][b[0].length];
    for (int i = 0; i < result.length; i++){
      for (int j = 0; j < result[0].length; j++){
        float sum = 0;
        for (int k = 0; k < a[0].length; k++){
          sum += a[i][k] * b[k][j];
        }
        result[i][j] = sum;
      }
    }
    return result;
  }
}

Bird crossover(Bird b1, Bird b2) {
  int totalWeights = b1.brain.hiddenWeights.length * b1.brain.hiddenWeights[0].length
    + b1.brain.outputWeights.length * b1.brain.outputWeights[0].length;
  
  int crossoverPoint = floor(random((float)totalWeights));
  
  int counter = 0;
  Brain brain = new Brain();
  
  for (int i = 0; i < b1.brain.hiddenWeights.length; i++) {
    for (int j = 0; j < b1.brain.hiddenWeights[0].length; j++) {
      if (counter < crossoverPoint) {
        brain.hiddenWeights[i][j] = mutate(b1.brain.hiddenWeights[i][j]); //<>//
      } else {
        brain.hiddenWeights[i][j] = mutate(b2.brain.hiddenWeights[i][j]); //<>//
      }
      
      counter++;
    }
  }
  
  for (int i = 0; i < b1.brain.outputWeights.length; i++) {
    for (int j = 0; j < b1.brain.outputWeights[0].length; j++) {
      if (counter < crossoverPoint) {
        brain.outputWeights[i][j] = mutate(b1.brain.outputWeights[i][j]);
      } else {
        brain.outputWeights[i][j] = mutate(b2.brain.outputWeights[i][j]);
      }
      
      counter++;
    }
  }
  
  return new Bird(ceiling, startPosY, brain);
}

Bird[] sortPop(Bird[] arr) {
  int n = arr.length;
  for (int i=1; i<n; ++i)
  {
      Bird k = arr[i];
      int j = i-1;
 
      /* Move elements of arr[0..i-1], that are
         greater than key to one position ahead
         of their current position */
      while (j >= 0 && fitness(arr[j]) < fitness(k))
      {
          arr[j+1] = arr[j];
          j = j-1;
      }
      arr[j+1] = k;
  }
  
  return arr;
}

float fitness(Bird bird) {
  Pipe nextPipe = bird.getNextPipe(pipes);
  float fitness = bird.distanceTravelled - abs((nextPipe.bottomY - gap/2) - bird.x);
  
  if (fitness > 20000 && fitness < 21000) {
    println("Found a bird which mastered the game!");
    println("Hidden Weights:");
    
    for (int i = 0; i < bird.brain.hiddenWeights.length; i++) {
      for (int j = 0; j < bird.brain.hiddenWeights[0].length; j++) {
        print(bird.brain.hiddenWeights[i][j] + " ");
      }
      println("");
    }
    
    println("Output Weights:");
    
    for (int i = 0; i < bird.brain.outputWeights.length; i++) {
      for (int j = 0; j < bird.brain.outputWeights[0].length; j++) {
        print(bird.brain.outputWeights[i][j] + " ");
      }
      println("");
    }
  }
  
  return fitness;
}

float mutate(float x) {
  if (random(1) < mutationProb) {
    return x + randomGaussian() * mutationDeg;
  } else {
    return x;
  }
}
