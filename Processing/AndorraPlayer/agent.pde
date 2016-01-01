//Set to true if agents iterated by frame
//Set to false if agents iterated by time (useful for choppy framerate; but may cause agents to "jump")
boolean frameStep = true;

float time_0 = 0;
float speed = 0.4444444;

void updateSpeed(int dir) {
  switch (dir) {
    case -1:
      speed /= 1.5;
      break;
    case 1:
      speed *= 1.5;
      break;
  }
  println("Speed: " + speed);
}

class Agent {
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;
  float maxspeed;
  int age;
  float tolerance = 1;
  float fade = 1;
  
  boolean finished = false;
  boolean dead = false;
  
  int pathIndex, pathLength;
  
  Agent(float x, float y, int rad, float maxS, int pLength) {
    r = rad;
    tolerance *= r;
    location = new PVector(x + random(-tolerance, tolerance), y + random(-tolerance, tolerance));
    maxspeed = maxS;
    maxforce = 0.2;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    age = 0;
    pathIndex = 0;
    pathLength = pLength;
  }
  
  
  
  void applyForce(PVector force){
    acceleration.add(force);

  }
  
  void reverseCourse() {
    velocity.x *= random(-20);
    velocity.y *= random(-20);
  }
  
  void roll(PVector normalForce) {
    PVector negNorm = new PVector(-1*normalForce.x, -1*normalForce.y);
    if (PVector.angleBetween(velocity, normalForce) > PVector.angleBetween(velocity, negNorm)) {
      normalForce.mult(-1);
    }
    normalForce.setMag(.5);
    applyForce(normalForce);
  }
  
  void applyBehaviors(ArrayList<Agent> agents, PVector waypoint) {
     PVector separateForce = separate(agents);
     PVector seekForce = seek(new PVector(waypoint.x + random(-tolerance, tolerance),waypoint.y + random(-tolerance, tolerance)));
     separateForce.mult(3);
     seekForce.mult(1);
     applyForce(separateForce);
     applyForce(seekForce);
  }
  
  PVector seek(PVector target){
      PVector desired = PVector.sub(target,location);
      desired.normalize();
      desired.mult(maxspeed);
      PVector steer = PVector.sub(desired,velocity);
      steer.limit(maxforce);
      return steer;
  
  }
  
  PVector separate(ArrayList<Agent> agents){
    float desiredseparation = r*1.5;
    //float desiredseparation = r*0.5;
    PVector sum = new PVector();
    int count = 0;
    
    for(Agent other : agents) {
      float d = PVector.dist(location, other.location);
      
      if ((d > 0 ) && (d < desiredseparation)){
        
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0){
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      sum.sub(velocity);
      sum.limit(maxforce);
    }
   return sum;   
  }
  
  void update(int life, Obstacle sink, PVector waypoint) {
    // Update velocity
    velocity.add(acceleration);
    
    if (frameStep) {
      location.add(new PVector(speed*velocity.x, speed*velocity.y));
    } else {
      location.add(new PVector(speed*0.0625*velocity.x*(millis()-time_0), speed*0.0625*velocity.y*(millis()-time_0)));
    }
        
    // Limit speed
    velocity.limit(maxspeed);
    
    // Reset acceleration to 0 each cycle
    acceleration.mult(0);
    
    // Check if agent at end of life
    age ++;
    if (age > life*maxspeed/4) {
      finished = true;
    }
    
    if (finished) {
      //fade -= .1;
      fade -= 1;
      if (fade <= 0) {
        dead = true;
      }
    }
    
    // Checks if Agents reached current waypoint
    float prox = abs( (location.x - waypoint.x) + (location.y - waypoint.y) );
    if (prox < finderResolution/4) {
      pathIndex++;
      if (pathIndex >= pathLength) {
        pathIndex = pathLength - 1;
      }
    }
    
    //Checks if Agent reached destination
    if (sink.pointInPolygon(location.x, location.y)) {
      finished = true;
    }
     
    
  }
  
  void display(color fill, int alpha) {
    tableCanvas.fill(fill, fade*alpha);
    tableCanvas.noStroke();
    tableCanvas.pushMatrix();
    tableCanvas.translate(location.x, location.y);
    tableCanvas.ellipse(0, 0, r, r);
    tableCanvas.popMatrix();
  }
  
}

// A class for managing multiple agents

class Swarm {
  
