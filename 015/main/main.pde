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

int count = 1;
float noise = 10, angle = 0 , noiseStrength = 0, offset = 0.0f, multiplier = 0.003f, noiseScale = 300;
float overlayAlpha = 100, strokeAlpha = 255, strokeWidth = 1;


void settings() {
  size(1080, 1080, P3D);
  pixelDensity(displayDensity());
}

void setup() {
  setupGUI();
  background(0);
  // for (int i = 0; i < count; i++) {
  //   particles.add(new Particle());
  // }
}


void draw() {
  background(0);
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  offset += multiplier;
  noiseStrength = map(sin(offset),-1,1,0,100);
  float nOffset = noise(offset) * noiseStrength;


  println(frameRate);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  pushMatrix();

  addRemoveParticles();

  for (Particle p : particles) {
    p.update();
    p.display();
  }
  // rotate(offset*1.0f/height*PI);
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
  while (particles.size () > count) {
    particles.clear();
  }
  while (particles.size () < count) {
    // println("new particel");
    particles.add(new Particle());
  }
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
