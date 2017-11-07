import java.util.Iterator;
import java.util.List;
import processing.pdf.*;
import java.util.Calendar;
import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

boolean savePDF = false;

import controlP5.*;
ControlP5 controlP5;
ControlGroup ctrl;
boolean GUI = false;
boolean hideGUI = false;
boolean guiEvent = false;
boolean recording = false;
Slider[] sliders;

float angle;
int count = 500;
int oldCount = 0;
float noise = 10, noiseStrength = 0.01, offset = 0.0f, multiplier = 0.003f;
float overlayAlpha = 100, strokeAlpha = 100, strokeWidth = 1;


WB_Render render;
HE_Mesh mesh, copyOfMesh;
WB_RandomPoint rp;
WB_AABBTree tree;
List<WB_Point> points;

void settings() {
  size(1080, 1080, P3D);
  pixelDensity(displayDensity());
}

void setup() {
  setupGUI();
  background(0);
  render=new WB_Render(this);
  createMesh();
  mesh.smooth();
  tree=new WB_AABBTree(mesh, 4);

  HEM_Noise modifier=new HEM_Noise();
  modifier.setDistance(20);
  copyOfMesh.modify(modifier);
}


void createMesh() {
  HEC_Johnson jc=new HEC_Johnson().setEdge(200).setType(92);
  mesh=new HE_Mesh(jc);
  copyOfMesh=mesh.get();
}



void draw() {
  background(0);
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  offset += multiplier;

  float nOffset = noise(offset) * noiseStrength;
  float nNoise  = noise(noise);


  pushMatrix();
  println(frameRate);
  translate(width/2, height/2);
  strokeWeight(strokeWidth);
  stroke(255, strokeAlpha);


  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);

  angle += 0.2;

  rotateY(angle*1.0f/width*TWO_PI);
  rotateX(angle*1.0f/height*TWO_PI);


  if (oldCount != count){
    rp=new WB_RandomOnSphere().setRadius(320);
    points=new ArrayList<WB_Point>();
    for (int i=0; i<count; i++) {
      points.add(rp.nextPoint().rotateAboutAxisSelf(HALF_PI, 0, 0, 0, 1, 0, 0));
    }
  }
  oldCount = count;


  WB_Coord q;
  for (WB_Point p : points) {
    // render.drawPoint(p, 4);
    pushMatrix();
    translate(p.xf(),p.yf(),p.zf());
    sphere(5);
    sphereDetail((int) nNoise * 4);
    popMatrix();
    q=tree.getClosestPoint(p);
    beginShape(LINES);

    render.vertex(p);
    render.vertex(q);
    endShape(CLOSE);
    p.rotateAboutAxisSelf(nOffset, 0, 0, 0, 0, 1, 0);
  }

  scale(1);
  HEM_Noise modifier=new HEM_Noise();
  copyOfMesh=mesh.get();
  modifier.setDistance(0);
  copyOfMesh.modify(modifier);
  fill(255, overlayAlpha);
  render.drawFaces(copyOfMesh);
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
