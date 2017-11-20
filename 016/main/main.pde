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
ArrayList <ArrayList<Point>> collection = new ArrayList <ArrayList<Point>> ();
ArrayList <Circle> circles = new ArrayList <Circle> ();

int special;

int count = 100;
float noise = 10, noiseStrength = 0.01, offset = 0.0f, multiplier = 0.1f;
float overlayAlpha = 100, strokeAlpha = 255, strokeWidth = 4;


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


  // println(frameRate);
  strokeWeight(strokeWidth);
  stroke(255, strokeAlpha);
  fill(255, overlayAlpha);

  // directionalLight(255, 255, 255, 1, 1, -1);
  // directionalLight(127, 127, 127, -1, -1, 1);
  pushMatrix();
  translate(width/2,height/2);
  scale(2);
  rotate(offset*1.0f/height*TWO_PI);
  addRemoveCircles();

  int idx = 0;
  // beginShape(TRIANGLES);
  for (Circle c : circles) {
    if (idx == special) {
      stroke(255,255);
    }else{
      stroke(255,65);
    }
    c.display(idx*10);
    idx++;
  }
  special ++;
  if (special > circles.size()){
    special = 0;
  }
  // endShape();

  // beginShape(TRIANGLES);
  // connectPoints();
  // endShape();
  // circle[0].display(0.0f);
  // float off = map(sin(offset),-1,1,20,50);
  // circle[1].display(50);
  // connectPoints();
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


void addRemoveCircles() {
  while (circles.size () > count) {
    circles.clear();
  }
  int idx = 0;
  while (circles.size () < count) {
    // println("new particel");
    circles.add(new Circle(50));
    // collection.add(circles.get(idx).update(10f*idx));
    idx ++;
    // println(circles.get(circles.size()).update());
    // collection.add(points);
  }
}


void connectPoints(){
  for (ArrayList<Point> arr : collection) {
    // beginShape(TRIANGLES);
    for (Point p : arr){
      vertex(p.x,p.y,p.z);
    }
    // endShape();
  }
}


//
// stroke(0);
// beginShape();
// for (Point p : points) {
//   vertex(p.x, p.y);
//   ellipse(p.x,p.y,7,7);
// }
// vertex(points.get(0).x, points.get(0).y);
// endShape();

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
