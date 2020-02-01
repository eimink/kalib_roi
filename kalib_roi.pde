import processing.serial.*;

Serial myPort;


float WIDTH = 480;
float  HEIGHT = 800;

int pot[] = {64,64,64};
int btn[] = {1,1,1};
int prevBtn[] = {1,1,1};
int currentScreen = 99;
int idxScreen = 99;
int prevScreen = 99;
int targetScreen = 0;
int prevTarget = 0;
long start = millis();
long timer = millis();


String[] screens = {"BORI KALI","KALIB ROI","BIL KORI A","IKI LABRO", "ORB ALIKI", "LAIKI BRO"};
String[] targets = {"30 90 120","000","012074127","12*4 12+30 128-64","0x0A 0x20 0x66", "42375709*3"};
int[][] answers = {{30,90,120},{0,0,0},{12,74,127},{48,42,64},{0x0A,0x20,0x66},{127,127,127}};
boolean screenCompleted[] = {false,false,false,false,false,false};
boolean firstRun = true;

PFont font;
PShader shader;

void settings() {
  //fullScreen(P3D);
  size(240,400,P3D);
}

void setup() {
  shader = loadShader("shader.glsl");
  shader.set("iResolution",(float)WIDTH,(float)HEIGHT);
  /*shader.set("iMouse",(float)pot[0]/127,(float)pot[1]/127);
  */
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1],115200);
  font = createFont("Orbitron.ttf",48);
  noCursor(); 
  frameRate(60);
}

void readSerial() {
  while(myPort.available() > 0) {
    String inb = myPort.readStringUntil(10);
    if (inb != null) {
    if (inb.substring(0,1).equals("b") || inb.substring(0,1).equals("c"))
    {
      String[] l = split(inb,":");
      print(l[0]);
      if (l.length > 1){
        print(l[1]);
      String[] p = split(l[1],",");
      if (p.length > 1) {
      if (l[0].equals("cc")) {
        pot[Integer.parseInt(trim(p[0]))] = Integer.parseInt(trim(p[1]));
      }
      else if (l[0].equals("btn")) {
        btn[Integer.parseInt(p[0])] = Integer.parseInt(trim(p[1]));
      }
    }
      }
    }
    }
  }
}

void drawScreen1(String target, String screen) {
  pushMatrix();
  textFont(font);
  textAlign(CENTER,CENTER);
  fill(255,0,0,255);
  text(screen,0,-100);
  fill(0,255,0,255);
  text(target,0,100);
  popMatrix();
}

void drawEndScreen() {
  pushMatrix();
  textFont(font);
  textAlign(CENTER,CENTER);
  fill(0,255,0,255);
  text("KALIB ROI",0,-300);
  if (!firstRun) {
  text("SUORI TETU'D",0,-200);
  text(timer,0,-100);
  }
  fill(0,0,255,255);
  text("ENGAGE",0,200);
  popMatrix();
}

void drawGameScreen(int i, int t1, int t2, int t3) {
  pushMatrix();
  textFont(font);
  textAlign(CENTER,CENTER);
  if (screenCompleted[i] == true || (pot[0] == t1 && pot[1] == t2 && pot[2] == t3)) {
    fill(0,255,0,255);
    if (screenCompleted[i] == false) {
      screenCompleted[i] = true;
      targetScreen++;
    }
    text(screens[i],0,-100);
  text(t1,-100,100);
  text(t2,0,100);
  text(t3,100,100);
  } else {
    fill(255,0,0,255);
    text(screens[i],0,-100);
  text(pot[0],-100,100);
  text(pot[1],0,100);
  text(pot[2],100,100);
  }
  
  popMatrix();
}

void resetGame() {
  for(int i = 0; i < targets.length; i++) {
    screenCompleted[i] = false;
  }
  currentScreen = 1;
  idxScreen = 1;
  prevScreen = 1;
  targetScreen = 0;
  prevTarget = 0;
  firstRun = false;
  start = millis();
  timer = millis();
}

boolean checkWin()
{
  for(int i = 0; i < targets.length; i++) {
    if (screenCompleted[i] == false) return false;
  }
  
  pot[0] = 64;
  pot[1] = 64;
  pot[2] = 64;
  return true;
}

void draw(){
  if (checkWin())
  {
    idxScreen = 99;
    if (prevScreen != 99) timer = (millis() - start)/1000;
    prevScreen = 99;
  }
  readSerial();
  if (btn[0] != prevBtn[0] || btn[2] != prevBtn[2])
  {
    prevBtn[0] = btn[0];
    prevBtn[1] = btn[1];
    prevBtn[2] = btn[2];
    if(btn[0] == 0) idxScreen--;
    if(btn[2] == 0) idxScreen++;
    if (idxScreen > screens.length) idxScreen = 1;
    if (idxScreen < 1) idxScreen = screens.length;
    prevScreen = idxScreen;
  }
  if (currentScreen == 99 && btn[1] == 0)
  {
    resetGame();
  }
  if (btn[1] == 0 && currentScreen != 99) currentScreen = 0;
  else currentScreen = idxScreen;
  background(0,0,0);

  shader(shader);
  shader.set("iGlobalTime",(float)millis()/1000);
  rect(0,0,WIDTH,HEIGHT);
  translate(width/2,height/2,0);
  scale(width/WIDTH,height/HEIGHT,width/WIDTH);
  resetShader();
  noLights();
  hint(DISABLE_DEPTH_TEST);
  switch(currentScreen) {
    case 0:
      drawScreen1(targets[targetScreen],screens[targetScreen]);
      break;
    /*case 1:
      drawGameScreen(0,answers[0][0],answers[0][1],answers[0][2]);
      break;
      case 2:
      drawGameScreen(1,answers[1][0],answers[1][1],answers[1][2]);
      break;
      case 3:
      drawGameScreen(2,answers[2][0],answers[2][1],answers[2][2]);
      break;*/
      case 99:
      drawEndScreen();
      break;
      default:
      drawGameScreen(currentScreen-1,answers[currentScreen-1][0],answers[currentScreen-1][1],answers[currentScreen-1][2]);
      
  }
}
  
