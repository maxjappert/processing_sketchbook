int resolution;
PVector food;
int numInput = 8;
int numHidden = 25;
int numOutput = 4;
boolean everyoneDead;
Snake[] population;
int populationSize = 2000;
int numSelected = 20;
int populationIterator;
int generation;
int framerate;
float mutationProb = 0.1;
float mutationDeg = 0.5;


void setup() {
  size(1000, 1000);
  resolution = 6;
  populationIterator = 0;
  generation = 0;
  framerate = 2048;
  
  population = new Snake[populationSize];
  for (int i = 0; i < populationSize; i++) {
    population[i] = new Snake(new SimpleBrain(numInput, numHidden, numOutput));
  }
  
  food = getNewFood(population[0]);
}

void draw() {
  frameRate(framerate);
  
  if (populationIterator < populationSize) {
    background(255);
    
    if (population[populationIterator].lifeSpan == 0) {
        food = getNewFood(population[populationIterator]);
    }
    
    if (population[populationIterator].elements.get(0).x == food.x && population[populationIterator].elements.get(0).y == food.y) {
      population[populationIterator].score++;
      population[populationIterator].increaseLength();
      food = getNewFood(population[populationIterator]);
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
      Snake s1 = new Snake(new SimpleBrain(0, 0, 0));
      Snake s2 = new Snake(new SimpleBrain(0, 0, 0));
      
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

float fitness(Snake snake) {
  return snake.score;
}

Snake crossover(Snake b1, Snake b2) {
  int totalWeights = b1.brain.hiddenWeights.length * b1.brain.hiddenWeights[0].length
    + b1.brain.outputWeights.length * b1.brain.outputWeights[0].length;
  
  int crossoverPoint = floor(random((float)totalWeights));
  
  int counter = 0;
  SimpleBrain brain = new SimpleBrain(numInput, numHidden, numOutput);
  
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
  
  return new Snake(brain);
}

void newGame(Snake snake) {
  food = getNewFood(snake);
}

PVector getNewFood(Snake snake) {
  PVector f = new PVector(floor(random(resolution)), floor(random(resolution)));

  for (PVector e : snake.elements) {
    if (f.x == e.x && f.y == e.y) {
      getNewFood(snake);
    } 
  }
  
  return f;
}

void keyPressed() {
  
  if (keyCode == UP && framerate < 100000) {
    framerate *= 2;
  }
  
  if (framerate < 2) {
    return;
  }
  
  if (keyCode == DOWN) {
    framerate = floor(framerate/2);
  }
  
  println("Framerate: " + framerate);
}

void processThought(int index, float[] output) {
  
  if (output[0] > output[1] && output[0] > output[2] && output[0] > output[3]) {
    population[index].changeDir(new PVector(1, 0));
  } else if (output[1] > output[0] && output[1] > output[2] && output[1] > output[3]) {
    population[index].changeDir(new PVector(0, -1));
  } else if (output[2] > output[0] && output[2] > output[1] && output[2] > output[3]) {
    population[index].changeDir(new PVector(-1, 0));
  } else if (output[3] > output[0] && output[3] > output[1] && output[3] > output[2]) {
    population[index].changeDir(new PVector(0, 1));
  }
}

//    0: Is there an obstacle to the left of the snake (1 — yes, 0 — no)
//    1: Is there an obstacle in front of the snake (1 — yes, 0 — no)
//    2: Is there an obstacle to the right of the snake (1 — yes, 0 — no)
//    3: Normalized angle between snakes movement direction and direction to an apple (from -1 to 1)
//    4: moving right?
//    5: moving up?
//    6: moving left?
//    7: moving down?
float[] getInputs(Snake snake) {
  float[] inputs = new float[numInput];
  
  PVector leftDir =  snake.dir.copy();
  leftDir.rotate(HALF_PI);
  PVector looking = PVector.add(snake.elements.get(0), leftDir);
  inputs[0] = isObsticle(looking, snake) ? 1 : 0;
  
  looking = PVector.add(snake.elements.get(0), snake.dir);
  inputs[1] = isObsticle(looking, snake) ? 1 : 0;
  
  PVector rightDir = snake.dir.copy();
  rightDir.rotate(-HALF_PI);
  looking = PVector.add(snake.elements.get(0), rightDir);
  inputs[2] = isObsticle(looking, snake) ? 1 : 0;
  
  PVector absFoodDir = PVector.sub(food, snake.elements.get(0));
  float foodAngle = PVector.angleBetween(snake.dir, absFoodDir);
  
  // positive rotation gegen den uhrzeiger, der ohrfeige nach
  if (snake.dir.x == 1 && food.y > snake.elements.get(0).y || snake.dir.x == -1 && food.y < snake.elements.get(0).y
      || snake.dir.y == 1 && food.x < snake.elements.get(0).x || snake.dir.y == -1 && food.x > snake.elements.get(0).x) {
        foodAngle *= -1;
  }
  
  inputs[3] = map(foodAngle, -PI, PI, -1, 1);
  
  if (snake.dir.x == 1) {
    inputs[4] = 1;
  } else if (snake.dir.y == -1) {
    inputs[5] = 1;
  } else if (snake.dir.x == -1) {
    inputs[6] = 1;
  } else if (snake.dir.y == 1) {
    inputs[7] = 1;
  }
  
  return inputs; //<>//
}

boolean isObsticle(PVector loc, Snake snake) {
  if (loc.x < 0 || loc.x >= resolution || loc.y < 0 || loc.y >= resolution) {
    return true;
  }
  
  for (PVector e : snake.elements) {
    if (e.x == loc.x && e.x == loc.y) {
      return true;
    }
  }
  
  return false;
}

//float[] getInputs(Snake snake) {
//  float[] inputs = new float[numInput];
  
//  for (int i = 0; i < numInput; i++) {
//    inputs[i] = 0;
//  }
  
//  if (snake.dir.y == -1) {
//    inputs[0] = 1;
//  } else if (snake.dir.y == 1) {
//    inputs[1] = 1;
//  } else if (snake.dir.x == -1) {
//    inputs[2] = 1;
//  } else if (snake.dir.x == 1) {
//    inputs[3] = 1;
//  }
  
//  PVector tailDir;
  
//  if (snake.elements.size() > 1) {
//    tailDir = PVector.sub(snake.elements.get(snake.elements.size()-1), snake.elements.get(snake.elements.size()-2));
//  } else {
//    tailDir = new PVector(0, 0);
//  }
  
//  if (tailDir.y == -1) {
//    inputs[4] = 1;
//  } else if (tailDir.y == 1) {
//    inputs[5] = 1;
//  } else if (tailDir.x == -1) {
//    inputs[6] = 1;
//  } else if (tailDir.x == 1) {
//    inputs[7] = 1;
//  }
  
//  PVector head = snake.elements.get(0);
  
//  // looking up
//  if (inputs[0] == 1) {
//    if (food.x == head.x && food.y < head.y) {
//      inputs[8] = 1;
//    } else if (food.x > head.x && food.y < head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(1, -1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[9] = 1;
//          break;
//        }
//      }
      
//    } else if (food.x > head.x && food.y == head.y) {
//      inputs[10] = 1;
//    } else if (food.x > head.x && food.y > head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(1, 1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[9] = 1;
//          break;
//        }
//      }
//    } else if (food.x == head.x && food.y > head.y) {
//      inputs[12] = 1;
//    } else if (food.x < head.x && food.y > head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(-1, 1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[9] = 1;
//          break;
//        }
//      }
//    } else if (food.x < head.x && food.y == head.y) {
//      inputs[14] = 1;
//    } else if (food.x < head.x && food.y < head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(-1, -1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[9] = 1;
//          break;
//        }
//      }
//    }
    
//    for (PVector e : snake.elements) {
//      if (e.x == head.x && e.y < head.y) {
//        inputs[16] = 1;
//      } else if (e.x == head.x && e.y > head.y) {
//        inputs[17] = 1;
//      } else if (e.x < head.x && e.y == head.y) {
//        inputs[18] = 1;
//      } else if (e.x > head.x && e.y == head.y) {
//        inputs[19] = 1;
//      }
//    }
    
//    // north
//    inputs[20] = map(PVector.dist(new PVector(head.x, 0), head), 0, resolution-1, 0, 1);  
    
//    float len = 0;
//    PVector wanderer = head.copy();
//    wanderer.add(new PVector(1, -1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(1, -1));
//      len += sqrt(2);
//    }
    
//    // north-east
//    inputs[21] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
    
//    //east
//    inputs[22] = map(PVector.dist(new PVector(resolution-1, head.y), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(1, 1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(1, 1));
//      len += sqrt(2);
//    }
    
//    // south-east
//    inputs[23] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
  
    
//    // south
//    inputs[24] = map(PVector.dist(new PVector(head.x, resolution-1), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(-1, 1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(-1, 1));
//      len += sqrt(2);
//    }
  
//    // south-west
//    inputs[25] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
  
//    // west
//    inputs[26] = map(PVector.dist(new PVector(0, head.y), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(-1, -1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(-1, -1));
//      len += sqrt(2);
//    }
    
//    // north-west
//    inputs[27] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
    
//    // looking down
//  } else if (inputs[1] == 1) {
//    if (food.x == head.x && food.y < head.y) {
//      inputs[12] = 1;
//    } else if (food.x > head.x && food.y < head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(1, -1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[13] = 1;
//          break;
//        }
//      }
      
//    } else if (food.x > head.x && food.y == head.y) {
//      inputs[14] = 1;
//    } else if (food.x > head.x && food.y > head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(1, 1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[15] = 1;
//          break;
//        }
//      }
//    } else if (food.x == head.x && food.y > head.y) {
//      inputs[8] = 1;
//    } else if (food.x < head.x && food.y > head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(-1, 1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[9] = 1;
//          break;
//        }
//      }
//    } else if (food.x < head.x && food.y == head.y) {
//      inputs[10] = 1;
//    } else if (food.x < head.x && food.y < head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(-1, -1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[11] = 1;
//          break;
//        }
//      }
//    }
    
//    for (PVector e : snake.elements) {
//      if (e.x == head.x && e.y < head.y) {
//        inputs[18] = 1;
//      } else if (e.x == head.x && e.y > head.y) {
//        inputs[16] = 1;
//      } else if (e.x < head.x && e.y == head.y) {
//        inputs[17] = 1;
//      } else if (e.x > head.x && e.y == head.y) {
//        inputs[19] = 1;
//      }
//    }
    
//    // north
//    inputs[24] = map(PVector.dist(new PVector(head.x, 0), head), 0, resolution-1, 0, 1);  
    
//    float len = 0;
//    PVector wanderer = head.copy();
//    wanderer.add(new PVector(1, -1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(1, -1));
//      len += sqrt(2);
//    }
    
//    // north-east
//    inputs[25] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
    
//    //east
//    inputs[26] = map(PVector.dist(new PVector(resolution-1, head.y), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(1, 1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(1, 1));
//      len += sqrt(2);
//    }
    
//    // south-east
//    inputs[27] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
  
    
//    // south
//    inputs[20] = map(PVector.dist(new PVector(head.x, resolution-1), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(-1, 1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(-1, 1));
//      len += sqrt(2);
//    }
  
//    // south-west
//    inputs[21] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
  
//    // west
//    inputs[22] = map(PVector.dist(new PVector(0, head.y), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(-1, -1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(-1, -1));
//      len += sqrt(2);
//    }
    
//    // north-west
//    inputs[23] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
    
//    // looking left
//  } else if (inputs[2] == 1) {
//    if (food.x == head.x && food.y < head.y) {
//      inputs[10] = 1;
//    } else if (food.x > head.x && food.y < head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(1, -1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[11] = 1;
//          break;
//        }
//      }
      
//    } else if (food.x > head.x && food.y == head.y) {
//      inputs[12] = 1;
//    } else if (food.x > head.x && food.y > head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(1, 1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[13] = 1;
//          break;
//        }
//      }
//    } else if (food.x == head.x && food.y > head.y) {
//      inputs[14] = 1;
//    } else if (food.x < head.x && food.y > head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(-1, 1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[15] = 1;
//          break;
//        }
//      }
//    } else if (food.x < head.x && food.y == head.y) {
//      inputs[8] = 1;
//    } else if (food.x < head.x && food.y < head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(-1, -1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[9] = 1;
//          break;
//        }
//      }
//    }
    
//    for (PVector e : snake.elements) {
//      if (e.x == head.x && e.y < head.y) {
//        inputs[17] = 1;
//      } else if (e.x == head.x && e.y > head.y) {
//        inputs[19] = 1;
//      } else if (e.x < head.x && e.y == head.y) {
//        inputs[16] = 1;
//      } else if (e.x > head.x && e.y == head.y) {
//        inputs[18] = 1;
//      }
//    }
    
//    // north
//    inputs[22] = map(PVector.dist(new PVector(head.x, 0), head), 0, resolution-1, 0, 1);  
    
//    float len = 0;
//    PVector wanderer = head.copy();
//    wanderer.add(new PVector(1, -1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(1, -1));
//      len += sqrt(2);
//    }
    
//    // north-east
//    inputs[23] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
    
//    //east
//    inputs[24] = map(PVector.dist(new PVector(resolution-1, head.y), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(1, 1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(1, 1));
//      len += sqrt(2);
//    }
    
//    // south-east
//    inputs[25] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
  
    
//    // south
//    inputs[26] = map(PVector.dist(new PVector(head.x, resolution-1), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(-1, 1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(-1, 1));
//      len += sqrt(2);
//    }
  
//    // south-west
//    inputs[27] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
  
//    // west
//    inputs[20] = map(PVector.dist(new PVector(0, head.y), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(-1, -1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(-1, -1));
//      len += sqrt(2);
//    }
    
//    // north-west
//    inputs[21] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
  
//    // look right
//  } else if (inputs[3] == 1) {
//    if (food.x == head.x && food.y < head.y) {
//      inputs[14] = 1;
//    } else if (food.x > head.x && food.y < head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(1, -1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[15] = 1;
//          break;
//        }
//      }
      
//    } else if (food.x > head.x && food.y == head.y) {
//      inputs[8] = 1;
//    } else if (food.x > head.x && food.y > head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(1, 1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[9] = 1;
//          break;
//        }
//      }
//    } else if (food.x == head.x && food.y > head.y) {
//      inputs[10] = 1;
//    } else if (food.x < head.x && food.y > head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(-1, 1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[11] = 1;
//          break;
//        }
//      }
//    } else if (food.x < head.x && food.y == head.y) {
//      inputs[12] = 1;
//    } else if (food.x < head.x && food.y < head.y) {
//      PVector wanderer = head.copy();
      
//      while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//        wanderer.add(new PVector(-1, -1));
//        if (wanderer.x == food.x && wanderer.y == food.y) {
//          inputs[13] = 1;
//          break;
//        }
//      }
//    }
    
//    for (PVector e : snake.elements) {
//      if (e.x == head.x && e.y < head.y) {
//        inputs[19] = 1;
//      } else if (e.x == head.x && e.y > head.y) {
//        inputs[17] = 1;
//      } else if (e.x < head.x && e.y == head.y) {
//        inputs[18] = 1;
//      } else if (e.x > head.x && e.y == head.y) {
//        inputs[16] = 1;
//      }
//    }
    
//    // north
//    inputs[26] = map(PVector.dist(new PVector(head.x, 0), head), 0, resolution-1, 0, 1);  
    
//    float len = 0;
//    PVector wanderer = head.copy();
//    wanderer.add(new PVector(1, -1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(1, -1));
//      len += sqrt(2);
//    }
    
//    // north-east
//    inputs[27] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
    
//    //east
//    inputs[20] = map(PVector.dist(new PVector(resolution-1, head.y), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(1, 1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(1, 1));
//      len += sqrt(2);
//    }
    
//    // south-east
//    inputs[21] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
  
    
//    // south
//    inputs[22] = map(PVector.dist(new PVector(head.x, resolution-1), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(-1, 1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(-1, 1));
//      len += sqrt(2);
//    }
  
//    // south-west
//    inputs[23] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
  
//    // west
//    inputs[24] = map(PVector.dist(new PVector(0, head.y), head), 0, resolution-1, 0, 1);  
    
//    len = 0;
//    wanderer = head.copy();
//    wanderer.add(new PVector(-1, -1));
//    while (wanderer.x >= 0 && wanderer.x < resolution && wanderer.y >= 0 && wanderer.y < resolution) {
//      wanderer.add(new PVector(-1, -1));
//      len += sqrt(2);
//    }
    
//    // north-west
//    inputs[25] = map(len, 0, resolution*sqrt(2)-sqrt(2), 0, 1);
//  }
    
//  return inputs; //<>//
//}
