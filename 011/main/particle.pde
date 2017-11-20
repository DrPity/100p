class Particle {
  PVector loc, vel, vectorCircle;
  float life, lifeRate;
  IntList connected;

  //Here starts chaos. A lot of chaos. Needs refact.
  Particle() {
    // loc = new PVector(random(-1, 1), random(-1, 1), random(0,100));
    life = random(1.75, 5.25);
    lifeRate = random(0.01, 0.02);
    vel = new PVector(random(-1, 1), random(-1, 1));
    connected = new IntList();

    vectorCircle = new PVector(random(-1, 1), random(-1, 1));
    vectorCircle.limit(1);
    vectorCircle.mult(circleRadius);
    loc = new PVector(width / 2, height / 2).add(vectorCircle);

  }

  void update(float noise) {
    life -= lifeRate;
    vel.add(new PVector(0, gravity));

    PVector dampening = vel.copy().mult(-1);
    dampening.limit(1);
    dampening.mult(dampeningForce);
    vel.add(dampening);
    loc.add(vel);
    loc.add(vel);

    PVector center = new PVector(width / 2, height / 2);
    float distToCenter = loc.dist(center);

    if (distToCenter > circleRadius) {
        PVector vecToCenter = center.copy().sub(loc).normalize();
        vel.mult(-1);
        loc = center.copy().add(vecToCenter.mult(-circleRadius));
    }
  }

  void display(float strokeWidth, float overlayAlpha, ArrayList <Particle> particles) {
    fill(255-life*1.5, 100-life*1.5);
    stroke(0,100-life*1.5);
    strokeWeight(strokeWidth-life*1.5);
    pushMatrix();
    translate(loc.x, loc.y, loc.z);
    sphere(5);
    popMatrix();


    if (connected.size() > 1) {
      for (int i = 0; i < connected.size() - 1; i += 2) {
        beginShape(TRIANGLES);
        vertex(loc.x, loc.y, loc.z);
        vertex(particles.get(i).loc.x, particles.get(i).loc.y,particles.get(i).loc.z );
        vertex(particles.get(i+1).loc.x, particles.get(i+1).loc.y, particles.get(i).loc.z);
        endShape(CLOSE);
      }
    }
  }

  void connectNearestParticles(ArrayList <Particle> particles,Particle ownP) {
    int idx = 0;
    for (Particle p : particles) {
      idx++;
      if(p != ownP){
        float dist = loc.dist(ownP.loc);
        boolean allreadyConnected = false;
        for (int j = 0; j < connected.size(); j++){
          if (ownP == particles.get(j)) {
            if (dist > distThreshold) {
              connected.remove(j);
              println("In remove");
            }
            allreadyConnected = true;
          }
        }
        if (!allreadyConnected) {
          if (dist < distThreshold) {
            connected.append(idx);
          }
        }
      }
    }
  }
}
