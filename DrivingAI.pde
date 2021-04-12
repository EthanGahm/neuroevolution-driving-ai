Individual player;
ArrayList<Wall> walls;
ArrayList<Individual> population;
ArrayList<Checkpoint> checkpoints;
int populationSize = 50;
int numDead = 0;
int generation = 1;

void setup() {
  size(1280, 720);
  firstGeneration();
  generateWalls();
  generateCheckpoints();
}

void draw(){
  background(255);
  textSize(24);
  fill(0);
  text("Generation: " + generation, 20, 20);
  for (Individual i : population) {
    if (i.alive) {
      i.move();
    }
    i.display();
  }
  for (Wall wall : walls){
    wall.display();
  }
  if (numDead == population.size()){
    nextGeneration();
  }
}

void firstGeneration(){
  // Generates starting population
  population = new ArrayList<Individual>();
  
  for (int i = 0; i < populationSize; i++){
    population.add(new Individual(80, 600, new DNA()));
  }
}

void generateWalls(){
  walls = new ArrayList<Wall>();
  
  // Draw outer walls
  walls.add(new Wall(50, 650, 500, 670));
  walls.add(new Wall(500, 670, 1200, 630));
  walls.add(new Wall(1200, 630, 1250, 350));
  walls.add(new Wall(1250, 350, 950, 250));
  walls.add(new Wall(950, 250, 1000, 70));
  walls.add(new Wall(1000, 70, 500, 30));
  walls.add(new Wall(500, 30, 50, 40));
  walls.add(new Wall(50, 40, 80, 400));
  walls.add(new Wall(80, 400, 50, 650));
  
  // Draw inner walls
  walls.add(new Wall(150, 550, 510, 570));
  walls.add(new Wall(510, 570, 1050, 530));
  walls.add(new Wall(1050, 530, 1050, 450));
  walls.add(new Wall(1050, 450, 840, 270));
  walls.add(new Wall(840, 270, 840, 160));
  walls.add(new Wall(840, 160, 140, 120));
  walls.add(new Wall(140, 120, 250, 450));
  walls.add(new Wall(250, 450, 150, 550));
  
  walls.add(new Wall(150, 550, 50, 550));
}

void generateCheckpoints(){
  checkpoints = new ArrayList<Checkpoint>();
  
  checkpoints.add(new Checkpoint(200, 500, 200, 700, 1));
  checkpoints.add(new Checkpoint(400, 500, 400, 700, 2));
  checkpoints.add(new Checkpoint(600, 500, 600, 700, 3));
  checkpoints.add(new Checkpoint(800, 500, 800, 700, 5));
  checkpoints.add(new Checkpoint(1000, 500, 1000, 700, 8));
  checkpoints.add(new Checkpoint(1020, 500, 1250, 500, 13));
  checkpoints.add(new Checkpoint(1000, 450, 1120, 280, 21));
  checkpoints.add(new Checkpoint(830, 280, 990, 240, 34));
  checkpoints.add(new Checkpoint(800, 180, 1010, 50, 55));
  checkpoints.add(new Checkpoint(700, 200, 700, 5, 89));
  checkpoints.add(new Checkpoint(500, 200, 500, 5, 144));
  checkpoints.add(new Checkpoint(300, 200, 300, 5, 233));
  checkpoints.add(new Checkpoint(160, 140, 30, 30, 377));
  checkpoints.add(new Checkpoint(200, 200, 30, 200, 610));
  checkpoints.add(new Checkpoint(250, 400, 40, 400, 987));
}

void nextGeneration(){
  ArrayList<Integer> genePool = new ArrayList<Integer>();
  ArrayList<Individual> newPopulation = new ArrayList<Individual>();
  for (Individual individual : population){
    for (int i = 0; i < individual.fitness; i++){
      genePool.add(population.indexOf(individual));
    }
  }
  for (int i = 0; i < populationSize; i++){
    int parent1Num = genePool.get((int) random(genePool.size()));
    Individual parent1 = population.get(parent1Num);
    DNA parent1DNA = parent1.dna;
    int parent2Num = genePool.get((int) random(genePool.size()));
    Individual parent2 = population.get(parent2Num);
    DNA parent2DNA = parent2.dna;
    DNA newDNA = parent1DNA.reproduce(parent2DNA);
    Individual newIndividual = new Individual(80, 600, newDNA);
    newPopulation.add(newIndividual);
  }
  population = newPopulation;
  numDead = 0;
  generation++;
}
