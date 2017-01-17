class Dot {
  PVector pos;
  int d = 5;
  int superDot;
  
  Dot(float x0, float y0){
    pos = new PVector(x0, y0);
    superDot = 0;
  }
  
  Dot(float x0, float y0, int superDot){
    pos = new PVector(x0, y0);
    this.superDot = 1;
  }
  
  PVector getPos(){
    return(pos);
  }
  
  boolean isSuperDot(){
    if (superDot == 1)
      return true;
    return false;
  }
    
  void draw(){
    if (superDot == 1){
      fill(#FFFFFF);
      stroke(255,255,255);
      strokeWeight(5);
      ellipse(pos.x, pos.y, d, d);
    }
    else{
      fill(#FFFFFF);
      stroke(255,255,255);
      strokeWeight(0);
      ellipse(pos.x, pos.y, d, d);
    }
  }
  
  int eaten(PVector pacpos){
    if ((((pacpos.x == pos.x)||(pacpos.x-10 == pos.x)||(pacpos.x+10 == pos.x)) && ((pacpos.y == pos.y)||(pacpos.y-10 == pos.y)||(pacpos.y+10 == pos.y)))&&(superDot == 1)){
      //println("superdot test");
      return 2;
    }
    else if (((pacpos.x == pos.x)||(pacpos.x-10 == pos.x)||(pacpos.x+10 == pos.x)) && ((pacpos.y == pos.y)||(pacpos.y-10 == pos.y)||(pacpos.y+10 == pos.y))){
      return 1;
    }
    return 0;
  }
  
};