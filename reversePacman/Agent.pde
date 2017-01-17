import java.util.Map;

class Agent {

  PVector pos; // current (x,y) position of agent
  PVector vel; // current velocity of agent
  PVector acc; // current acceleration of agent
  int d = 30;  // diameter of the agent
  color mycolor; // the color for drawing the agent
  int compare;
  color checker;
  PImage maze;
  boolean [] dir = new boolean[4];
  ArrayList<PVector> frontier = new ArrayList<PVector>();
  HashMap<PVector, PVector> came_from = new  HashMap<PVector, PVector>();
  ArrayList<PVector> path = new ArrayList<PVector>();
  PVector next;
  boolean [] bool;
  PVector start;
  PVector current;
  boolean eaten;
  PVector lastPos;
  String facing;
  
  ArrayList<Float> cost = new ArrayList<Float>();
  int visitint = 0;

  Agent(int x0, int y0) {
    pos = new PVector(x0, y0);
    vel = new PVector(0, 0);
    acc = new PVector(20, 20);
    lastPos = new PVector(0, 0);
    facing = "west";
    eaten = false;
  } 
  
  Agent(int x0, int y0, color mycolor) {
    pos = new PVector(x0, y0);
    vel = new PVector(0, 0);
    acc = new PVector(20, 20);
    lastPos = new PVector(0, 0);
    facing = "west";
    this.mycolor = mycolor;
    eaten = false;
  } 
  
  PVector getPos() {
    return(pos);
  }
  void setPos(PVector pos){
    this.pos = pos;
  }
  int getXPos(){
    return(int(pos.x));
  }
  int getYPos(){
    return(int(pos.y));
  }
  void setCol(color mycolor){
    this.mycolor = mycolor;
  }
  void setEat(){
    eaten = true;
  }
  boolean getEat(){
    return eaten;
  }

  void drawPac() {
    fill(255,255,0);
    strokeWeight(0);
    ellipse(pos.x, pos.y, d, d );
  }
  void drawPac_dir() {
    fill(255,255,0);
    strokeWeight(0);
    ellipse(pos.x, pos.y, d, d );
    noStroke();
    fill(0, 0, 0);
    if (facing == "north"){  // faces North
      triangle(pos.x, pos.y, pos.x-d/1.85, pos.y-d/1.85, pos.x+d/1.85, pos.y-d/1.85);
    }
    if (facing == "west"){  // faces West
      triangle(pos.x, pos.y, pos.x-d/1.85, pos.y+d/1.85, pos.x-d/1.85, pos.y-d/1.85);
    }
    if (facing == "south"){  // faces South
      triangle(pos.x, pos.y, pos.x-d/1.85, pos.y+d/1.85, pos.x+d/1.85, pos.y+d/1.85);
    }
    if (facing == "east"){  // faces East
      triangle(pos.x, pos.y, pos.x+d/1.85, pos.y-d/1.85, pos.x+d/1.85, pos.y+d/1.85);
    }
  }
  void drawPac_dir2() {
    fill(255,255,0);
    strokeWeight(0);
    ellipse(pos.x, pos.y, d, d );
    noStroke();
    fill(0, 0, 0);
    if (facing == "north"){  // faces North
      triangle(pos.x, pos.y, pos.x-d/2.1, pos.y-d/2.1, pos.x+d/2.1, pos.y-d/2.1);
    }
    if (facing == "west"){  // faces West
      triangle(pos.x, pos.y, pos.x-d/2.1, pos.y+d/2.1, pos.x-d/2.1, pos.y-d/2.1);
    }
    if (facing == "south"){  // faces South
      triangle(pos.x, pos.y, pos.x-d/2.1, pos.y+d/2.1, pos.x+d/2.1, pos.y+d/2.1);
    }
    if (facing == "east"){  // faces East
      triangle(pos.x, pos.y, pos.x+d/2.1, pos.y-d/2.1, pos.x+d/2.1, pos.y+d/2.1);
    }
  }
  
  void drawPac0() {  // faces North
    fill(255,255,0);
    strokeWeight(0);
    ellipse(pos.x, pos.y, d, d );
    noStroke();
    fill(0, 0, 0);
    triangle(pos.x, pos.y, pos.x-d/1.85, pos.y-d/1.85, pos.x+d/1.85, pos.y-d/1.85);
  }
  void drawPac1() {   // faces West
    fill(255,255,0);
    strokeWeight(0);
    ellipse(pos.x, pos.y, d, d );
    noStroke();
    fill(0, 0, 0);
    triangle(pos.x, pos.y, pos.x-d/1.85, pos.y+d/1.85, pos.x-d/1.85, pos.y-d/1.85);
  }
  void drawPac2() {  // faces South
    fill(255,255,0);
    strokeWeight(0);
    ellipse(pos.x, pos.y, d, d );
    noStroke();
    fill(0, 0, 0);
    triangle(pos.x, pos.y, pos.x-d/1.85, pos.y+d/1.85, pos.x+d/1.85, pos.y+d/1.85);
  }
  void drawPac3() {  // faces East
    fill(255,255,0);
    strokeWeight(0);
    ellipse(pos.x, pos.y, d, d );
    noStroke();
    fill(0, 0, 0);
    triangle(pos.x, pos.y, pos.x+d/1.85, pos.y-d/1.85, pos.x+d/1.85, pos.y+d/1.85);
  }
  
