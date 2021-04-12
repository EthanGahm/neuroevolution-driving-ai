class Checkpoint {
  int x1, y1, x2, y2, value;
  
  // Constructor
  Checkpoint(int x1, int y1, int x2, int y2, int value){
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.value = value;
  }
  
  void display() {
    stroke(0, 255, 0);
    line(x1, y1, x2, y2);
  }
}
