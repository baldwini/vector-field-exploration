public class Functions{
  float x_min;
  float x_max;
  float y_min;
  float y_max;
  
  public Functions(float x_min, float x_max, float y_min, float y_max){
    this.x_min = x_min;
    this.x_max = x_max;
    this.y_min = y_min;
    this.y_max = y_max;
  }
  
  public PVector getDirection(float x, float y){
    return new PVector((min(sqrt(pow(x, 2) + pow(y, 2)), cos(min(x,sqrt(pow(x, 2) + pow(y, 2)))))-x*sin(y)), y).normalize().mult(10);
    //return new PVector(PI*sin(y), x).normalize().mult(10);
  }
}

public class Particle{
  PVector prevPos;
  PVector pos;
  PVector vel;
  PVector acc;
  float maxSpeed = 4;
  
  public Particle(){
    this.pos = new PVector(random(width), random(height));
    this.prevPos = this.pos.copy();
    this.vel = PVector.random2D();
    this.acc = new PVector(0, 0);
  }
  
  public void addForce(Functions func){
    float x = map(pos.x, 0, width, func.x_min, func.x_max);
    float y = map(pos.y, 0, height, func.y_min, func.y_max);
    this.acc.add(func.getDirection(x, y));
  }
  
  public void update(){
    this.vel.add(this.acc);
    this.vel.limit(maxSpeed);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }
  
  public void reset(){
    this.pos = new PVector(random(width), random(height));
    this.prevPos = this.pos.copy();
    this.vel = PVector.random2D();
    this.acc = new PVector(0, 0);
  }
  
  public void wrapAround(){
   if (pos.x < 0) {reset();}
   if (width < pos.x) {reset();}
   if (pos.y < 0) {reset();}
   if (height < pos.y) {reset();}
   //if (pos.x < 0) {pos.x = width; updatePrevious();}
   //if (width < pos.x) {pos.x = 0; updatePrevious();}
   //if (pos.y < 0) {pos.y = height; updatePrevious();}
   //if (height < pos.y) {pos.y = 0; updatePrevious();}
  }
  
  public void updatePrevious(){
    this.prevPos = this.pos.copy();
  }
  
  public void plot(){
    line(prevPos.x, prevPos.y, pos.x, pos.y);
  }
}

float squareLen = 50;
int numParticles = 10000;
int cols, rows;
Particle[] particles = new Particle[numParticles];
Functions functions = new Functions(-10, 10, -10, 10);

void setup(){
  size(1000, 1000, P2D);
  cols = int(height/squareLen);
  rows = int(width/squareLen);
  
  for (int i = 0; i < particles.length; i++){
    particles[i] = new Particle();
  }
  background(0);
}

void draw(){
  noStroke();
  fill(0, 15);
  rect(0, 0, width, height);
  
  for(int i = 0; i < rows; i++){
    for(int j = 0; j < cols; j++){
      float x = j*squareLen + (squareLen/2);
      float y = i*squareLen + (squareLen/2);
      float map_x = map(x, 0, width, functions.x_min, functions.x_max);
      float map_y = map(y, 0, height, functions.y_min, functions.y_max);
      stroke(255/2);
      line(x, y, x + functions.getDirection(map_x, map_y).x, y + functions.getDirection(map_x, map_y).y);
    }
  }
  for(int i = 0; i < particles.length; i++){
    strokeWeight(1);
    stroke(255, 0, 0);
    particles[i].addForce(functions);
    particles[i].update();
    particles[i].wrapAround();
    particles[i].plot();
    particles[i].updatePrevious();
  }
}
