/* 
 * insertYou - an interactive art installation with the Kinect
 *
 * Final Project by: Aric Allen 
 * 6/22/11
 */

import SimpleOpenNI.*;
import processing.opengl.*;

Coords coords;
SimpleOpenNI context;
ArrayList bList;

//Global Variables

float zoomF = 0.5f;
float initRotX = radians(180); // by default rotate the hole scene 180deg around the x-axis, 
// the data from openni comes upside down
//float        rotY = radians(0);

int numCubes = 75;
float[] x = new float[numCubes + 5];
float[] y = new float[numCubes + 5];
float[] z = new float[numCubes + 5];
float[] rotX = new float[numCubes + 5];
float[] rotY = new float[numCubes + 5];
Cube[] c = new Cube[numCubes + 5];
Cube cHead;
color[][] faceColor = new color[numCubes + 5][6];
int accum = 0;
int counter = 0;

PVector torso = new PVector();

int numWalls = 10;
Wall[] w = new Wall[numWalls];
int wSwitch;

int numOrbs = 10;
int oSwitch = 2;
Orb[] o = new Orb[numOrbs];

/*/~~~~~~~~~~~~~////~~~~~~~~~~~~~~////~~~~~~~~~~~~~/*/

void setup() {
  size(1024, 768, P3D);

  context = new SimpleOpenNI(this);
  bList = new ArrayList();
  coords = new Coords(SimpleOpenNI.NODE_USER, context);

  float wSize = height / 2;

  // disable mirror
  context.setMirror(true);

  // enable depthMap generation 
  context.enableDepth();

  context.enableUser();

  stroke(255, 255, 255);
  smooth();
  perspective(95, float(width) / float(height), 10, 15000);

  for (int i = 0; i < numCubes; i++) {
    float cSize = random(25, 60);
    c[i] = new Cube(cSize, cSize, cSize);
    rotX[i] = random(200, 400);
    rotY[i] = random(200, 400);
    for (int j = 0; j < 6; j++) {
      float rColor = random(50, 250);
      faceColor[i][j] = color(rColor);
    }
  }

  // cube for the head
  int hSize = 200;
  cHead = new Cube(hSize, hSize, hSize);

  for (int i = 0; i < numWalls; i++) {
    float ranX = random(width);
    float ranY = random(height);
    float ranZ = random(-1000, -100);
    float ranRot = random(100) / 1000;
    w[i] = new Wall(ranX, ranY, ranZ, ranRot, i, w, coords);
  }
}

/*/~~~~~~~~~~~~~////~~~~~~~~~~~~~~////~~~~~~~~~~~~~/*/

void draw() {
  // update the cam
  context.update();

  background(0);

  for (int i = 0; i < numWalls; i++) {
    w[i].display();
    w[i].move();
    w[i].collide();
    if (w[i].hit()) {
      wSwitch = i;
    }
  }

  w[wSwitch].animate();

  // set the scene pos
  translate(width / 2, height / 2, 0);
  rotateX(initRotX);
  scale(zoomF);

  // Where all the actual draw() stuff happens
  // draw the skeleton if it's available
  int[] users = context.getUsers();
  for (int i = 0; i < users.length; i++) {
    int userId = users[i];
    if (context.isTrackingSkeleton(userId)) {

    coords.calcCoords();
    drawSkeleton(userId);
    drawHead(userId, SimpleOpenNI.SKEL_HEAD);

    for (int j = bList.size() - 1; j >= 0; j--) {
      Block b = (Block) bList.get(j);
      b.display();
      b.fall();
      b.collideR();
      if (b.fini()) {
        bList.remove(j);
      }
    }

    if (coords.clHand.y > coords.head.y && oSwitch != 1)
      paint(userId);

    for (int k = 0; k < numCubes; k++) {
      pushMatrix();
      translate(x[k], y[k], z[k]);
      rotateX(frameCount * PI / rotX[k]);
      rotateY(frameCount * PI / rotY[k]);
      c[k].create(faceColor[k]);
      popMatrix();
    }

    checkOrb(userId);

    if (oSwitch == 1) {
      for (int v = 0; v < numOrbs; v++) {
        o[v] = new Orb(torso.x, torso.y, torso.z);
        o[v].display();
      }
    }
  } // end of if(tracking)
  }
}

/*/~~~~~~~~~~~~~////~~~~~~~~~~~~~~////~~~~~~~~~~~~~/*/

void paint(int userId) {
  PVector rHand = new PVector();
  PVector lHand = new PVector();
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rHand);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, lHand);
  // 6x a second
  if (frameCount % 3 == 0) {
    int ranAmount = int(random(15));
    for (int i = 0; i < ranAmount; i++) {
      float offSetX = random(150);
      float offSetY = random(150);
      float px = rHand.x + offSetX;
      float py = rHand.y + offSetY;
      bList.add(new Block(px, py, rHand.z, rHand, lHand));
    }
  }
}

