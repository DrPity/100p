class Particle {
  PVector p, pOld;
  float life, lifeRate;
  boolean isOutside = false;

  Particle() {
    p = new PVector(random(width), random(height));
    pOld = new PVector(p.x,p.y);
    life = random(5.75, 10.25);
    lifeRate = random(0.01, 0.02);
  }

  void update() {
    angle = noise(p.x/noiseScale,p.y/noiseScale) * noiseStrength;
    // PVector vel = PVector.fromAngle(angle + random(TWO_PI));
    // p.add(vel);
    p.x += cos(angle) * noise;
    p.y += sin(angle) * noise;

    if(p.x<-10) isOutside = true;
    else if(p.x>width+10) isOutside = true;
    else if(p.y<-10) isOutside = true;
    else if(p.y>height+10) isOutside = true;

    if (isOutside) {
      p.x = random(width);
      p.y = random(height);
      pOld.set(p);
      isOutside = false;
    }
    life -= lifeRate;
  }

  void display() {
    // stroke(255, special ? random(175, 255) : 65);
    // ellipse(p.x, p.y, 10, 10);
    strokeWeight(strokeWidth);
    stroke(255, strokeAlpha);
    fill(255, overlayAlpha);
    // ellipse(p.x, p.y, 10, 10);
    beginShape(LINES);
    vertex(p.x, p.y);
    vertex(pOld.x, pOld.y);
    endShape(CLOSE);
    // line(pOld.x,pOld.y, p.x,p.y);
    pOld.set(p);
  }

}
