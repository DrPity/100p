class Circle{
  float x,y,z;
  float radius=width/2;
  int numPoints=100;
  float angle;
  float rndOff;
  Point points;

  Circle(int numPoints){
    angle=TWO_PI/(float)numPoints;
    radius = numPoints;
    println(angle);
  }

  float getAngle(){
    return angle;
  }

  float getRadius(){
    return radius;
  }


  ArrayList update(float off){
    ArrayList <Point> points = new ArrayList <Point> ();
    for(int i=0;i<numPoints;i++)
    {
      points.add(new Point(radius*sin(angle*i),radius*cos(angle*i),off));
    }
    return points;
  }

  void display(float off) {
    beginShape(LINES);
    rndOff += 0.001;
    for(int i=0;i<numPoints;i++)
    {
      x = radius*sin(angle*i)*rndOff;
      y = radius*cos(angle*i)*rndOff;
      z = off;
      vertex(x,y,z);

      // point(x,y,z);
    }
    endShape(CLOSE);
  }
}


class Point{
  float x,y,z;
  Point(float x,float y, float z){
    this.x=x;
    this.y=y;
    this.z=z;
  }
}
