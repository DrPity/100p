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


int count = 7;
float noise = 10, noiseStrength = 1, offset = 0.0f, multiplier = 0.003f;
float overlayAlpha = 100, strokeAlpha = 100, strokeWidth = 1;



void settings() {
  size(1080, 1080, P3D);
  pixelDensity(displayDensity());
}


void setup() {
  setupGUI();
  background(255);
}


void draw() {
  background(255);
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  offset += multiplier;

  float nOffset = noise(offset) * noiseStrength;
  float nNoise  = noise(noise) * noiseStrength;

  strokeWeight(strokeWidth);

  float tileSizeX = (float)width/count;
  float tileSizeY = (float)height/count;

  for (int meshY=0; meshY < height; meshY += tileSizeY) {
    for (int meshX=0; meshX < width; meshX += tileSizeX) {
      pushMatrix();
      translate(meshX, meshY);
      rotate(offset*radians(90));
      stroke(0,strokeAlpha);
      beginShape();
      vertex(-100, -100, -100);
      vertex( 100, -100, -100);
      vertex(   0,    0,  100);

      vertex( 100, -100, -100);
      vertex( 100,  100, -100);
      vertex(   0,    0,  100);

      vertex( 100, 100, -100);
      vertex(-100, 100, -100);
      vertex(   0,   0,  100);

      vertex(-100,  100, -100);
      vertex(-100, -100, -100);
      vertex(   0,    0,  100);
      endShape();
      popMatrix();
    }
  }

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
