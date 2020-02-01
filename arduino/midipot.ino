const int deck1LowPin = A0;
const int deck1MidPin = A1;
const int deck1HighPin = A2;
const int deck2LowPin = A3;
const int deck2MidPin = A4;
const int deck2HighPin = A5;
const int nPots = 3;
const int potPins[nPots] = {A0,A1,A2};
const int btn1 = 13;
const int btn2 = 12;
const int btn3 = 11;
const int nBtns = 3;
const int btnPins[nBtns] = {btn1,btn2,btn3};

byte cc = 1;
byte midiCh = 11;

int btnState[nBtns] = {HIGH};
int btnPrevState[nBtns] = {HIGH};
int potCurrentValue[nPots] = {63};
int potPreviousValue[nPots] = {63};
int potTime[nPots] = {0};
int timer[nPots] = {0};
int potVar = 0;
int lastCCValue[nPots] = {0};
int TIMEOUT = 50;
byte potTreshold = 8;
bool potMoving = true;

//#include <MIDI.h>

//MIDI_CREATE_DEFAULT_INSTANCE();

void setup() {
  // put your setup code here, to run once:
  //MIDI.begin(MIDI_CHANNEL_OMNI);
  for(int i = 0; i < nBtns; i++) {
    pinMode(btnPins[i],INPUT_PULLUP);
  }
  Serial.begin(115200);
  Serial.println("msg:Started serial.");
}

void loop() {
  // put your main code here, to run repeatedly:
  readButtons();
  readPots();
}

void readButtons() {
  for(int i = 0; i < nBtns; i++) {
  btnState[i] = digitalRead(btnPins[i]);
  if (btnState[i] != btnPrevState[i])
  {
        btnPrevState[i] = btnState[i];
        Serial.print("btn:");
        Serial.print(i);
        Serial.print(",");
        Serial.println(btnState[i]);
  }
  }
}

void readPots() {
  for (int i = 0; i < nPots; i++)
  {
    potCurrentValue[i] = analogRead(potPins[i]);
  }
  for (int i = 0; i < nPots; i++)
  {
    potVar = abs(potCurrentValue[i] - potPreviousValue[i]);
    if (potVar >= potTreshold)
    {
      potTime[i] = millis();
    }
    timer[i] = millis() - potTime[i];
    if(timer[i] < TIMEOUT)
    {
      potMoving = true;
    }
    else
    {
      potMoving = false;
    }
    if (potMoving == true) {
      int ccValue = map(potCurrentValue[i],0,1023,0,127);
      if (lastCCValue[i] != ccValue) {
        Serial.print("cc:");
        Serial.print(i);
        Serial.print(",");
        Serial.println(ccValue);
        //MIDI.sendControlChange(cc+i,ccValue,midiCh);
        potPreviousValue[i] = potCurrentValue[i];
        lastCCValue[i] = ccValue;
      }
    }
  }
}
