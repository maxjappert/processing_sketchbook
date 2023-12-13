class Brain {
  int numInputs = 5;
  int numHidden = 8;
  int numOutput = 1;
  float[][] hiddenWeights;
  float[][] outputWeights;
  
  Brain() {
    hiddenWeights = new float[numInputs][numHidden];
    outputWeights = new float[numHidden][numOutput];
    
    for (int i = 0; i < numInputs; i++) {
      for (int j = 0; j < numHidden; j++) {
        hiddenWeights[i][j] = random(-1, 1);
      }
    }
    
    for (int i = 0; i < numHidden; i++) {
      for (int j = 0; j < numOutput; j++) {
        outputWeights[i][j] = random(-1, 1);
      }
    }
  }
    
  float feedforward(float[] input) {
    float[][] inputLayer = new float[1][numInputs];
    inputLayer[0] = input;
    float[][] hiddenLayer = product(inputLayer, hiddenWeights);
    hiddenLayer[0] = sigmoid(hiddenLayer[0]);
    float[][] outputLayer = product(hiddenLayer, outputWeights);
    return sigmoid(outputLayer[0][0]); //<>//
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
