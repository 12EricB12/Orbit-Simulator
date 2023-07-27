import g4p_controls.*;

float periapsis = 2;
float apoapsis = 2;
float r = 2;
float dTheta;
float theta = 90;
float e, v;
int refresh = 60;

float mainX, mainY;
float mainSize = 50;
float dT = 0.5;

boolean startMoving = false;
boolean SOIEntered = false;
boolean showOrbit = true;
boolean showVector = true;
boolean showMag = true;
boolean showSOI = false;

Orbiter sun, planet1;
Orbiter newOrbiter; // Where the current orbiter we will be adding is stored
ArrayList<Orbiter> allBodies = new ArrayList<Orbiter>();

// CONSTANTS
float G = pow(6.67, -11);

void setup() {
  size(600, 600);
  
  mainX = width/2;
  mainY = height/2;
  
  periapsis *= 50;
  apoapsis *= 50;
  r *= 50;
  
  String[] system = loadStrings("Star System.txt");
  Orbiter[] newBodies = new Orbiter[system.length + 1]; // Add an extra slot for the newOrbiter
  
  sun = new Orbiter(mainX, mainY, 0, 0, pow(1.989, 30), r, color(255, 232, 124));
  newOrbiter = new Orbiter(mainX, mainY, periapsis, apoapsis, 4000, r, color(255));
  
  for (int i = 0; i < system.length; i++) {
    String[] systemSplit = system[i].split(", ");
    int[] newSplit = new int[systemSplit.length];
    for (int j = 0; j < systemSplit.length; j++) {
      newSplit[j] = Integer.parseInt(systemSplit[j]);
    }
    
    println(newSplit);
    newBodies[i] = new Orbiter(mainX, mainY, newSplit[0] * 50, newSplit[1] * 50, newSplit[2], newSplit[3], newSplit[4]);
  }
  newBodies[system.length] = newOrbiter;
  
  fillOrbiterList(newBodies);
  
  frameRate(refresh);
  createGUI();
}

void draw() {
  background(0);
  
  createPlanets();
  
  if (startMoving) {
    for (int i = 0; i < allBodies.size(); i++) {
      Orbiter[] intersection = {planet1, newOrbiter};
      if (!SOIEntered) {
        Orbiter currBody = allBodies.get(i);
        drawOrbit(sun, currBody);
        
        currBody.theta += currBody.dTheta * dT;
        PVector newPos = calculateDisp(sun, currBody);
        currBody.setNewPositions(newPos, sun);
        findAllDistances(allBodies);
      }
      else {
        drawFocusScreen(intersection); 
        break;
      } 
    }
  }
  else {
    for (int i = 0; i < allBodies.size(); i++) {
      drawOrbit(sun, allBodies.get(i));
      drawOrbit(sun, newOrbiter);
      redraw();
    }
  }
}

void createPlanets() {
  // SUN
  fill(255, 232, 124);
  circle(mainX, mainY, pow(sun.mass, 0.2));
}

void setInitalPositions() {
  for (int i = 0; i < allBodies.size(); i++) {
    allBodies.get(i).setInital(sun);
  }
}

void fillOrbiterList(Orbiter[] A) {
  for (int i = 0; i < A.length; i++) {
    Orbiter currOrbiter = A[i];
    
    currOrbiter.setInital(sun);
  
    e = findE(currOrbiter);
    
    currOrbiter.dTheta = findDTheta(sun, currOrbiter);
    
    currOrbiter.e = e;
    
    allBodies.add(A[i]);
  }
}