  boolean generateAgent = true;
  boolean cropAgents = true;
  
  ArrayList<Agent> swarm;
  
  float agentLife = canvasWidth+canvasHeight;
  float agentDelay;
  float maxSpeed;
  float counter = 0;
  color fill;
  int hitbox = 5;
  
  PVector origin, destination;
  
  Obstacle sink;
  
  ArrayList<PVector> path;
//  ArrayList<Obstacle> pathBoxes;
  
  Swarm (float delay, int life) {
    agentLife = life;
    agentDelay = delay;
    swarm = new ArrayList<Agent>();
  }
  
  Swarm (float delay, PVector a, PVector b, float maxS, color f) {
    origin = a;
    destination = b;
    
    path = new ArrayList<PVector>();
    path.add(origin);
    path.add(destination);
    
    if (a == b) { // No sink created
      sink = hitBox(destination, hitbox, false);
    } else {
      sink = hitBox(destination, hitbox, true);
    }
    
    maxSpeed = maxS;
    if (a != b) {
      agentLife *= 1 + (abs(a.x - b.x) + abs(a.y - b.y)) / (canvasWidth+canvasHeight);
      agentLife *= 40.0/maxSpeed;
    }
    //println(agentLife);
    agentDelay = delay;
    swarm = new ArrayList<Agent>();
    fill = f;
    
    //All Agents do not spawn on first frame
    counter += -int(random(40));
  }
  
  Obstacle hitBox(PVector coord, int r, boolean make) {

    PVector[] hitBox = new PVector[4];
    
    if (!make) { // Creates, essentially, a useless hitbox with no area
      hitBox[0] = new PVector(0, 0);
      hitBox[1] = new PVector(0, 0);
      hitBox[2] = new PVector(0, 0);
      hitBox[3] = new PVector(0, 0);
    } else {
      hitBox[0] = new PVector( - r,  - r);
      hitBox[1] = new PVector( + r,  - r);
      hitBox[2] = new PVector( + r,  + r);
      hitBox[3] = new PVector( - r,  + r);
    }
    
    for (int i=0; i<hitBox.length; i++) {
      hitBox[i].add(coord);
    }
    
    return new Obstacle(hitBox);
  }
    
  
  void solvePath(Pathfinder f) {
    path = f.findPath(origin, destination);
//    pathBoxes = new ArrayList<Obstacle>();
//    for (int i=0; i<path.size(); i++) {
//      pathBoxes.add(hitBox(path.get(i), hitbox, true));
//    }
  }
  
  void update() {
    
    counter ++ ;
    
    // Determines if a new agent is needed
    if (counter > adjust*agentDelay/speed) {
      generateAgent = true;
      counter = 0;
    }
    
    // Adds an agent
    if (generateAgent) {
      if (origin == null) {
        swarm.add(new Agent(random(canvasWidth), random(canvasHeight), 6, maxSpeed, path.size()));
      } else {
        swarm.add(new Agent(origin.x, origin.y, 6, maxSpeed, path.size()));
      }
      
      generateAgent = false;
    }
    
    // removes an agent if too old or reached destination
    if (swarm.size() > 0) {
      for (int i=0; i<swarm.size(); i++){
        if (swarm.get(i).dead){
          swarm.remove(i);
        }
      }
    }
    
    // Updates existing agents in swarm
    if (swarm.size() > 0) {
      
      for (Agent v : swarm){
        
        boolean collision = false;
        
        // Tests for Collision with Test Objects
        for (int i=0; i<testWall.length; i++) {
          if (testWall[i].pointInPolygon(v.location.x, v.location.y) ) {
            collision = true;
            //v.reverseCourse();
            v.roll(testWall[i].normalOfEdge(v.location.x, v.location.y, v.velocity.x, v.velocity.y));
            break;
          }
        }
        
        // Tests for Collision with obstacleCourse boundaries
        if (cropAgents) {
          // agents internal to table
          collision = boundaries.testForCollision(v);
        } else {
          // agents on margins of table
          collision = container.testForCollision(v);
        }
        
        
//        // Applies unique forcevector if collision detected....not so great
//        if (collision) {
//          //v.applyBehaviors(swarm, new PVector(v.location.x+random(-10, 10), v.location.y+random(-10, 10)));
//          //v.applyBehaviors(swarm, v.location);
//          v.update(int(agentLife/speed), sink);
//          // draws as red if collision detected
//          //v.display(#FF0000, 100);
//          collision = false;
//        } else {
//          v.applyBehaviors(swarm, destination);
//          v.update(int(agentLife/speed), sink);
//          // draws normally if collision detected
//          //v.display(fill, 100);
//        }
        
        // Updates agent behavior
        v.applyBehaviors(swarm, path.get(v.pathIndex));
        v.update(int(agentLife/speed), sink, path.get(v.pathIndex));
        
      }
    }
  }
  
