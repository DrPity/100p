class Particle {
  PVector loc;
  float life, lifeRate;

  Particle() {
    loc = new PVector(random(width), random(height));
    life = random(5.75, 10.25);
    lifeRate = random(0.01, 0.02);
  }

  void update(float noise) {
    PVector vel = PVector.fromAngle(noise + random(TWO_PI));
    loc.add(vel);
    life -= lifeRate;
  }

  void display(float strokeWidth, float overlayAlpha) {
    boolean special = random(1) < 0.001;
    fill(255, overlayAlpha);
    strokeWeight(strokeWidth);
    stroke(255, special ? random(175, 255) : 65);
    point(loc.x, loc.y);
  }

}
