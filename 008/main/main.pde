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
float noise = 0, noiseStrength = 0.01, offset = 0.0f, multiplier = 0.03f;
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
  float nNoise = map(sin(offset),-1,1,0,300);
  // noise  += 0.005;

  float nOffset = noise(offset) * noiseStrength;

  pushMatrix();
  println(frameRate);
  strokeWeight(strokeWidth);
  stroke(255, strokeAlpha);
  fill(255, overlayAlpha);

  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);

  translate(width / 2, height / 2);
  pushMatrix();
  beginShape(QUADS);
  for (int n = 1; n < count; n++) {
    float ease = -0.5*(sin(offset * PI) - 1);
    float phase = 0 + 2*PI*ease + PI + radians(map(nOffset%count, 0, count, 0, 360));
    float x = map(n, 0, 360, -count, count);
    float y = count * sqrt(1 - pow(x/count, 2)) * sin(radians(n) + phase);
    vertex(x,0,nNoise);
    vertex(x,y,0);
    vertex(x,y,-nNoise);
    vertex(0,y,nNoise);
  }
  endShape(CLOSE);
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
