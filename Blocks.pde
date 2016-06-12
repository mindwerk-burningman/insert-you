class Block {
  float x, y, z;
  int id;
  int bSize = int(random(40));
  int life = 255;
  int r = int(random(255));
  int g = int(random(255));
  int b = int(random(255));
  float gravity = -1.5;
  PVector rHand = new PVector();
  PVector lHand = new PVector();
  
  
  Block(float tempX, float tempY, float tempZ, PVector rHand, PVector lHand)
  {
    x = tempX;
    y = tempY;
    z = tempZ;
    this.rHand = rHand;
    this.lHand = lHand;
  }
  
  void display()
  {
    pushMatrix();
    noStroke();
    fill(r, g, b, life);
    translate(x, y, z);
    rotateX(random(TWO_PI));
    rotateY(random(TWO_PI));
    box(bSize);
    popMatrix();
  }
  
  boolean fini() {
    life-= .8;
    if (life < 0) {
      return true;
    } else {
      return false;
    }
  }
  
  void fall() {
    y += gravity;
  }
  
  
  void collideR() {
    float dx = rHand.x - x;
    float dy = rHand.y - y;
    float distance = sqrt(dx*dx + dy*dy);
    float minDist = bSize+20;
    if (distance < minDist) { 
      gravity = -gravity*3;
    }  
  }
}