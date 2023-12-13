import java.util.Arrays;

int lifetime = 300;
int populationSize = 100;
float maxForce = 0.5;
int currentIteration;
Rocket[] population;
PVector target = new PVector(750, 0);
Obsticle obsticle1 = new Obsticle(new PVector(300, 1000), new PVector(1200, 1000), new PVector(1200, 1100), new PVector(300, 1100));
Obsticle obsticle2 = new Obsticle(new PVector(300, 500), new PVector(600, 500), new PVector(600, 600), new PVector(300, 600));
Obsticle obsticle3 = new Obsticle(new PVector(1000, 500), new PVector(1300, 500), new PVector(1300, 600), new PVector(1000, 600));

void setup() {
  size(1500, 1500);
  population = new Rocket[populationSize];
  currentIteration = 0;
  frameRate(500);
  
  for (int i = 0; i < population.length; i++) {
    PVector[] genes = new PVector[lifetime];
    for (int j = 0; j < lifetime; j++) {
      genes[j] = PVector.random2D();
      genes[j].mult(random(0, maxForce));
    }
    
    population[i] = new Rocket(genes, new PVector(width/2, height));
  }  
}

void draw() {
  background(255);
  
  circle(target.x, target.y, 40);
  obsticle1.show();
  obsticle2.show();
  obsticle3.show();
  
  currentIteration++;
  fill(0);
  text("current iteration: " + currentIteration, 10, 10);
  
  if (currentIteration < lifetime) {
    PVector leading = population[0].loc;
    for (Rocket r : population) {
      r.run(currentIteration, new Obsticle[]{obsticle1, obsticle2, obsticle3});
      fill(255);
      r.show();
      
      if (PVector.dist(r.loc, target) < 10) {
        println("Done!");
      }
      
      if (PVector.dist(r.loc, target) < PVector.dist(leading, target)) {
        leading = r.loc;
      }
    }
    
    stroke(255, 0, 0);
    //line(leading.x, leading.y, target.x, target.y);
    stroke(0);
  } else {
    currentIteration = 0;
    reproduction();
  }
}

Rocket crossover(Rocket r1, Rocket r2) {
  int crossoverPoint = (int)random(lifetime);
  PVector[] newGenes = new PVector[lifetime];
  float mDeg = 0.05;
  
  for (int i = 0; i < lifetime; i++) {
    if (i < crossoverPoint) {
      newGenes[i] = PVector.mult(r1.genes[i], random(1-mDeg, 1+mDeg));
    } else {
      newGenes[i] = PVector.mult(r2.genes[i], random(1-mDeg, 1+mDeg));
    }
    
    if (random(0, 1) < 0.2) {
      newGenes[i].rotate(random(-QUARTER_PI, QUARTER_PI));
    }
  }
  
  return new Rocket(newGenes, new PVector(width/2, height));
}

float fitness(Rocket r) {
  float d = PVector.dist(r.loc, target);
  return 1.0 / (d*d);
}

void reproduction() {
  Rocket[] newPopulation = new Rocket[populationSize];
  
  population = sortPop(population);
  
  Rocket[] best = new Rocket[10];
  float totalFitness = 0;
  
  for (int i = 0; i < 10; i++) {
    best[i] = population[i];
    totalFitness += fitness(best[i]);
  }
  
  for (int i = 0; i < 100; i++) {
    Rocket rocket1 = new Rocket(new PVector[]{}, new PVector());
    Rocket rocket2 = new Rocket(new PVector[]{}, new PVector());
    float counter = 0;
    float rand = random(0, 1);
    for (Rocket r : best) {
      if (rand <= counter + (fitness(r) / totalFitness)) {
        rocket1 = r;
        break;
      }
      counter += fitness(r) / totalFitness;
    }
    counter = 0;
    rand = random(0, 1);
    for (Rocket r : best) {
      if (rand <= counter + (fitness(r) / totalFitness)) {
        rocket2 = r;
        break;
      }
      counter += fitness(r) / totalFitness;
    }
    newPopulation[i] = crossover(rocket1, rocket2);
  }
  
  this.population = newPopulation;
}

/*Function to sort array using insertion sort*/
Rocket[] sortPop(Rocket[] arr)
{
    int n = arr.length;
    for (int i=1; i<n; ++i)
    {
        Rocket k = arr[i];
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
