Ball ball;
Paddle[] pop;
Paddle[] winners;
int popSize = 10;
int popIt1, popIt2;
float mutationProb = 0.2;
float mutationDeg = 0.5;
float framerate = 20;


void setup() {
  size (600, 600);
  ball = new Ball();
  pop = new Paddle[popSize];
  for (int i = 0; i < popSize; i++) {
    pop[i] = new Paddle();
  }
  winners = new Paddle[popSize*popSize];
  popIt1 = 0;
  popIt2 = 0;
  
  pop[popIt1].makeP1();
  pop[popIt2].makeP2();
}

void draw() {
  frameRate(framerate);
  background(0);
  
  pop[popIt1].update(ball);
  pop[popIt2].update(ball);
  int result = ball.update(pop[popIt1], pop[popIt2]);
  pop[popIt1].display();
  pop[popIt2].display();
  ball.display();
  
  if (result == 1) {
    winners[popIt1 * popSize + popIt2] = pop[popIt1];
  } else if (result == 2) {
    winners[popIt1 * popSize + popIt2] = pop[popIt2];
  }
  
  if (result != 0) { 
   if (popIt2 < popSize-1) {
      popIt2++;
    } else if (popIt1 == popSize-1 && popIt2 == popSize-1) {
      pop = getNewPop();
      println("Generation done");
      popIt1 = 0;
      popIt2 = 0;
    } else {
      popIt2 = 0;
      popIt1++;
    }
    
    pop[popIt1].makeP1();
    pop[popIt2].makeP2();
    ball = new Ball();
  }
}

Paddle[] getNewPop() {
  Paddle[] newPop = new Paddle[popSize];
  Paddle[] sortedPop = sortPop(pop);
  Paddle[] best = new Paddle[4];
  float normalisedFitness = 0;
    
  for (int i = 0; i < 4; i++) {
      best[i] = sortedPop[i];
      normalisedFitness += fitness(best[i]);
  }

  for (int i = 0; i < popSize; i++) {
      Paddle b1 = new Paddle();
      Paddle b2 = new Paddle();
      
      float keepTrack = 0;
      float rand = random(1);
      for (Paddle b : best) {
        float prob = fitness(b) / normalisedFitness;
        if (rand <= prob + keepTrack) {
          b1 = b;
          break;
        }
        keepTrack += prob;
      }
      
      keepTrack = 0;
      rand = random(1);
      for (Paddle b : best) {
        float prob = fitness(b) / normalisedFitness;
        if (rand <= prob + keepTrack) {
          b2 = b;
          break;
        }
        keepTrack += prob;
      }

      newPop[i] = crossover(b1, b2);
    }
  
  return newPop;
}

float fitness(Paddle p) {
  return p.score;
}

Paddle crossover(Paddle b1, Paddle b2) {
  int totalWeights = b1.brain.hiddenWeights.length * b1.brain.hiddenWeights[0].length
    + b1.brain.outputWeights.length * b1.brain.outputWeights[0].length;
  
  int crossoverPoint = floor(random((float)totalWeights));
  
  int counter = 0;
  Brain brain = new Brain();
  
  for (int i = 0; i < b1.brain.hiddenWeights.length; i++) {
    for (int j = 0; j < b1.brain.hiddenWeights[0].length; j++) {
      if (counter < crossoverPoint) {
        brain.hiddenWeights[i][j] = mutate(b1.brain.hiddenWeights[i][j]);
      } else {
        brain.hiddenWeights[i][j] = mutate(b2.brain.hiddenWeights[i][j]);
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
  
  return new Paddle(brain);
}

Paddle[] sortPop(Paddle[] arr) {
  int n = arr.length;
  for (int i=1; i<n; ++i)
  {
      Paddle k = arr[i];
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

float mutate(float x) {
  if (random(1) < mutationProb) {
    return x + randomGaussian() * mutationDeg;
  } else {
    return x;
  }
}

void keyPressed() {
  if (keyCode == UP) {
    framerate *= 2;
    //p2.moveUp();
  } else if (keyCode == DOWN) {
    framerate /= 2;
    //p2.moveDown();
  } else if (key == 'w') {
    //p1.moveUp();
  } else if (key == 's') {
    //p1.moveDown();
  }
}
