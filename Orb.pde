class Orb{
  float x, y, z;
  float rotX = random(100)/1000;
  float rotY = random(100)/1000;
  int r = int(random(255));
  int g = int(random(255));
  int b = int(random(255));
  
  Orb(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  void display()
  {
    for(int i = 0; i < 10 ; i++);
    {
      pushMatrix();
      translate(x, y + 150, z - 500);
      noStroke();
      rotateX(rotX*frameCount);
      rotateY(rotY*frameCount);
      fill(r, g, b);
      box(125);
      popMatrix();
    }
  }
}
  
