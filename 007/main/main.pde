import processing.pdf.*;
import java.util.Calendar;
import java.util.List;

boolean savePDF = false;

import controlP5.*;
ControlP5 controlP5;
ControlGroup ctrl;
boolean GUI = false;
boolean hideGUI = false;
boolean guiEvent = false;
boolean recording = false;
Slider[] sliders;

int count = 1000;
float noise = 10, noiseStrength = 0.01, offset = 0.0f, multiplier = 0.03f;
float overlayAlpha = 100, strokeAlpha = 100, strokeWidth = 2;

List <Oscillator> oscillators;

void settings() {
  size(1080, 1080, P3D);
  pixelDensity(displayDensity());
}

void setup() {
  setupGUI();
  background(0);
  oscillators=new ArrayList<Oscillator>();
  for (int i = 0; i < count; i++) {
   oscillators.add(new Oscillator());
 }
}


void draw() {
  background(0);
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  offset += multiplier;

  float nOffset = noise(offset) * noiseStrength;


  pushMatrix();
  println(frameRate);
  strokeWeight(strokeWidth);
  stroke(255, strokeAlpha);
  fill(255, overlayAlpha);

  int xCount = count;
  int yCount = count;

  directionalLight(255, 255, 255, 1, 1, -1);
  // directionalLight(127, 127, 127, -1, -1, 1);
  // float x = width/2;
  // float y = map(sin(offset),-1,1,0,height);

  pushMatrix();

  translate(width/2, height/2);
  beginShape(QUADS);
  for (Oscillator os : oscillators) {
    os.oscillate();
    float x = os.getX();
    float y = os.getY();
    vertex(0,0,0);
    vertex(x, y, 0);
    vertex(0,0, map(sin(nOffset),-1,1,0,height));
    // ellipse(x, y, 32, 32);
  }
  endShape();
  popMatrix();
  popMatrix();

  // end of pdf recording
  if (savePDF) {
    savePDF = false;
    endRecord();
  }
  if (recording){
    saveFrame("output/"+timestamp()+"_##.png");
  }


  if (!hideGUI) drawGUI();

}


void keyPressed() {
  if (key=='r' || key=='R') recording = !recording;
  if (key=='p' || key=='P') savePDF = true;
  if (key=='h' || key=='H') hideGUI = !hideGUI;
  if (key=='m' || key=='M') {
    GUI = controlP5.getGroup("CTRL").isOpen();
    GUI = !GUI;
    guiEvent = true;
  }
  if (GUI) controlP5.getGroup("CTRL").open();
  else controlP5.getGroup("CTRL").close();

}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
