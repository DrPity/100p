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


List <Mover> mover;

int count = 100;
float noise = 10, noiseStrength = 0.01, offset = 0.0f, multiplier = 0.003f;
float overlayAlpha = 100, strokeAlpha = 100, strokeWidth = 0;

void settings() {
  size(1080, 1080, P3D);
  pixelDensity(displayDensity());
}

void setup() {
  setupGUI();
  background(0);
  mover=new ArrayList<Mover>();
  for (int i = 0; i < count; i++) {
   mover.add(new Mover());
 }
}


void draw() {
  background(0);
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  offset += multiplier;

  float nOffset = noise(offset) * noiseStrength;


  pushMatrix();
  println(frameRate);
  // translate(width/2, height/2);
  strokeWeight(strokeWidth);
  stroke(255, strokeAlpha);
  fill(255, overlayAlpha);

  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);

  for (Mover mo : mover) {

    mo.update();
    mo.checkEdges();
    mo.display();
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
