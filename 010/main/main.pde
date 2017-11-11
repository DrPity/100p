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

int count = 360;
float zoom = 0.0f;
float noise = 0, noiseStrength = 0.01, offset = 0.0f, multiplier = 0.03f;
float overlayAlpha = 100, strokeAlpha = 100, strokeWidth = 0;

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
  zoom += 0.01;
  float nNoise = map(sin(offset),-1,1,0,300);
  blendMode(ADD);

  overlayAlpha = map(sin(zoom),-1,1,0,255);
  float nOffset = noise(offset) * noiseStrength;

  pushMatrix();
  println(frameRate);
  strokeWeight(strokeWidth);
  stroke(255, strokeAlpha);
  fill(255, overlayAlpha);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(width / 2, height / 2);
  // scale(offset);
  pushMatrix();
  // beginShape(TRIANGLES);
  branch(1000,0,0,0,offset,nOffset);
  // endShape(CLOSE);
  popMatrix();
  // pushMatrix();
  // branch(200,0,0,0,nOffset);
  // popMatrix();
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

void branch(float len, float oldPointX, float oldPointY, float oldPointZ, float theta, float nOffset) {

  float pointX = random(width/2, width);
  float pointY = random(height/2, height);
  float pointZ = random(0, 200);

  fill(lerp(0,255,pointX), overlayAlpha);
  beginShape(QUADS);
  vertex(0, 0, 0);
  vertex(oldPointX, oldPointY, oldPointZ);
  vertex(pointX, pointY, pointZ);
  vertex(0, 0, 0);
  endShape(CLOSE);
  // ellipse(pointX,pointY, 300*nOffset, 300*nOffset);
  len -= 1;
  // println(len);
  if (len >= 1) {
    rotate(theta);
    branch(len,pointX,pointY,pointZ,theta, nOffset);
  }
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
