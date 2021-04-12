class Individual{
  float[][] corners;
  float x, y, fitness, angle, startingX, startingY = 0;
  final int velocity, len, wid;
  final float maxTurn;
  boolean alive;
  DNA dna;
  
  // Constructor
  Individual(int x, int y, DNA dna){
    this.x = x;
    this.y = y;
    this.startingX = x;
    this.startingY = y;
    this.dna = dna;
    this.velocity = 2;
    this.wid = 20;
    this.len = 30;
    this.maxTurn = 0.02;
    this.alive = true;
    findCorners();
  } 
  
  float[] calcDistances(ArrayList<Wall> walls){
    float[] distances = {2000, 2000, 2000, 2000, 2000};
    float[] lineStart = {cos(angle)*(len/6) + x, sin(angle)*(len/6) + y};
    float[] frontPoint = {cos(angle)*(2000) + lineStart[0], sin(angle)*(2000) + lineStart[1]};
    float[] leftPoint = {sin(angle)*(2000) + lineStart[0], -1 * cos(angle)*(2000) + lineStart[1]};
    float[] rightPoint = {-1 * sin(angle)*(2000) + lineStart[0], cos(angle)*(2000) + lineStart[1]};
    float[] leftFrontPoint = {cos(angle - PI/4) * 2000 + lineStart[0], sin(angle - atan(0.5*wid/(0.5*len))) * 2000 + lineStart[1]};
    float[] rightFrontPoint = {cos(angle + PI/4) * 2000 + lineStart[0], sin(angle + atan(0.5*wid/(0.5*len))) * 2000 + lineStart[1]};
    float[][] linePoints = {frontPoint, leftPoint, rightPoint, leftFrontPoint, rightFrontPoint};
    //stroke(255, 0, 0);
    //line(lineStart[0], lineStart[1], frontPoint[0], frontPoint[1]);
    //line(lineStart[0], lineStart[1], leftPoint[0], leftPoint[1]);
    //line(lineStart[0], lineStart[1],leftFrontPoint[0], leftFrontPoint[1]);
    //line(lineStart[0], lineStart[1], rightPoint[0], rightPoint[1]);
    //line(lineStart[0], lineStart[1], rightFrontPoint[0], rightFrontPoint[1]);
    
    for (Wall wall : walls) {
      for (int i = 0; i < linePoints.length ; i++){
        float x1 = lineStart[0];
        float y1 = lineStart[1];
        float x2 = linePoints[i][0];
        float y2 = linePoints[i][1];
        float x3 = wall.x1;
        float y3 = wall.y1;
        float x4 = wall.x2;
        float y4 = wall.y2;
        float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
          float intersectionX = x1 + (uA * (x2-x1));
          float intersectionY = y1 + (uA * (y2-y1));
          float dist = dist(lineStart[0], lineStart[1], intersectionX, intersectionY);
          if (distances[i] > dist){
            distances[i] = round(dist);
          }
        }
      }
    }
    return distances;
  }
  
  void move(){
    x += (cos(angle) * velocity);
    y += (sin(angle) * velocity);
    findCorners();
    turn(dna.calcOutput(calcDistances(walls)) * maxTurn);
    if (checkCollision(walls)){
      alive = false;
      numDead++;
    }
    checkCheckpointCollision(checkpoints);
  }
  
  void turn(float dist){
    angle += dist;
  }
  
  void display(){
    pushMatrix();
    translate(round(x), round(y));
    rotate(angle);
    stroke(0);
    fill(0);
    rectMode(CENTER);
    rect(0, 0, 30, 20);
    fill(200);
    rect(wid/2, 0, 8, 18);
    rotate(-angle);
    popMatrix();
  }
  
  void findCorners() {
    corners = new float[4][2];
    corners[0][0] = x - cos(angle - atan(0.5*wid/(0.5*len))) * sqrt(pow((0.5 * len), 2) + pow((0.5 * wid), 2));
    corners[0][1] = y - sin(angle - atan(0.5*wid/(0.5*len))) * sqrt(pow((0.5 * len), 2) + pow((0.5 * wid), 2));
    corners[1][0] = x + cos(angle + atan(0.5*wid/(0.5*len))) * sqrt(pow((0.5 * len), 2) + pow((0.5 * wid), 2));
    corners[1][1] = y + sin(angle + atan(0.5*wid/(0.5*len))) * sqrt(pow((0.5 * len), 2) + pow((0.5 * wid), 2));
    corners[2][0] = x + cos(angle - atan(0.5*wid/(0.5*len))) * sqrt(pow((0.5 * len), 2) + pow((0.5 * wid), 2));
    corners[2][1] = y + sin(angle - atan(0.5*wid/(0.5*len))) * sqrt(pow((0.5 * len), 2) + pow((0.5 * wid), 2));
    corners[3][0] = x - cos(angle + atan(0.5*wid/(0.5*len))) * sqrt(pow((0.5 * len), 2) + pow((0.5 * wid), 2));
    corners[3][1] = y - sin(angle + atan(0.5*wid/(0.5*len))) * sqrt(pow((0.5 * len), 2) + pow((0.5 * wid), 2));
  }
  
  boolean checkCollision(ArrayList<Wall> walls){
    for (Wall wall : walls){
      for (int i = 0; i < 3; i++){
        float x1 = corners[i][0];
        float y1 = corners[i][1];
        float x2 = corners[i+1][0];
        float y2 = corners[i+1][1];
        float x3 = wall.x1;
        float y3 = wall.y1;
        float x4 = wall.x2;
        float y4 = wall.y2;
        
        float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
          return true;
        }
      }
    }
    return false;
  }
  
  void checkCheckpointCollision(ArrayList<Checkpoint> checkpoints){
    for (Checkpoint checkpoint : checkpoints){
      for (int i = 0; i < 3; i++){
        float x1 = corners[i][0];
        float y1 = corners[i][1];
        float x2 = corners[i+1][0];
        float y2 = corners[i+1][1];
        float x3 = checkpoint.x1;
        float y3 = checkpoint.y1;
        float x4 = checkpoint.x2;
        float y4 = checkpoint.y2;
        
        float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
          fitness = checkpoint.value;
        }
      }
    }
  }
}
