import processing.pdf.*;
import java.util.Calendar;

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

ArrayList <Particle> particles = new ArrayList <Particle> ();

int count = 100;
float noise = 10, noiseStrength = 1, offset = 0.0f, multiplier = 0.003f;
float overlayAlpha = 100, strokeAlpha = 100, strokeWidth = 10;

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
  float nNoise  = noise(noise) * noiseStrength;

  addRemoveParticles();

  for (Particle p : particles) {
    p.update(nNoise);
    p.display(strokeWidth,overlayAlpha);
  }

  if (savePDF) {
    savePDF = false;
    endRecord();
  }
  if (recording){
    saveFrame("output/"+timestamp()+"_##.png");
  }


  if (!hideGUI) drawGUI();

}


void addRemoveParticles() {
  for (int i=particles.size()-1; i>=0; i--) {
    Particle p = particles.get(i);
    if (p.life <= 0) {
      particles.remove(i);
    }
  }

  while (particles.size () < count) {
    particles.add(new Particle());
  }
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
