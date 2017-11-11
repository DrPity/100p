class Mover {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;

  float xoff, yoff;

  float r = 16;

  Mover() {
    location = new PVector(random(0, width), random(0, height));
    velocity = new PVector(0, 0);
    topspeed = 4;
    xoff = 1000;
    yoff = 0;
  }

  void update() {

    PVector goal = new PVector(random(width), random(height));
    PVector dir = PVector.sub(goal, location);
    dir.normalize();
    dir.mult(0.5);
    acceleration = dir;

    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
  }

  void display() {
    float theta = velocity.heading2D();

    pushMatrix();
    translate(location.x, location.y, 200);
    rotate(theta);
    sphere(100);
    popMatrix();
  }

  void checkEdges() {

    if (location.x > width) {
      location.x = 0;
    }
    else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height) {
      location.y = 0;
    }
    else if (location.y < 0) {
      location.y = height;
    }
  }
}
