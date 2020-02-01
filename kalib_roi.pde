float WIDTH = 480;
float  HEIGHT = 800;

float x,y,z;

void settings() {
  size(240,400,P3D);
}

void setup() {
  noCursor(); 
  frameRate(60);
}

void draw(){
  translate(width/2,height/2,0);
  scale(width/HEIGHT,width/WIDTH);
  rectMode(CENTER);
  rect(0,0,100,100);
}
  
