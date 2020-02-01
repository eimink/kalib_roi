import processing.serial.*;

Serial myPort;


float WIDTH = 480;
float  HEIGHT = 800;

int pot[] = {0,0,0};
int btn[] = {1,1,1};

PFont font;

void settings() {
  size(240,400,P3D);
}

void setup() {
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1],115200);
  font = createFont("Orbitron.ttf",48);
  noCursor(); 
  frameRate(60);
}

void readSerial() {
  while(myPort.available() > 0) {
    String inb = myPort.readString();
    if (inb != null) {
      String[] l = split(inb,":");
      print(l[0]);
      if (l.length > 1){
        print(l[1]);
      String[] p = split(l[1],",");
      if (l[0].equals("cc")) {
        pot[Integer.parseInt(p[0])] = Integer.parseInt(p[1]);
      }
      else if (l[0] == "btn") {
        btn[Integer.parseInt(p[0])] = Integer.parseInt(p[1]);
      }
      }
    }
  }
}

void drawText() {
  pushMatrix();
  textFont(font);
  textAlign(CENTER,CENTER);
  fill(255,0,0,255);
  text("KALIB ROI",0,-300);
  text(pot[0],-100,-100);
  text(pot[1],0,-100);
  text(pot[2],100,-100);
  text(btn[0],-100,100);
  text(btn[1],0,100);
  text(btn[2],100,100);
  popMatrix();
}

void draw(){
  readSerial();
  background(0,0,0);
  translate(width/2,height/2,0);
  scale(width/WIDTH,height/HEIGHT,width/WIDTH);
  //rectMode(CENTER);
  //fill(255,255,255,255);
  //rect(0,0,100,100);
  noLights();
  hint(DISABLE_DEPTH_TEST);
  drawText();
}
  
