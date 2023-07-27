PVector calculateDisp(Orbiter mainBody, Orbiter desiredBody) { // Finds a
  // Find semi major and minor axes
  float a, b, velX, velY;
  
  if ((desiredBody.periapsis+desiredBody.apoapsis) >= desiredBody.r*2) {
    a = (desiredBody.periapsis + desiredBody.apoapsis) / 2;
    b = desiredBody.r;
    
    velX = b*cos(desiredBody.theta);
    velY = a*sin(desiredBody.theta);
  }
  else {
    a = (dist(desiredBody.eCenter.x - desiredBody.r, desiredBody.eCenter.y, desiredBody.eCenter.x + desiredBody.r, desiredBody.eCenter.y)) / 2;
    b = (desiredBody.periapsis + desiredBody.apoapsis) / 2;
    
    velY = b*sin(desiredBody.theta);
    velX = a*cos(desiredBody.theta);
  }
  
  PVector vT = new PVector(velX, velY);
  return vT;
}

PVector calculateVelocities(Orbiter desiredBody, Orbiter mainBody) {
  float a, distFrom;
  float u = G * mainBody.mass;
  
  if ((desiredBody.periapsis+desiredBody.apoapsis) > desiredBody.r*2) { // If the ellipse is vertical
    a = (desiredBody.periapsis + desiredBody.apoapsis) / 2;
  }
  else { // If the ellipse is horizontal
    a = (dist(desiredBody.eCenter.x - desiredBody.r, desiredBody.eCenter.y, desiredBody.eCenter.x + desiredBody.r, desiredBody.eCenter.y)) / 2;
  }
  
  distFrom = dist(desiredBody.eCenter.x, desiredBody.eCenter.y, desiredBody.positions.x, desiredBody.positions.y); // Distance from center
  
  float vT = sqrt(u * ((2 / distFrom) - (1/a)) * 50); // Vis-viva equation
  float vX = 50 * vT * cos(desiredBody.theta);
  float vY = 50 * vT * sin(desiredBody.theta);
  
  PVector v = new PVector(vX, vY);
  return v;
}

float findDTheta(Orbiter mainBody, Orbiter desiredBody) {
  float a;
  float u = G * mainBody.mass;
  
  if ((desiredBody.periapsis+desiredBody.apoapsis) > desiredBody.r*2) { // If the ellipse is vertical
    a = (desiredBody.periapsis + desiredBody.apoapsis) / 2;
  }
  else {
    a = (dist(desiredBody.eCenter.x - desiredBody.r, desiredBody.eCenter.y, desiredBody.eCenter.x + desiredBody.r, desiredBody.eCenter.y)) / 2;
  }
  
  float T = 2.0*PI * sqrt(pow(a, 3) / u);
  float dTheta = ((2.0*PI / (T * refresh)) * 50 * 24);
  return dTheta;
}

float findE(Orbiter desiredBody) {
  float a, b;
  
  float c;
  float len;
  PVector f1, f2;
  
  if ((desiredBody.periapsis+desiredBody.apoapsis) > desiredBody.r*2) { // If the ellipse is vertical
    a = (desiredBody.periapsis + desiredBody.apoapsis) / 2;
    b = desiredBody.r;
    c = sqrt(pow(a, 2) - pow(b, 2));
    
    f1 = new PVector(desiredBody.eCenter.x, desiredBody.eCenter.y - c);
    f2 = new PVector(desiredBody.eCenter.x, desiredBody.eCenter.y + c); 
    
    len = desiredBody.periapsis + desiredBody.apoapsis;
  }
  else { // If the ellipse is horizontal
    a = (dist(desiredBody.eCenter.x - desiredBody.r, desiredBody.eCenter.y, desiredBody.eCenter.x + desiredBody.r, desiredBody.eCenter.y)) / 2;
    b = (desiredBody.periapsis + desiredBody.apoapsis) / 2;
    c = sqrt(pow(a, 2) - pow(b, 2));
    
    f1 = new PVector(desiredBody.eCenter.x - c, desiredBody.eCenter.y);
    f2 = new PVector(desiredBody.eCenter.x + c, desiredBody.eCenter.y); 
    
    len = (desiredBody.eCenter.x - desiredBody.r) + (desiredBody.eCenter.x + desiredBody.r);
  }
  return dist(f1.x, f1.y, f2.x, f2.y)/len;
}

Orbiter[] findAllDistances(ArrayList<Orbiter> A) {
  for (int i = 0; i < A.size() - 1; i++) {
    Orbiter currBody = A.get(i);
    Orbiter nextBody = A.get(i + 1);
    
    float d = dist(currBody.positions.x, currBody.positions.y, nextBody.positions.x, nextBody.positions.y);
    stroke(255);
    
    if (d < currBody.SOIr) {
      Orbiter[] returnA = new Orbiter[2];
      if (currBody.mass > nextBody.mass) {
        returnA[0] = currBody;
        returnA[1] = nextBody; // Element with the most mass is the first element in the array
      }
      else {
        returnA[0] = currBody;
        returnA[1] = nextBody;
      }
      SOIEntered = true;
      return returnA;
    } 
  }
  return null;
}
