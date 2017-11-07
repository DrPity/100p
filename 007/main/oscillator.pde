class Oscillator {

  PVector angle;
  PVector velocity;
  PVector amplitude;

  Oscillator() {
    angle = new PVector();
    velocity = new PVector(random(-0.03, 0.03), random(-0.03, 0.03));
    amplitude = new PVector(random(20,width/2), random(20,height/2));
  }

  void oscillate() {
    angle.add(velocity);
  }

  float getX(){
    float x = sin(angle.x)*amplitude.x;
    return x;
  }

  float getY(){
    float y = sin(angle.y)*amplitude.y;
    return y;
  }
}
