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

ArrayList <Particle> particles = new ArrayList <Particle> ();

float gravity = 0;
float dampeningForce = 0;
float maxDampening = 0.1;
float distThreshold = 100;
float circleRadius = 1080/2;


int count = 10;
float zoom = 0.0f;
float noise = 1, noiseStrength = 0.01, offset = 0.0f, multiplier = 0.03f;
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
  // distThreshold = noise;
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  offset += multiplier;
  gravity = map(sin(offset),-1,1,width,height);
  dampeningForce = map(sin(offset),1,-1,width,height);

  float nOffset = noise(offset) * noiseStrength;

  pushMatrix();
  println(frameRate);
  // strokeWeight(strokeWidth);
  // stroke(255, strokeAlpha);
  directionalLight(255, 255, 255, 1, 1, -1);
  // directionalLight(127, 127, 127, -1, -1, 1);
  pushMatrix();
  noFill();
  stroke(0);
  strokeWeight(2);
  translate(width/2, height/2);
  scale(3);
  // rotate(zoom += 0.002);
  sphere(height/2);
  popMatrix();
  fill(255, overlayAlpha);

  addRemoveParticles();

  for (Particle p : particles) {
    p.update(nOffset);
    p.connectNearestParticles(particles, p);
    p.display(strokeWidth,overlayAlpha, particles);
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

void addRemoveParticles() {
  for (int i=particles.size()-1; i>=0; i--) {
    Particle p = particles.get(i);
    if (p.life <= 0) {
      particles.remove(i);
    }
  }

  if (particles.size () > count){
    particles.clear();
  }
  while (particles.size () < count) {
    particles.add(new Particle());
  }
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
