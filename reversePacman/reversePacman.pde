int dotx = 40;
int doty = 40;
ArrayList<Dot> dots = new ArrayList<Dot>();
Agent pacman;
Agent playerghost;
Agent aighost;
static final int NORTH = 0;
static final int WEST  = 1;
static final int SOUTH = 2;
static final int EAST  = 3;
static final int STOP = 4;
static final int PLAY = 1;
static final int GHOSTWIN = 2;
static final int PACMANWIN = 3;
int time, time2, time3, time4, time5;
int wait = 150; //150 for ghost to catch pacman
int wait2 = 300;
int onPlay = PLAY; // 1 = play, 2 = ghost wins, 3 = pacman wins
PImage pacMap;
color ghostColor;
Dot isEaten;
Dot close;
boolean dangerMode = false;
boolean chaseMode = false;
boolean tick = false;
boolean tick2 = false;
PVector target;
PVector [] safeSpots = {new PVector(40,40), new PVector(560,40), new PVector(40,560), new PVector(560,560)};
int ghostNum = 2;

void setup() {
    size(600,600);
    frameRate(30);
    time = millis();
    time2 =  millis();
    pacMap = loadImage("test2.png");
    pacman = new Agent(300,460); 
    setupDots();
    setupSuperDots();
    ghostColor = (#ff0000);
    playerghost = new Agent(340,240,ghostColor);
    ghostColor = (#ffff00);
    aighost = new Agent(280,240, ghostColor);
}

void draw(){
  //println(millis(), time5);
  if(onPlay == PLAY){
    image(pacMap, 0, 0);
    //draw all dots  
    for(int i = 0; i < dots.size(); i++){
      dots.get(i).draw();
      //fill(#ff0000);
      //textSize(10);
      //text(i, dots.get(i).pos.x, dots.get(i).pos.y);  //debug to see the index of all dots
    }
    //draw the agents
    if (chaseMode == false){
      playerghost.setCol(#ff0000);
      aighost.setCol(#ffff00);
      aighost.drawGhost();
      playerghost.drawGhost();
    }
    if (chaseMode == true){
      if(millis() - time4 >= 500){
        tick = !tick;
        playerghost.setCol(tick ? #0000ff : #ffffff);
        aighost.setCol(tick ? #0000ff : #ffffff);
        time4 = millis();
      }
      aighost.drawGhost();
      playerghost.drawGhost();
    }
      pacman.drawPac();
    
    
    //if pacman is on top of a dot, he eats it.
    for (int i = 0; i < dots.size(); i++){
      isEaten = dots.get(i);
      if(isEaten.eaten(pacman.getPos()) == 1){
        dots.remove(i);
      }
      else if(isEaten.eaten(pacman.getPos()) == 2){
        dots.remove(i);
        if(ghostNum > 0){
          dangerMode = false;
          chaseMode = true;
          tick2 = true;
          time3 = millis();
        }
      }
    }
  }
  //AI movement
  if (chaseMode != true && dangerMode == false){
    dangerMode = percieveDanger();
  }
  if(onPlay == PLAY){
    if (chaseMode != true){
      if(millis() - time >= wait){
        if(dangerMode != true){
          pacman.bfstest();
          findCloseDot();
          pacman.buildPath(close.getPos());
          pacman.moveToPath();
          pacman.checkDir();
          if (millis() - time5 >= wait){
            pacman.drawPac_dir();
            time5 = millis();
          }
          pacman.clearPath();
          //println("pacman: "+pacman.getPos());
          time = millis();
        }
        if (dangerMode == true){
          pacman.bfstest();
          findSuperDot();
          pacman.buildPath(close.getPos());
          pacman.moveToPath();
          if (millis() - time5 >= wait){
            pacman.drawPac_dir();
            time5 = millis();
          }
          pacman.clearPath();
          //println("pacman: "+pacman.getPos());         
          time = millis();
        }
      }
    }
    
    if (chaseMode == true){
      if(millis() - time >= wait){
        pacman.bfstest();
        findTarget();
        pacman.buildPath(target);
        pacman.moveToPath();
        if (millis() - time5 >= wait){
          pacman.drawPac_dir();
          time5 = millis();
        }
        pacman.clearPath();
        time = millis();
        
        if(millis() - time3 > 5000){
          chaseMode = false;
        }
      }
    }
    //ai ghost movements
    if(aighost.getEat() != true){
      if (chaseMode != true){
        if(millis() - time2 >= wait2){
          aighost.bfstest();
          aighost.buildPath(pacman.getPos());
          aighost.moveToPath();
          aighost.clearPath();
          time2 = millis();
        }
      }
      if (chaseMode == true){
        if(millis() - time2 >= wait2){
          aighost.bfstest();
          aighost.buildPath(determineSafeSpot());
          aighost.moveToPath();
          aighost.clearPath();
          time2 = millis();
        }
      }
    }    
  }
  checkPlayer();
  checkGhost();
  pacmanWin();
  if(onPlay == PACMANWIN){
    fill(#000000);
    rect(0,0,600,600);
    fill(#ffffff);
    textSize(64);
    text("PACMAN WINS!", 65, 300);
  }
  else if(onPlay == GHOSTWIN){
    fill(#000000);
    rect(0,0,600,600);
    fill(#ffffff);
    textSize(64);
    text("YOU WIN!", 150, 300);
  }
}//end of draw

void keyReleased() {
  if ( key == CODED ) {
    switch ( keyCode ) {
    case UP:
      playerghost.movePac( NORTH );
      //println("player: "+playerghost.getPos());
      break;
    case DOWN:
      playerghost.movePac( SOUTH );
      //println(playerghost.getPos());
      break;
    case LEFT:
      playerghost.movePac( WEST );
      //println(playerghost.getPos());
      break;
    case RIGHT:
      playerghost.movePac( EAST );
      //println(playerghost.getPos());
      break;
    }
  }
}// end of keyReleased()

void setupDots(){
  for(int x = dotx; x < 580; x+=20){
    for(int y = doty; y < 580; y+=20){
      if ((y==40 && (x != 280 && x != 300 && x != 320)) || 
      (y==60 && (x == 40 || x == 120 || x == 260 || x == 340 || x == 480 || x == 560)) ||
      (y==80 && (x == 40 || x == 120 || x == 260 || x == 340 || x == 480 || x == 560)) ||
      (y==100 && (x == 40 || x == 120 || x == 260 || x == 340 || x == 480 || x == 560))||
      (y==120) ||
      (y==140 && (x == 40 || x == 120 || x == 180  || x == 420 || x == 480 || x == 560))||
      (y==160 && (x == 40 || x == 120 || x == 180 || x == 420 || x == 480 || x == 560)) ||
      (y==180 && (x != 140 && x != 160 && x != 280 && x != 300 && x != 320 && x != 440&& x != 460)) ||
      ((y>=200 && y < 380) && (x == 120 || x == 480)) ||
      (y==380 && (x <= 120 || x >= 480)) ||
      (y==400 && (x == 40 || x == 120 || x == 480 || x == 560)) ||
      (y==420 && (x != 60 && x != 80  && x != 100 && x != 260 && x != 280 && x != 300 && x != 320 && x != 340 && x != 500 && x != 520 && x != 540)) ||
      (y==440 && (x != 80 && x != 100 && x != 140 && x != 160 && x != 180 && x != 200 && x != 220 && x != 260 && x != 280 && x != 300 && x != 320 && x != 340 && x != 380 && x != 400 && x != 420 && x != 440 && x != 460 && x != 500 && x != 520)) ||
      (y==460 && (x == 60 || x == 120 || (x > 220 && x < 380) || x == 480 || x == 540)) ||
      (y==480 && (x == 60 || (x > 100 && x < 260) || (x > 340 && x < 500) || x == 540)) ||
      (y==500 && ((x > 20 && x < 140) || x == 240 || x == 360 || x > 460)) ||
      (y==520 && (x == 40 || x == 240 || x == 360 || x == 560)) ||
      (y==540 && (x == 40 || x == 240 || x == 360 || x == 560)) ||
      (y==560)
      ){
        dots.add(new Dot(x, y));
      }
    }
  }
}

void setupSuperDots(){
  int superx = int(dots.get(4).pos.x);
  int supery = int(dots.get(4).pos.y);
  dots.set(4, new Dot(superx, supery, 1));
  superx = int(dots.get(219).pos.x);
  supery = int(dots.get(219).pos.y);
  dots.set(219, new Dot(superx, supery, 1));
  superx = int(dots.get(11).pos.x);
  supery = int(dots.get(11).pos.y);
  dots.set(11, new Dot(superx, supery, 1));
  superx = int(dots.get(226).pos.x);
  supery = int(dots.get(226).pos.y);
  dots.set(226, new Dot(superx, supery, 1));
}

void findCloseDot(){
  if(dots.size() > 0){
    close = dots.get(dots.size()-1);
      for (int i = 0; i < dots.size(); i++){
        if((dist(pacman.pos.x, pacman.pos.y, close.pos.x, close.pos.y) > dist(pacman.pos.x, pacman.pos.y, dots.get(i).pos.x, dots.get(i).pos.y)))
        {
          //println("close was: " + close.getPos());
          close = dots.get(i);
          //print(" close is now: " + close.getPos() +"\n");
        }
      }
  }
}

void findSuperDot(){
  if(dots.size() > 0){
    close = dots.get(dots.size()-1);
      for (int i = 0; i < dots.size(); i++){
        if((dist(pacman.pos.x, pacman.pos.y, close.pos.x, close.pos.y) > dist(pacman.pos.x, pacman.pos.y, dots.get(i).pos.x, dots.get(i).pos.y)))
        {
          //println("close was: " + close.getPos());
          if(dots.get(i).isSuperDot())
            close = dots.get(i);
          //print(" close is now: " + close.getPos() +"\n");
        }
      }
  }
}
  
boolean percieveDanger(){  
  if(dist(pacman.pos.x, pacman.pos.y, aighost.pos.x, aighost.pos.y) < 100 || dist(pacman.pos.x, pacman.pos.y, playerghost.pos.x, playerghost.pos.y) < 100){
    //println("DANGER");
    return true;
  }
  return false;
}

void checkGhost(){
  if (chaseMode == false){
    if((pacman.getPos() == aighost.getPos())){
      onPlay = GHOSTWIN;
      //println("ghost win");
    }
  }
  if (chaseMode == true){
    if((pacman.getPos() == aighost.getPos())){
      aighost.setEat();
      //println("ghost got eaten");
      aighost.setPos(new PVector(999,999));
      ghostNum--;
    }
  }
}

void checkPlayer(){
  if (chaseMode == false){  
    //println("pacman: " + pos1 + " player: " + pos2);
    if(((int(pacman.getPos().x) == int(playerghost.getPos().x)) && (int(pacman.getPos().y) == int(playerghost.getPos().y)))){
      //println("pls");
      onPlay = GHOSTWIN;
    }  
  }
  if (chaseMode == true){
    if(((int(pacman.getPos().x) == int(playerghost.getPos().x)) && (int(pacman.getPos().y) == int(playerghost.getPos().y)))){
      playerghost.setEat();
      playerghost.setPos(new PVector(999,999));
      ghostNum--;
    }
  }
}

void findTarget(){
  if (dist(pacman.pos.x, pacman.pos.y, playerghost.pos.x, playerghost.pos.y) < dist(pacman.pos.x, pacman.pos.y, aighost.pos.x, aighost.pos.y)){
    if(playerghost.getEat() != true){
      target = playerghost.getPos();
      return;
    }
  }
  if(aighost.getEat() != true)
    target = aighost.getPos();
}

PVector determineSafeSpot(){
  if(pacman.pos.x < 300 && pacman.pos.y < 300)
    return safeSpots[3];
  else if(pacman.pos.x >= 300 && pacman.pos.y < 300)
    return safeSpots[2];
  else if(pacman.pos.x < 300 && pacman.pos.y >= 300)
    return safeSpots[1];
  return safeSpots[0];
}

void pacmanWin(){
  if (ghostNum == 0){
    onPlay = PACMANWIN;
  }
  if (dots.isEmpty()){
    onPlay = PACMANWIN;
  }
}