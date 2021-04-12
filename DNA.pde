class DNA{
  float[][] weights1;
  float[] nodeBiases;
  float[] weights2;
  float outputBias;
  float mutationMultMax = 1.3;
  float mutationMultMin = 0.7;
  float mutationChance = 0.01;
  final int numNodes = 4;
  
  // Constructor without specified values. Used to a generate a completely random set of genes.
  DNA() {
    float[][] weights1 = new float[5][4];
    float[] nodeBiases = new float[4];
    float[] weights2 = new float[4];
    
    // weights1
    for (int i = 0; i < weights1.length; i++){
      for (int j = 0; j < weights1[0].length; j++){
        weights1[i][j] = random(-1, 1);
      }
    }
    this.weights1 = weights1;
    
    // nodeBiases
    for (int i = 0; i < nodeBiases.length; i++){
      nodeBiases[i] = random(-1, 1);
    }
    this.nodeBiases = nodeBiases;
      
    // weights2
    for (int i = 0; i < weights2.length; i++){
      weights2[i] = random(-1, 1);
    }
    this.weights2 = weights2;
    
    // outputBias
    this.outputBias = random(-1, 1);
  }
  
  // Constructor with specified values
  DNA(float[][] weights1, float[] nodeBiases, float[] weights2, float outputBias){
      this.weights1 = weights1;
      this.nodeBiases = nodeBiases;
      this.weights2 = weights2;
      this.outputBias = outputBias;
  }
  
  float calcOutput(float[] inputs){
    float[] nodeValues = new float[numNodes];
    for (int node = 0; node < nodeValues.length; node++){
      float theta1 = 0;
      for (int weightSet = 0; weightSet < inputs.length; weightSet++) {
        for (float weight : weights1[weightSet]){
          theta1 += (inputs[weightSet] * weight);
        }
      }
      theta1 += nodeBiases[node];
      nodeValues[node] = 2 * (1 / (1 + exp(-1 * theta1))) - 1;
    }
    // at this point I should have an array of four values representing the four node values
    
    float theta2 = 0;
    for (int i = 0; i < numNodes; i++){ 
      theta2 += weights2[i] * nodeValues[i];
    }
    theta2 += outputBias;
    
    // return value is a decial number between -1 and 1
    return 2 * (1 / (1 + exp(-1 * theta2))) - 1;
  }
  
  DNA reproduce(DNA parent2){
    float[][] weights1 = new float[this.weights1.length][this.weights1[0].length];
    float[] nodeBiases = new float[this.nodeBiases.length];
    float[] weights2 = new float[this.weights2.length];
    float outputBias;
    
    // Determine new weights1
    for (int i = 0; i < this.weights1.length; i++){
      for (int j = 0; j < this.weights1[0].length; j++){
        if (random(-1, 1) > 0) {
          weights1[i][j] = this.weights1[i][j];
        } else {
          weights1[i][j] = parent2.weights1[i][j];
        }
        if (random(1) < mutationChance){
          weights1[i][j] *= random(mutationMultMin, mutationMultMax);
        }
      }
    }
    
    // Determine new nodeBiases
    for (int i = 0; i < this.nodeBiases.length; i++){
      if (random(-1, 1) > 0) {
        nodeBiases[i] = this.nodeBiases[i];
      } else {
        nodeBiases[i] = parent2.nodeBiases[i];
      }
      if (random(1) < mutationChance){
        nodeBiases[i] *= random(mutationMultMin, mutationMultMax);
      }
    }
      
    // Determine new weights2
    for (int i = 0; i < this.weights2.length; i++){
      if (random(-1, 1) > 0) {
        weights2[i] = this.weights2[i];
      } else {
        weights2[i] = parent2.weights2[i];
      }
      if (random(1) < mutationChance){
        weights2[i] *= random(mutationMultMin, mutationMultMax);
      }
    }
    
    // Determine new outputBias
    if (random(-1, 1) > 0) {
      outputBias = this.outputBias;
    } else {
      outputBias = parent2.outputBias;
    }
    if (random(1) < mutationChance){
      outputBias *= random(mutationMultMin, mutationMultMax);
    }
    
    return new DNA(weights1, nodeBiases, weights2, outputBias);
  }
}
