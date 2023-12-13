int resolution;
PVector food;
int numInput = 28;
int numHidden1 = 24;
int numHidden2 = 18;
int numOutput = 4;
boolean everyoneDead;
Snake[] population;
int populationSize = 1000;
int numSelected = 20;
int populationIterator;
int generation;
int framerate;
float mutationProb = 0.2;
float mutationDeg = 0.3;


void setup() {
  size(1000, 1000);
  resolution = 10;
  populationIterator = 0;
  generation = 0;
  framerate = 400;
  
  food = new PVector(floor(random(resolution)), floor(random(resolution)));
  
  population = new Snake[populationSize];
  for (int i = 0; i < populationSize; i++) {
    population[i] = new Snake(new Brain(numInput, numHidden1, numHidden2, numOutput));
  }
}

void draw() {
  frameRate(framerate);
  
  if (populationIterator < populationSize) {
    background(255);
    
    if (population[populationIterator].elements.get(0).x == food.x && population[populationIterator].elements.get(0).y == food.y) {
      population[populationIterator].score++;
      population[populationIterator].increaseLength();
      food = new PVector(floor(random(resolution)), floor(random(resolution)));
    }
    
    fill(155);
    square(food.x * (width/resolution), food.y * (height / resolution), width/resolution);
    fill(0);
    
    float[] input = getInputs(population[populationIterator]);
    
    processThought(populationIterator, population[populationIterator].brain.feedforward(input));
    boolean gameOver = !population[populationIterator].update();
    
    population[populationIterator].display();
    population[populationIterator].fitness = fitness(population[populationIterator]);
    
    if (gameOver) {
      populationIterator++;
      newGame();
    }
  } else {
    generation++;
    println("Generation " + generation);
    populationIterator = 0;
    Snake[] sortedPop = sortPop(population);
    Snake[] best = new Snake[numSelected];
    Snake[] newPopulation = new Snake[populationSize];
    
    float normalisedFitness = 0;
    
    for (int i = 0; i < numSelected; i++) {
      best[i] = sortedPop[i];
      normalisedFitness += fitness(best[i]);
    }
    
    for (int i = 0; i < populationSize; i++) {
      Snake s1 = new Snake(new Brain(0, 0, 0, 0));
      Snake s2 = new Snake(new Brain(0, 0, 0, 0));
      
      float keepTrack = 0;
      float rand = random(1);
      for (Snake s : best) {
        float prob = fitness(s) / normalisedFitness;
        if (rand <= prob + keepTrack) {
          s1 = s; //<>//
          break;
        }
        keepTrack += prob;
      }
      
      keepTrack = 0;
      rand = random(1);
      for (Snake s : best) {
        float prob = fitness(s) / normalisedFitness;
        if (rand <= prob + keepTrack) {
          s2 = s;
          break;
        }
        keepTrack += prob;
      }

      newPopulation[i] = crossover(s1, s2); //<>//
    }
    
    population = newPopulation;
    println("High score: " + fitness(best[0]) + "\n");
  }
}

float mutate(float x) {
  if (random(1) < mutationProb) {
    return x + randomGaussian() * mutationDeg;
  } else {
    return x;
  }
}

Snake[] sortPop(Snake[] arr)
{
    int n = arr.length;
    for (int i=1; i<n; ++i)
    {
        Snake k = arr[i];
        int j = i-1;
 
        /* Move elements of arr[0..i-1], that are
           greater than key, to one position ahead
           of their current position */
        while (j>=0 && fitness(arr[j]) < fitness(k))
        {
            arr[j+1] = arr[j];
            j = j-1;
        }
        arr[j+1] = k;
    }
    
    return arr;
}

