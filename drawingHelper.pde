void drawOrbit(Orbiter mainBody, Orbiter desiredBody) {
  if (!startMoving) {
    pushMatrix();
    PVector center = new PVector(mainBody.positions.x, mainBody.positions.y - (desiredBody.apoapsis+desiredBody.periapsis)/2 + desiredBody.periapsis);
    noFill();
    stroke(desiredBody.planetColour);
    ellipse(center.x, center.y, desiredBody.r*2, desiredBody.periapsis+desiredBody.apoapsis);
    popMatrix();
  }
  else {
    if (showOrbit) {
      PVector center = new PVector(desiredBody.eCenter.x, desiredBody.eCenter.y);
      noFill();
      pushMatrix();
      stroke(desiredBody.planetColour);
      ellipse(center.x, center.y, desiredBody.r*2, (desiredBody.periapsis + desiredBody.apoapsis));
      popMatrix();
    }
  }
}

void drawArrow(float cX, float cY, float len, float theta) {
  pushMatrix();
  translate(cX, cY);
  rotate(theta + PI/2);
  stroke(255, 191, 0);
  line(0,0,len, 0); // The main "Line" of the arrow
  line(len, 0, len - 8, -8); // The head of the arrow that turns left from the main line
  line(len, 0, len - 8, 8); // The head of the arrow that turns right from the main line
  popMatrix(); // Update the positions of the arrows
  stroke(255);
}
