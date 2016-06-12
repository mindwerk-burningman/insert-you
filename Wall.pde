class Wall {
  
  Coords c;
  Wall[] w;
  int counter;
  int numWalls = 10;
  float x;
  float y;
  float z;
  int id;
  int aHit;
  float diam;
  int life = 255;
  float ranRot;
  int wSize = 15;
  float xspeed = random(5);
  float yspeed = random(5);
  float zspeed = random(5);
  float r = random(255);
  float g = random(255);
  float b = random(255);
  PVector realRight = new PVector();
  PVector realLeft = new PVector();
  PVector rHand = new PVector();
  PVector lHand = new PVector();
  
  //constructor
  Wall(float xin, float yin, float zin, float ranRot, int id, Wall[] w, Coords c){
    x = xin;
    y = yin;
    z = zin;
    this.id = id;
    this.ranRot = ranRot;
    this.w = w;
    this.c = c;
  }
  
  void display()
  {
    pushMatrix();
    translate(x, y, z);
    fill(r, g, b);
    rotate(ranRot*frameCount);
    rect(0, 0, 15, wSize);
    popMatrix();
  }
  
  void move()
  {
    x += xspeed;
    y += yspeed;  
    z += zspeed;
    if(aHit == 1 && frameCount % 5 == 0)
      aHit =0;
  }
  
  void collide()
  {
    for(int i = 0; i < numWalls; i++)
    {
      float dx = w[i].x - c.head.x;
      float dy = w[i].y - c.head.y;
      float dz = w[i].z - c.head.z;
      float distance = sqrt(dx*dx + dy*dy + dz*dz);
      float minDist = wSize+wSize;
      if (distance < minDist) 
      { 
        animate();
        //coords.makeSound();
      }
    }
  }
  
  boolean hit()
  {
     if (x > width || x < 1){
      xspeed*= -1;
      aHit = 1;
      return true;
    }

    if (y > height || y < 1){
      yspeed*= -1;
      aHit = 1;
      return true;
    }

    if (z > -50 || z < -1000){
      zspeed*= -1;
      aHit = 1;
      return true;
    }
    else 
      return false;
  }
  
   void ring()
    {
      life --;
       pushMatrix();
       translate(x, y+wSize/2, z);
       noFill();
       stroke(r, g, b, life);
       ellipse(0, 0, diam, diam);
       popMatrix();    
    }
  
 void grow() 
 {
    diam += 2.5;
      if (diam > width*2.5) 
      {
        diam = 0.0;
      }
  }
  
  void animate()
  {
    ring();
    if(diam < width*2.5){
      grow();
    }
  }
}

  