float[][] product(float[][] a, float[][] b){
  if (a[0].length != b.length){
    return null;
  } else{;
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

float fitness(Snake snake) {
  return snake.score * 100 + snake.lifeSpan;
}

Snake crossover(Snake b1, Snake b2) {
  Brain brain = new Brain(numInput, numHidden1, numHidden2, numOutput);
  
  for (int i = 0; i < b1.brain.hiddenWeights1.length; i++) {
    for (int j = 0; j < b1.brain.hiddenWeights1[0].length; j++) {
      if (random(1) < 0.5) {
        brain.hiddenWeights1[i][j] = mutate(b1.brain.hiddenWeights1[i][j]);
      } else {
        brain.hiddenWeights1[i][j] = mutate(b2.brain.hiddenWeights1[i][j]);
      }
    }
  }
  
  for (int i = 0; i < b1.brain.hiddenWeights2.length; i++) {
    for (int j = 0; j < b1.brain.hiddenWeights2[0].length; j++) {
      if (random(1) < 0.5) {
        brain.hiddenWeights2[i][j] = mutate(b1.brain.hiddenWeights2[i][j]);
      } else {
        brain.hiddenWeights2[i][j] = mutate(b2.brain.hiddenWeights2[i][j]);
      }
    }
  }
  
  for (int i = 0; i < b1.brain.outputWeights.length; i++) {
    for (int j = 0; j < b1.brain.outputWeights[0].length; j++) {
      if (random(1) < 0.5) {
        brain.outputWeights[i][j] = mutate(b1.brain.outputWeights[i][j]);
      } else {
        brain.outputWeights[i][j] = mutate(b2.brain.outputWeights[i][j]);
      }      
    }
  }
  
  return new Snake(brain);
}

void newGame() {
  food = new PVector(floor(random(resolution)), floor(random(resolution)));
}

void keyPressed() {
  if (keyCode == UP) {
    framerate++;
  }
  
  if (framerate < 2) {
    return;
  }
  
  if (keyCode == DOWN) {
    framerate--;
  }
  
  println("Framerate: " + framerate);
}

void processThought(int index, int output) {
  if (output == 0 && (population[index].dir.x == 1.0 || population[index].dir.x == -1.0)) {
    population[index].dir = new PVector(0, -1);
  } else if (output == 2 && (population[index].dir.y == 1.0 || population[index].dir.y == -1.0)) {
    population[index].dir = new PVector(-1, 0);
  } else if (output == 1 && (population[index].dir.x == 1.0 || population[index].dir.x == -1.0)) {
    population[index].dir = new PVector(0, 1);
  } else if (output == 3 && (population[index].dir.y == 1.0 || population[index].dir.y == -1.0)) {
    population[index].dir = new PVector(1, 0);
  }
}

float[] getInputs(Snake snake) {
  float[] inputs = new float[numInput];
  
  for (int i = 0; i < numInput; i++) {
    inputs[i] = 0;
  }
  
  if (snake.dir.y == -1) {
    inputs[0] = 1;
  } else if (snake.dir.y == 1) {
    inputs[1] = 1;
  } else if (snake.dir.x == -1) {
    inputs[2] = 1;
  } else if (snake.dir.x == 1) {
    inputs[3] = 1;
  }
  
  PVector tailDir;
  
  if (snake.elements.size() > 1) {
    tailDir = PVector.sub(snake.elements.get(snake.elements.size()-1), snake.elements.get(snake.elements.size()-2));
  } else {
    tailDir = new PVector(0, 0);
  }
  
  if (tailDir.y == -1) {
    inputs[4] = 1;
  } else if (tailDir.y == 1) {
    inputs[5] = 1;
  } else if (tailDir.x == -1) {
    inputs[6] = 1;
  } else if (tailDir.x == 1) {
    inputs[7] = 1;
  }
  
  PVector head = snake.elements.get(0);
  
  if (food.x == head.x && food.y < head.y) {
    inputs[8] = 1;
  } else if (food.x > head.x && food.y < head.y) {
    PVector wanderer = head.copy();
    
    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
      wanderer.add(new PVector(1, -1));
      if (wanderer.x == food.x && wanderer.y == food.y) {
        inputs[9] = 1;
        break;
      }
    }
    
  } else if (food.x > head.x && food.y == head.y) {
    inputs[10] = 1;
  } else if (food.x > head.x && food.y > head.y) {
    PVector wanderer = head.copy();
    
    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
      wanderer.add(new PVector(1, 1));
      if (wanderer.x == food.x && wanderer.y == food.y) {
        inputs[9] = 1;
        break;
      }
    }
  } else if (food.x == head.x && food.y > head.y) {
    inputs[12] = 1;
  } else if (food.x < head.x && food.y > head.y) {
    PVector wanderer = head.copy();
    
    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
      wanderer.add(new PVector(-1, 1));
      if (wanderer.x == food.x && wanderer.y == food.y) {
        inputs[9] = 1;
        break;
      }
    }
  } else if (food.x < head.x && food.y == head.y) {
    inputs[14] = 1;
  } else if (food.x < head.x && food.y < head.y) {
    PVector wanderer = head.copy();
    
    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
      wanderer.add(new PVector(-1, -1));
      if (wanderer.x == food.x && wanderer.y == food.y) {
        inputs[9] = 1;
        break;
      }
    }
  }
  
  for (PVector e : snake.elements) {
    if (e.x == head.x && e.y < head.y) {
      inputs[16] = 1;
    } else if (e.x == head.x && e.y > head.y) {
      inputs[17] = 1;
    } else if (e.x < head.x && e.y == head.y) {
      inputs[18] = 1;
    } else if (e.x > head.x && e.y == head.y) {
      inputs[19] = 1;
    }
  }
  
  // north
  inputs[20] = map(PVector.dist(new PVector(head.x, 0), head), 0, resolution, 0, 1);  
  
  float len = 0;
  PVector wanderer = head.copy();
  while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
    wanderer.add(new PVector(1, -1));
    len += sqrt(2);
  }
  
  // north-east
  inputs[21] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
  
  //east
  inputs[22] = map(PVector.dist(new PVector(resolution-1, head.y), head), 0, resolution, 0, 1);  
  
  len = 0;
  wanderer = head.copy();
  while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
    wanderer.add(new PVector(1, 1));
    len += sqrt(2);
  }
  
  // south-east
  inputs[23] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);

  
  // south
  inputs[24] = map(PVector.dist(new PVector(head.x, resolution-1), head), 0, resolution, 0, 1);  
  
  len = 0;
  wanderer = head.copy();
  while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
    wanderer.add(new PVector(-1, 1));
    len += sqrt(2);
  }

  // south-west
  inputs[25] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);

  // west
  inputs[26] = map(PVector.dist(new PVector(0, head.y), head), 0, resolution, 0, 1);  
  
  len = 0;
  wanderer = head.copy();
  while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
    wanderer.add(new PVector(-1, -1));
    len += sqrt(2);
  }
  
  // north-west
  inputs[27] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
    
  return inputs;
}
