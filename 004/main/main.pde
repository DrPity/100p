import processing.pdf.*;
import java.util.Calendar;
import wblut.nurbs.*;
import wblut.hemesh.*;
import wblut.core.*;
import wblut.geom.*;
import wblut.processing.*;
import wblut.math.*;

boolean savePDF = false;

import controlP5.*;
ControlP5 controlP5;
ControlGroup ctrl;
boolean GUI = false;
boolean hideGUI = false;
boolean guiEvent = false;
boolean recording = false;
Slider[] sliders;
Bang[] bangs;

float startAngle = 0;
int start;

HE_Mesh mesh;
WB_AABBTree tree;
WB_Render render;
WB_RandomOnSphere rnds;
WB_Ray randomRay;
WB_Vector bias;

int count = 84;
float noise = 10, noiseStrength = 1, offset = 0.0f, multiplier = 0.003f;
float overlayAlpha = 100, strokeAlpha = 100, strokeWidth = 0;

void settings() {
  size(1080, 1080, P3D);
  pixelDensity(displayDensity());
}


void setup() {
  setupGUI();
  background(0);
  render=new WB_Render(this);
  rnds=new WB_RandomOnSphere();
  createMesh();
}


void createMesh() {
  HEC_Beethoven creator=new HEC_Beethoven();
  creator.setScale(5).setZAngle(PI/1);
  mesh=new HE_Mesh(creator);
  mesh.simplify(new HES_TriDec().setGoal(0.5));
  tree=new WB_AABBTree(mesh, 1000);
  bias=rnds.nextVector();
}



void draw() {
  background(0);
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  offset += multiplier;

  float nOffset = noise(offset) * noiseStrength;
  float nNoise  = noise(noise) * noiseStrength;


  println(frameRate);
  strokeWeight(strokeWidth);
  stroke(0, strokeAlpha);
  fill(255, overlayAlpha);

  hint(DISABLE_DEPTH_TEST);
  noLights();

  pushMatrix();
  translate(width/2, height/2);
  scale(1.8*offset);
  render.drawFaces(mesh);
  popMatrix();

  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
  translate(width/2, height/2);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  scale(1.6*offset);
  noStroke();
  render.drawFaces(mesh);
  noFill();
  render.drawEdges(mesh);
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
