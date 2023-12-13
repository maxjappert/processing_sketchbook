class SimpleBrain {
  int numInputs;
  int numHidden;
  int numOutput;
  float[][] hiddenWeights;
  float[][] outputWeights;
  
  SimpleBrain(int numInputs, int numHidden, int numOutput) {
    this.numInputs = numInputs;
    this.numHidden = numHidden;
    this.numOutput = numOutput;
    
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
    
  float[] feedforward(float[] input) {
    float[][] inputLayer = new float[1][numInputs];
    inputLayer[0] = input;
    float[][] hiddenLayer = product(inputLayer, hiddenWeights);
    hiddenLayer[0] = sigmoid(hiddenLayer[0]);
    float[][] outputLayer = product(hiddenLayer, outputWeights);
    
    float[] output = new float[4];
    
    output[0] = sigmoid(outputLayer[0][0]);
    output[1] = sigmoid(outputLayer[0][1]);
    output[2] = sigmoid(outputLayer[0][2]);
    output[3] = sigmoid(outputLayer[0][3]);
    
    return output;
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
