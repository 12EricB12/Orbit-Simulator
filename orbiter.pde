class Orbiter {
  PVector positions;
  PVector eCenter;
  PVector allV;
  float SOIr;
  float xVel, yVel;
  float xSpeed, ySpeed;
  float periapsis, apoapsis;
  float mass;
  float e, v;
  float r;
  float theta, dTheta;
  color planetColour;
  
  Orbiter(float xP, float yP, float pe, float ap, float m, float rad, color c) {
    this.positions = new PVector(xP, yP + pe);
    this.periapsis = pe;
    this.apoapsis = ap;
    this.mass = m;
    this.planetColour = c;
    this.r = rad;
  }
  
  void setInital(Orbiter o) {
    this.positions.x = o.positions.x;
    this.positions.y = o.positions.y + this.periapsis;
   
    this.eCenter = new PVector(this.positions.x, ((o.positions.y + this.periapsis) + (o.positions.y - this.apoapsis))/2);
    
    float a;
    
    if ((this.periapsis+this.apoapsis) > o.r*2) { // If the ellipse is vertical
      a = (this.periapsis + this.apoapsis) / 2;
    }
    else {
      a = (dist(this.eCenter.x - this.r, this.eCenter.y, this.eCenter.x + this.r, this.eCenter.y)) / 2;
    }
    this.SOIr = a * pow((this.mass/o.mass), (2.0/15));
  }
  
  void drawVector() {
    if (showVector) {
      // X ARROW
      pushMatrix();
      drawArrow(this.positions.x, this.positions.y, 40, this.theta);
      textAlign(CENTER);
      textSize(12);
      popMatrix();
      
      // Y ARROW
      pushMatrix();
      drawArrow(this.positions.x, this.positions.y, 40, this.theta + PI/2);
      translate(this.positions.x, this.positions.y);
      popMatrix();
    }
  }
  
  void drawMag() {
    if (showMag) {
      textSize(12);
      textAlign(CENTER);
      fill(255);
      text(nf(this.allV.mag(), 2, 2) + "km/s", this.positions.x, this.positions.y - 20);
      noFill();
    }
  }
  
  void drawSOI() {
    if (showSOI) {
      noFill();
      stroke(255,114,118);
      circle(this.positions.x, this.positions.y, SOIr);
    }
  }
  
  void setNewPositions(PVector disp, Orbiter o) {
    if (!SOIEntered) {
      PVector vel = calculateVelocities(this, o);
      this.xVel = vel.x;
      this.yVel = vel.y;
      
      this.allV = new PVector(this.xVel, this.yVel);
      
      this.positions.x = this.eCenter.x + disp.x;
      this.positions.y = this.eCenter.y + disp.y;
    }
    
    drawVector();
    drawMag();
    drawSOI();
    
    pushMatrix();
    fill(this.planetColour);
    circle(this.positions.x, this.positions.y, pow(this.mass, 0.2));
    noFill();
    popMatrix();
  }
}
