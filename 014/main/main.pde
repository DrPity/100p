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
Point[] points;
int last;

int count = 10;
float noise = 10, noiseStrength = 0.01, offset = 0.0f, multiplier = 0.03f;
float overlayAlpha = 0, strokeAlpha = 255, strokeWidth =6;
float stepSize = 2;
float danceFactor = 1;

void settings() {
  size(1080, 1080, P3D);
  pixelDensity(displayDensity());
}

void setup() {
  setupGUI();
  background(0);
  points=new Point[count];
  for (int i = 0; i < count; i++) {
    points[i] = new Point(random(0,PI*3),random(0,PI*3), random(0,255));
  }
  print(points[1]);
}


void draw() {
  background(0);
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  offset += multiplier;

  float nOffset = noise(offset) * noiseStrength;


  println(frameRate);
  strokeWeight(strokeWidth);
  stroke(255, strokeAlpha);
  fill(255, overlayAlpha);

  // directionalLight(255, 255, 255, 1, 1, -1);
  // directionalLight(127, 127, 127, -1, -1, 1);
  pushMatrix();
  connectPoints();
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

class Point{
  float x,y, myColor;
  Point(float x,float y, float col){
    this.x=x;
    this.y=y;
    myColor=col;
  }
}

void connectPoints(){
  translate(width/2,height/2);
  for (int i = 0; i < points.length; i++ ) {
    points[i].x += random(-stepSize,stepSize)*offset;
    points[i].y += random(-stepSize,stepSize)*offset;
  }
  beginShape();
  curveVertex(points[points.length-1].x,points[points.length-1].y);
  for (int i=0; i<points.length; i++){
    curveVertex(points[i].x, points[i].y);
  }
  curveVertex(points[0].x, points[0].y);
  curveVertex(points[1].x, points[1].y);
  endShape();

  stroke(0);
  beginShape();
  for (int i=0; i<points.length; i++){
    vertex(points[i].x, points[i].y);
    ellipse(points[i].x, points[i].y, 7, 7);
  }
  vertex(points[0].x, points[0].y);
  endShape();
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
