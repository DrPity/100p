import processing.pdf.*;
import java.util.Calendar;
import java.util.List;
import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh, copymesh;
WB_Render render;

boolean savePDF = false;

import controlP5.*;
ControlP5 controlP5;
ControlGroup ctrl;
boolean GUI = false;
boolean hideGUI = false;
boolean guiEvent = false;
boolean recording = false;
Slider[] sliders;

int count = 10;
float zoom = 0.0f;
float noise = 1, noiseStrength = 0.1, offset = 0.0f, multiplier = 0.5f;
float overlayAlpha = 100, strokeAlpha = 100, strokeWidth = 0;

void settings() {
  size(1080, 1080, P3D);
  pixelDensity(displayDensity());
}

void setup() {
  setupGUI();
  background(0);
  smooth(8);
  createMesh();

  HEM_Noise modifier=new HEM_Noise();
  modifier.setDistance(20);
  copymesh.modify(modifier);
  render=new WB_Render(this);
}


void draw() {
  background(0);
  // distThreshold = noise;
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  offset += multiplier;
  float nOffset = noise(offset) * noiseStrength;

  pushMatrix();
  println(frameRate);
  translate(width/2,height/2);
  strokeWeight(strokeWidth);
  stroke(255, strokeAlpha);
  // directionalLight(255, 255, 255, 1, 1, -1);
  pointLight(255, 255, 255, 35, 40, 36);
  HEM_Noise modifier=new HEM_Noise();
  copymesh=mesh.get();
  modifier.setDistance(nOffset*20);
  copymesh.modify(modifier);

  rotate(offset*1.0f/height*TWO_PI);
  fill(255);
  noStroke();
  render.drawFaces(copymesh);
  stroke(0);
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

  noLights();
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

void createMesh(){
  // HEC_Icosahedron icosahedron = new HEC_Icosahedron().setEdge(200);
  // mesh = new HE_Mesh(icosahedron);
  // HEM_Extrude extrude = new HEM_Extrude().setDistance(20);
  HEC_Cube creator=new HEC_Cube(500,5,5,5);
  mesh=new HE_Mesh(creator);
  copymesh=mesh.get();
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
