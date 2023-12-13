class Snake {
  ArrayList<PVector> elements;
  PVector dir;
  int score;
  int lifeSpan;
  Brain brain;
  int timeSinceLastFood;
  float fitness;
  
  Snake(Brain brain) {
    this.brain = brain;
    elements = new ArrayList<PVector>();
    elements.add(new PVector(resolution/2, resolution/2));
    dir = new PVector(1, 0);
    score = 0;
    lifeSpan = 0;
  }
  
  void display() {
    for (PVector e : elements) {
      square(e.x * (width/resolution), e.y * (height/resolution), width/resolution);
    }
  }
  
  boolean update() {
    if (timeSinceLastFood > 500) {
      return false; 
    }
      
    PVector newSquare = PVector.add(elements.get(0), dir);
    
    if (newSquare.x < 0 || newSquare.x >= resolution || newSquare.y < 0 || newSquare.y >= resolution) {
      return false;
    }
    
    for (PVector e : elements) {
      if (newSquare.x == e.x && newSquare.y == e.y) {
        return false;
      }
    }
    
    elements.add(0, newSquare);
    elements.remove(elements.size()-1);
    lifeSpan++;
    timeSinceLastFood++;
    return true;
  }
  
  void increaseLength() {
    PVector newSquare = PVector.add(elements.get(0), dir);
    timeSinceLastFood = 0;
    elements.add(0, newSquare);
  }
}
