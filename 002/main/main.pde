import processing.pdf.*;
import java.util.Calendar;

boolean savePDF = false;

import controlP5.*;
ControlP5 controlP5;
ControlGroup ctrl;
boolean GUI = false;
boolean hideGUI = false;
boolean guiEvent = false;
boolean recording = false;
Slider[] sliders;


int count = 100;
float noise = 10, noiseStrength = 1, offset = 0.0f, multiplier = 0.003f;
float overlayAlpha = 100, strokeAlpha = 100, strokeWidth = 2;

void settings() {
  size(1080, 1080, P3D);
  pixelDensity(displayDensity());
}


void setup() {
  setupGUI();
  background(0);
}


void draw() {
  background(0);
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  offset += multiplier;

  float nOffset = noise(offset) * noiseStrength;
  float nNoise  = noise(noise) * noiseStrength;


  println(nOffset);
  float points = count;
  float pointAngle = 360/points;
  int radius = width;


  pushMatrix();
  for(float angle = 0; angle < 360; angle = angle+pointAngle) {
    float x = cos(radians(angle*offset)) * radius *nOffset;
    float y = sin(radians(angle*offset)) * radius *nOffset;

    strokeWeight(strokeWidth);
    fill(255, overlayAlpha);
    stroke(255,lerp(nOffset, offset ,angle));

    ellipse(x+540,y+540,10*nOffset,10*nOffset);
    line(x+540, y+540, 0+540, 0+540);
  }
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