  void drawGhost() {
    fill(mycolor);
    strokeWeight(0);
    stroke(mycolor);
    ellipse(pos.x-8, pos.y+2.5, d/2, d);
    ellipse(pos.x, pos.y+3, d/2, d);
    ellipse(pos.x+8, pos.y+2.5, d/2, d);
    ellipse(pos.x, pos.y, d, d);
    fill(#ffffff);
    ellipse(pos.x+7, pos.y-4, 13,12);
    ellipse(pos.x-7, pos.y-4, 13,12);
    stroke(255,255,255);
    fill(#000000);
    ellipse(pos.x+7, pos.y-4, 7,6);
    ellipse(pos.x-7, pos.y-4, 7,6);
    checkDirection(getPos(), dir);
  }

  void movePac( int direction ) {
    switch( direction ) {
    case NORTH:
      if(dir[0] == true){
        //println("north true");
        vel.x = 0;
        vel.y = 0;
        vel.y -= acc.y;
        pos.y += vel.y;
        fill(#000000);
        stroke(0,0,0);
        //triangle((pos.x), (pos.y+5), (pos.x)-(d/2), (pos.y)-(d/2), (pos.x)+(d/2), (pos.y)-(d/2));
      }
        break;
    case SOUTH:
      if(dir[1] == true){
        //println("south true");
        vel.x = 0;
        vel.y = 0;
        vel.y += acc.y;
        pos.y += vel.y;
        fill(#000000);
        stroke(0,0,0);
      }
        break;
        
    case WEST:
    if(dir[2] == true){
      //println("west true");
      vel.x = 0;
      vel.y = 0;
      vel.x -= acc.x;
      pos.x += vel.x;
      fill(#000000);
      stroke(0,0,0);
    }
      break;
      
    case EAST:
    if(dir[3] == true){
      //println("east true");
      vel.x = 0;
      vel.y = 0;
      vel.x += acc.x;
      pos.x += vel.x;
      fill(#000000);
      stroke(0,0,0);
    }
    break;
    case STOP:
      vel.x = 0;
      vel.y = 0;
      break;
    }
  }//movePac end
  
  void checkDirection(PVector position, boolean [] directions){
    for (int i = 0; i < 4; i++){
      directions[i] = false;
    }
    if(
        ((position.x == 40 || position.x == 560) && ((position.y > 40 && position.y <= 180) || (position.y > 380 && position.y <= 440) || (position.y > 500 && position.y <= 560))) ||
        ((position.x == 60 || position.x == 540) && ((position.y > 440 && position.y <= 500))) ||
        ((position.x == 120 || position.x == 480) && ((position.y > 40 && position.y <= 500))) ||
        ((position.x == 180 || position.x == 420) && ((position.y > 120 && position.y <= 180) || (position.y > 240 && position.y <= 420))) ||
        ((position.x == 240 || position.x == 360) && ((position.y > 420 && position.y <= 560))) ||
        ((position.x == 260 || position.x == 340) && ((position.y > 40 && position.y <= 120) || (position.y > 180 && position.y <= 240)))
    ){ directions[0] = true; }
    if(
        ((position.x == 40 || position.x == 560) && ((position.y >= 40 && position.y < 180) || (position.y >= 380 && position.y < 440) || (position.y >= 500 && position.y < 560))) ||
        ((position.x == 60 || position.x == 540) && ((position.y >= 440 && position.y < 500))) ||
        ((position.x == 120 || position.x == 480) && ((position.y >= 40 && position.y < 500))) ||
        ((position.x == 180 || position.x == 420) && ((position.y >= 120 && position.y < 180) || (position.y >= 240 && position.y < 420))) ||
        ((position.x == 240 || position.x == 360) && ((position.y >= 420 && position.y < 560))) ||
        ((position.x == 260 || position.x == 340) && ((position.y >= 40 && position.y < 120) || (position.y >= 180 && position.y < 240)))
     ){ directions[1] = true; }
    if(
      ((position.y == 40) && ((position.x > 40 && position.x <= 260) || (position.x > 340 && position.x <= 560))) ||
      ((position.y == 120 || position.y == 560) && ((position.x > 40 && position.x <= 560))) ||
      ((position.y == 180) && ((position.x > 40 && position.x <= 120)||(position.x > 180 && position.x <= 260)||(position.x > 340 && position.x <= 420)||(position.x > 480 && position.x <= 560))) ||
      ((position.y == 240) && ((position.x > 180 && position.x <= 420))) ||
      ((position.y == 280) && ((position.x > 0 && position.x <= 180)||(position.x > 420 && position.x <= 600))) ||
      ((position.y == 360) && ((position.x > 180 && position.x <= 420))) ||
      ((position.y == 380) && ((position.x > 40 && position.x <= 120)||(position.x > 480 && position.x <= 560))) ||
      ((position.y == 420) && ((position.x > 120 && position.x <= 240)||(position.x > 360 && position.x <= 480))) ||
      ((position.y == 440) && ((position.x > 40 && position.x <= 60)||(position.x > 540 && position.x <= 560))) ||
      ((position.y == 460) && ((position.x > 240 && position.x <= 360))) ||
      ((position.y == 480) && ((position.x > 120 && position.x <= 240)||(position.x > 360 && position.x <= 480))) ||
      ((position.y == 500) && ((position.x > 40 && position.x <= 120)||(position.x > 480 && position.x <= 560)))
    ){ directions[2] = true; }    
    if(
      ((position.y == 40) && ((position.x >= 40 && position.x < 260) || (position.x >= 340 && position.x < 560))) ||
      ((position.y == 120 || position.y == 560) && ((position.x >= 40 && position.x < 560))) ||
      ((position.y == 180) && ((position.x >= 40 && position.x < 120)||(position.x >= 180 && position.x < 260)||(position.x >= 340 && position.x < 420)||(position.x >= 480 && position.x < 560))) ||
      ((position.y == 240) && ((position.x >= 180 && position.x < 420))) ||
      ((position.y == 280) && ((position.x >= 0 && position.x < 180)||(position.x >= 420 && position.x < 600))) ||
      ((position.y == 360) && ((position.x >= 180 && position.x < 420))) ||
      ((position.y == 380) && ((position.x >= 40 && position.x < 120)||(position.x >= 480 && position.x < 560))) ||
      ((position.y == 420) && ((position.x >= 120 && position.x < 240)||(position.x >= 360 && position.x < 480))) ||
      ((position.y == 440) && ((position.x >= 40 && position.x < 60)||(position.x >= 540 && position.x < 560))) ||
      ((position.y == 460) && ((position.x >= 240 && position.x < 360))) ||
      ((position.y == 480) && ((position.x >= 120 && position.x < 240)||(position.x >= 360 && position.x < 480))) ||
      ((position.y == 500) && ((position.x >= 40 && position.x < 120)||(position.x >= 480 && position.x < 560)))
    ){ directions[3] = true; }
  }//end of checkdirection
  
  void bfstest(){
    frontier.clear();
    frontier.trimToSize();
    came_from.clear();
    frontier.add(getPos());
    came_from.put(getPos(), null);
    bool = new boolean[4];
    while(frontier.size() > 0){
      current = frontier.remove(0);
      //fill(#ff0000);
      //rect(current.x-20, current.y-20, 40, 40);
      checkDirection(current, bool);
      if(bool[0] == true){
        next = new PVector(current.x, current.y-20); 
        if (!came_from.containsKey(next)){
            frontier.add(next);
            came_from.put(next, current);
          }
      }
      if(bool[1] == true){
        next = new PVector(current.x, current.y+20); 
        if (!came_from.containsKey(next)){
            frontier.add(next);
            came_from.put(next, current);
          }
      }      
      if(bool[2] == true){
        next = new PVector(current.x-20, current.y); 
        if (!came_from.containsKey(next)){
            frontier.add(next);
            came_from.put(next, current);
          }
      }
      if(bool[3] == true){
        next = new PVector(current.x+20, current.y); 
        if (!came_from.containsKey(next)){
            frontier.add(next);
            came_from.put(next, current);
          }
      }      
    }
  }//end bfstest
  
  void buildPath(PVector target){
    //println("buildpath");
    start = getPos();
    current = target;
    path.add(current);
    //fill(#ff0000);
    //rect(current.x-20, current.y-20, 40, 40);
    //println("adding " + current);
    while (current != start){
      if(!(path.contains(came_from.get(current)))){
        current = came_from.remove(current);
        //println("adding " + current);
        path.add(current);
        //fill(#ff0000);
        //rect(current.x-20, current.y-20, 40, 40);
      }
      else{
        break;
      }
    }
  }//end buildPath
   
  void printPath(){
    for (int i = path.size()-1;i>=0;i--){
      print(path.get(i) + "\n");
    }
  }
  
  void clearPath(){
    path.clear();
    path.trimToSize();
  }
  
  void moveToPath(){
    //println("move path");
    if(path.size() > 1){
      //println("there is a path " + path.size());
      path.remove(path.size()-1);
      lastPos = this.pos;
      this.pos = path.remove(path.size()-1);
      checkDir();
      //println("moving to " + pos);
    }
  }
  
  void checkDir(){
    if (pos.y < lastPos.y){  // faces North
      facing = "north";
    }
    if (pos.x < lastPos.x){  // faces West
      facing = "west";
    }
    if (pos.y > lastPos.y){  // faces South
      facing = "south";
    }
    if (pos.x > lastPos.x){  // faces East
      facing = "east";
    }
  }
};