  void display(String colorMode) {
    if (swarm.size() > 0) {
      for (Agent v : swarm){
        if (showSwarm) {
          if (!cropAgents) {
              if (v.location.y > marginWidthPix) {
//            if (v.location.x < 0.75*marginWidthPix || v.location.x > (tableCanvas.width - 0.75*marginWidthPix) || 
//                v.location.y < 0 || v.location.y > (tableCanvas.height - 0.75*marginWidthPix) ) {
                  if(colorMode.equals("color")) {
                      v.display(fill, 255);
                  } else if(colorMode.equals("grayscale")) {
                      v.display(#333333, 100);
                  } else {
                      v.display(fill, 100);
                  }
                }
          } else {
            if (v.location.x > 1.25*marginWidthPix && v.location.x < (tableCanvas.width - 1.25*marginWidthPix) && 
                v.location.y > 1.25*marginWidthPix && v.location.y < (tableCanvas.height - 1.25*marginWidthPix) ) {
                  if(colorMode.equals("color")) {
                      v.display(fill, 255);
                  } else if(colorMode.equals("grayscale")) {
                      v.display(#333333, 100);
                  } else {
                      v.display(fill, 100);
                  }
                }
          }
        }
      }
    }
  }
  
  // Draw Sources and Sinks
  void displaySource() {
    
    if (swarm.size() > 0) {
      tableCanvas.noFill();
      tableCanvas.stroke(fill, 100);
      
      //Draw Source
      tableCanvas.strokeWeight(2);
      tableCanvas.line(origin.x - swarm.get(0).r, origin.y - swarm.get(0).r, origin.x + swarm.get(0).r, origin.y + swarm.get(0).r);
      tableCanvas.line(origin.x - swarm.get(0).r, origin.y + swarm.get(0).r, origin.x + swarm.get(0).r, origin.y - swarm.get(0).r);
      
      //Draw Sink
      tableCanvas.strokeWeight(3);
      tableCanvas.ellipse(destination.x, destination.y, 30, 30);
    }
  }
  
  void displayEdges() {
    
    // Draws weighted lines from origin to destinations
    tableCanvas.stroke(fill, 50);
    tableCanvas.fill(fill, 50);
    if (agentDelay > 0) {
      tableCanvas.strokeWeight(5.0/agentDelay);
    } else {
      tableCanvas.noStroke();
    }
    
    
      
    if (origin != destination) {
      tableCanvas.line(origin.x, origin.y, destination.x, destination.y);
    } else {
      tableCanvas.noStroke();
      tableCanvas.ellipse(origin.x, origin.y, 1.0/agentDelay, 1.0/agentDelay);
    }
    tableCanvas.strokeWeight(1);
    tableCanvas.noStroke();
      
  }
  
  void displayPath() {
    tableCanvas.strokeWeight(2);
    
//    // Draw Path Nodes
//    for (int i=0; i<testPath.size(); i++) {
//      tableCanvas.stroke(#00FF00);
//      tableCanvas.ellipse(testPath.get(i).x, testPath.get(i).y, finderResolution, finderResolution);
//    }
    
    // Draw Path Edges
    for (int i=0; i<path.size()-1; i++) {
      tableCanvas.stroke(#00FF00);
      tableCanvas.line(path.get(i).x, path.get(i).y, path.get(i+1).x, path.get(i+1).y);
    }
    
    //Draw Origin
    tableCanvas.stroke(#FF0000);
    tableCanvas.ellipse(origin.x, origin.y, finderResolution, finderResolution);
    
    //Draw Destination
    tableCanvas.stroke(#0000FF);
    tableCanvas.ellipse(destination.x, destination.y, finderResolution, finderResolution);
  }
  
}

// A class for managing multiple Swarms
class Horde {
  
}

