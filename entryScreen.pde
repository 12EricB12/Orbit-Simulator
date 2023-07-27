boolean valuesUpdated = false;
Orbiter desiredOrbiter, mainOrbiter;
Orbiter[] A;

void drawFocusScreen(Orbiter[] bodies) {
  if (!valuesUpdated) {
    // Create new Orbiter objects based on the ones already present in the list so the values can be manipulated later
    Orbiter desiredOrbiter = bodies[1];
    Orbiter mainOrbiter = bodies[0];
    
    mainOrbiter.theta = radians(290);
    desiredOrbiter.theta = radians(330);
    
    // Update the values
    desiredOrbiter.positions.x = width/2;
    desiredOrbiter.positions.y = height/2;
    mainOrbiter.positions.x = 0;
    mainOrbiter.positions.y = height/2;
    
    findInital(mainOrbiter, desiredOrbiter);
    valuesUpdated = true; // Flips to showing the orbit after initalizing all inital values
  }
  else {
    drawApproach(mainOrbiter, desiredOrbiter);
  }
}

void findInital(Orbiter mainBody, Orbiter desiredBody) {
   // Determine slopes and y-intercepts for the vectors
  float mD = desiredBody.yVel / desiredBody.xVel;
  float cD = desiredBody.positions.y - mD * desiredBody.positions.x;
  
  // Determine the POI
  float y = abs(mD * width/2 + cD);
  float x = width/2;
  
  // Weird velocity bug where they would sometimes turn negative. Not sure what caused it but it just flipped signs, nothing else.
  mainBody.allV.x = abs(mainBody.allV.x);
  mainBody.allV.y = abs(mainBody.allV.y);
  desiredBody.allV.x = abs(desiredBody.allV.x);
  desiredBody.allV.x = abs(desiredBody.allV.x);
  
  // Compute the resultant vector
  PVector vResultant = PVector.add(mainBody.allV, desiredBody.allV);
  float newTheta = vResultant.heading() + radians(270);
  
  // Create a new orbit based on the given information
  desiredBody.apoapsis = y;
  desiredBody.periapsis = 500;
  desiredBody.r = vResultant.mag() * 10;
  
  desiredBody.dTheta = findDTheta(mainBody, desiredBody) * 50;
  desiredBody.theta = 299.4;
  println(newTheta);
  
  desiredBody.setInital(mainBody);
  desiredBody.eCenter = new PVector(width/2, height/2 + 250);
  desiredBody.allV = new PVector(vResultant.x * 50, vResultant.y * 50);
  
  // Set local variables to global variables
  desiredOrbiter = desiredBody;
  mainOrbiter = mainBody;
}

void drawApproach(Orbiter mainBody, Orbiter desiredBody) {
  // Update positions
  println(desiredBody.eCenter);
  
  drawOrbit(mainBody, desiredBody);
  
  PVector newPos = calculateDisp(mainBody, desiredBody);
  desiredBody.setNewPositions(newPos, mainBody);
  
  if (desiredBody.positions.x > width || desiredBody.positions.y > height) {
    SOIEntered = false;
    noLoop();
  } 
  else {
    desiredBody.theta += desiredBody.dTheta;
    desiredBody.setNewPositions(newPos, mainBody);
  }
}
