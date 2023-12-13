ArrayList<boolean[]> arr;
int blocksPerLine;
float p;

void setup() {
  size(1000, 1000);
  p = 1;
  blocksPerLine = 100;
  arr = new ArrayList<boolean[]>();
  for (int i = 0; i < blocksPerLine; i++) {
    arr.add(new boolean[blocksPerLine]);
  }
  
  frameRate(8);
  
  for (int i = 0; i < blocksPerLine; i++) {
    if (noise(i) < 0.2) {
      arr.get(0)[i] = true;
    }
  }
}

void draw() {
  background(255);
  
  arr.add(0, new boolean[blocksPerLine]);
  
  for (int i = 1; i < blocksPerLine-1; i++) {
    int counter = 0;
    if (arr.get(1)[i-1]) {
      //counter++;
    }
    
    //if (arr[i]) {
    //  counter++;
    //}
    
    if (arr.get(1)[i+1]) {
      //counter++;
    }
    
    if (counter == 1) {
      //arr.get(0)[i] = true;
    } else {
      //arr.get(0)[i] = false;
    }
    
    arr.get(0)[i] = alive(arr.get(1)[i-1], arr.get(1)[i], arr.get(1)[i+1]);
  }
  
  for (int j = 0; j < blocksPerLine; j++) {
    for (int i = 0; i < blocksPerLine; i++) {
      fill(arr.get(j)[i] ? 0 : 255);
      stroke(arr.get(j)[i] ? 0 : 255);
      square(i*(width/blocksPerLine), j*(width/blocksPerLine), width/blocksPerLine);
    }
  }
  
  if (arr.size() > blocksPerLine) {
    arr.remove(blocksPerLine);
  }
}

boolean alive(boolean c1, boolean c2, boolean c3) {
  return random(1) < p ? (c1 && c2 && c3) || (c1 && c2 && !c3) || (!c1 && !c2 && c3) || (!c1 && !c2 && !c3) 
    : false ;
}

void keyPressed() {  
  if (key == 'w' && p < 1) {
    p += 0.01;
  } else if (key == 's' && p > 0) {
    p -= 0.01;
  }
  
  println(p);
}
