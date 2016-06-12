class Coords {

  SimpleOpenNI c;
  
  Coords(int userId, SimpleOpenNI context)
  {
    c = context;
  }
  PVector test = new PVector();
  PVector realWorld = new PVector();
  PVector crHand = new PVector();
  PVector clHand = new PVector();
  PVector rHand = new PVector();
  PVector lHand = new PVector();
  PVector head = new PVector();
  PVector neck = new PVector();
  PVector lShoulder = new PVector();
  PVector rShoulder = new PVector();
  PVector lElbow = new PVector();
  PVector rElbow = new PVector();
  PVector cTorso = new PVector();
  PVector lHip = new PVector();
  PVector rHip = new PVector();
  PVector lKnee = new PVector();
  PVector rKnee = new PVector();
  PVector lFoot = new PVector();
  PVector rFoot = new PVector();
  float rx;
  float ry;
  float rz;
  float lx;
  float ly;
  float lz;
  int counter = 0;
  
  void calcCoords()
  { 
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_HEAD, realWorld);
    c.convertRealWorldToProjective(realWorld, head);
  
    /*
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_NECK, realWorld);
    c.convertRealWorldToProjective(realWorld, neck);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_SHOULDER, realWorld);
    c.convertRealWorldToProjective(realWorld, lShoulder);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_SHOULDER, realWorld);
    c.convertRealWorldToProjective(realWorld, rShoulder);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_ELBOW, realWorld);
    c.convertRealWorldToProjective(realWorld, lElbow);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_ELBOW, realWorld);
    c.convertRealWorldToProjective(realWorld, rElbow);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_TORSO, realWorld);
    c.convertRealWorldToProjective(realWorld, torso);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_HIP, realWorld);
    c.convertRealWorldToProjective(realWorld, lHip);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_HIP, realWorld);
    c.convertRealWorldToProjective(realWorld, rHip);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_KNEE, realWorld);
    c.convertRealWorldToProjective(realWorld, lKnee);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_KNEE, realWorld);
    c.convertRealWorldToProjective(realWorld, rKnee);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_FOOT, realWorld);
    c.convertRealWorldToProjective(realWorld, lFoot);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_FOOT, realWorld);
    c.convertRealWorldToProjective(realWorld, rFoot);
    */
    
    
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_HAND, crHand);
    c.convertRealWorldToProjective(crHand, rHand);
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_TORSO, realWorld);
    c.convertRealWorldToProjective(realWorld, cTorso);
    rx = rHand.x - cTorso.x;
    ry = -rHand.y;
    rz = rHand.z; 
    c.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_HAND, clHand);
    c.convertRealWorldToProjective(clHand, lHand);
    lx = cTorso.x - lHand.x;
    ly = -lHand.y;
    lz = lHand.z;
    
    if(oSwitch == 1)
    {
      float dx = rHand.x - lHand.x;
      if(frameCount % 30 == 0)
        println(dx);
    }
    
    if(oSwitch == 0){
      counter = 0;
    }
  }
  
  void printCoords()
  {
     if (frameCount %30==0) 
    {
      println("x = " +rx);
      println("y = " +ry);
      println("z = " +rz);
    }
  }  
}
  
  
//~~~~~~~~~~~~~~~~~~~~~~~~~~~|~~~~~~~~~~~~~~~~~~~~~~~~~~~//