/*/~~~~~~~~~~~~~////~~~~~~~~~~~~~~////~~~~~~~~~~~~~/*/

void checkOrb(int userId) {
  PVector rHand = new PVector();
  PVector lKnee = new PVector();
  PVector rKnee = new PVector();
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rHand);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, lKnee);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, rKnee);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, torso);
  float minDist = 125;
  int counter = 0;
  float dx = rHand.x - lKnee.x;
  float dy = rHand.y - lKnee.y;
  float dz = rHand.z - lKnee.z;
  float rdx = rHand.x - rKnee.x;
  float rdy = rHand.y - rKnee.y;
  float rdz = rHand.z - rKnee.z;
  float rDistance = sqrt(rdx * rdx + rdy * rdy + rdz * rdz);
  float lDistance = sqrt(dx * dx + dy * dy + dz * dz);

  // touch left knee with right hand to turn on
  if (lDistance < minDist && frameCount % 5 == 0) {
    if (oSwitch == 2 || oSwitch == 0) {
      oSwitch = 1; // turn on
    }
  }

  // touch right knee with right hand to turn off
  if (rDistance < minDist && frameCount % 5 == 0) {
    if (oSwitch == 1) {
      oSwitch = 0; // turn off
    }
  }
}

/*/~~~~~~~~~~~~~////~~~~~~~~~~~~~~////~~~~~~~~~~~~~/*/

void startCounter() {
  if (frameCount % 30 == 0) {
    counter++;
    println(counter);
  }
  if (counter > 30) counter = 0;
}

/*/~~~~~~~~~~~~~////~~~~~~~~~~~~~~////~~~~~~~~~~~~~/*/
// draw the skeleton with the selected joints
void drawSkeleton(int userId) {
  // to get the 3d joint data
  drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK, 0);

  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER, 1);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW, 2);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND, 3);

  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER, 4);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW, 5);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND, 6);

  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO, 7);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO, 8);

  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP, 9);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE, 10);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT, 11);

  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP, 12);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE, 13);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT, 14);
}

/*/~~~~~~~~~~~~~////~~~~~~~~~~~~~~////~~~~~~~~~~~~~/*/

void drawLimb(int userId, int jointType1, int jointType2, int limbNum) {
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float confidence;
  float x1, y1, z1, x2, y2, z2, a, b, q;

  // draw the joint position
  confidence = context.getJointPositionSkeleton(userId, jointType1, jointPos1);
  confidence = context.getJointPositionSkeleton(userId, jointType2, jointPos2);

  // 5 cubes per limb
  x1 = jointPos1.x;
  y1 = jointPos1.y;
  z1 = jointPos1.z;
  x2 = jointPos2.x;
  y2 = jointPos2.y;
  z2 = jointPos2.z;
  limbNum = limbNum * 5;
  for (int i = 0; i < 5; i++) {
    a = lerp(x1, x2, i / 5.0);
    b = lerp(y1, y2, i / 5.0);
    q = lerp(z1, z2, i / 5.0);
    x[i + limbNum] = a;
    y[i + limbNum] = b;
    z[i + limbNum] = q;
  }

}

/*/~~~~~~~~~~~~~////~~~~~~~~~~~~~~////~~~~~~~~~~~~~/*/

void drawHead(int userId, int jointType) {
  // draw the joint orientation  
  PMatrix3D orientation = new PMatrix3D();
  PVector pos = new PVector();
  context.getJointPositionSkeleton(userId, jointType, pos);
  float confidence = context.getJointOrientationSkeleton(userId, jointType, orientation);

  pushMatrix();
  translate(pos.x, pos.y, pos.z); // move to head position
  rotateY(frameCount * 0.02);
  cHead.create();
  popMatrix();
}

/*/~~~~~~~~~~~~~////~~~~~~~~~~~~~~////~~~~~~~~~~~~~/*/

/**
 * SimpleOpenNI user events
 */
void onNewUser(SimpleOpenNI curContext, int userId) {
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId) {
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId) {
  println("onVisibleUser - userId: " + userId);
}

void onStartCalibration(int userId) {
  println("onStartCalibration - userId: " + userId);
}

/*/~~~~~~~~~~~~~////~~~~~~~~~~~~~~////~~~~~~~~~~~~~/*/

void onEndCalibration(int userId, boolean successfull) {
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);

  if (successfull) {
    println("  User calibrated !!!");
    context.startTrackingSkeleton(userId);

    // uncomment this to save calibration on success
    // context.saveCalibrationDataSkeleton(userId,"myCalibration.skel");
  } else {
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    // context.startPoseDetection("Psi",userId);
  }
}

void onStartPose(String pose, int userId) {
  println("onStartdPose - userId: " + userId + ", pose: " + pose);
  println("stop pose detection");

  //  context.stopPoseDetection(userId); 
  //  context.requestCalibrationSkeleton(userId, true);
}

void onEndPose(String pose, int userId) {
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}

