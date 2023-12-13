class Brain {
  int numInputs;
  int numHidden1;
  int numHidden2;
  int numOutput;
  float[][] hiddenWeights1;
  float[][] hiddenWeights2;
  float[][] outputWeights;
  
  Brain(int numInputs, int numHidden1, int numHidden2, int numOutput) {
    hiddenWeights1 = new float[numInputs][numHidden1];
    hiddenWeights2 = new float[numHidden1][numHidden2];
    outputWeights = new float[numHidden2][numOutput];
    
    for (int i = 0; i < numInputs; i++) {
      for (int j = 0; j < numHidden1; j++) {
        hiddenWeights1[i][j] = random(-1, 1);
      }
    }
    
    for (int i = 0; i < numHidden1; i++) {
      for (int j = 0; j < numHidden2; j++) {
        hiddenWeights2[i][j] = random(-1, 1);
      }
    }
    
    for (int i = 0; i < numHidden2; i++) {
      for (int j = 0; j < numOutput; j++) {
        outputWeights[i][j] = random(-1, 1);
      }
    }
  }
    
  int feedforward(float[] input) {
    float[][] inputLayer = new float[1][numInputs];
    inputLayer[0] = input;
    float[][] hiddenLayer1 = product(inputLayer, hiddenWeights1);
    hiddenLayer1[0] = sigmoid(hiddenLayer1[0]);    
    float[][] hiddenLayer2 = product(hiddenLayer1, hiddenWeights2);
    hiddenLayer2[0] = sigmoid(hiddenLayer2[0]);
    float[][] outputLayer = product(hiddenLayer2, outputWeights);
    
    int index = 0;
    
    for (int i = 0; i < 4; i++) {
      if (outputLayer[0][i] > outputLayer[0][index]) {
        index = i;
      }
    }
    
    return index;
  }
  
  float sigmoid(float x) {
    return 1.0 / (1 + exp(-x));
  }
  
  float[] sigmoid(float[] xs) {
    for (int i = 0; i < xs.length; i++) {
      xs[i] = sigmoid(xs[i]);
    }
    
    return xs;
  }
}
