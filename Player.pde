public class Player {
  PVector pos;
  PVector dir = new PVector(0, 0.4);
  PVector cam = new PVector(0.4, 0);
  PVector pDir;
  PVector camL;
  PVector camR;
  float rotSpeed = PI/2 * 0.1;
  float movSpeed = 0.01;
  float diagSpeedFactor = 1.5;

  public Player(PVector _pos) {
    pos = _pos;

    pDir = PVector.add(pos, dir);
    camL = PVector.add(pDir, cam);
    camR = PVector.sub(pDir, cam);
  }
  public float getFOVangle() {
    float dirLen = this.dir.mag();
    float camPlaneLen = this.cam.mag();
    float FOV = degrees(2*atan(camPlaneLen/dirLen));
    return  FOV;
  }
  public void rotateToAngle(float angle) {
    dir.rotate(radians(angle));
    cam.rotate(radians(angle));
  }
  public void move(Keys keys) {
    float deltaMovSpeed = movSpeed*(delta);
    if(keys.getPressedKeysCount() <=1){
      if (keys.up.active) {
          pos.x += dir.x * deltaMovSpeed;
          pos.y += dir.y * deltaMovSpeed;
        }
        if (keys.down.active) {
          pos.x -= dir.x * deltaMovSpeed;
          pos.y -= dir.y * deltaMovSpeed;
        }
        if(keys.left.active) { 
          PVector temp = dir.copy();
          temp.rotate(radians(-90));
          pos.x += temp.x * deltaMovSpeed;
          pos.y += temp.y * deltaMovSpeed;
        }
          if(keys.right.active) { 
          PVector temp = dir.copy();
          temp.rotate(radians(90));
          pos.x += temp.x * deltaMovSpeed;
          pos.y += temp.y * deltaMovSpeed;
        }
    }else{
      if(keys.up.active && keys.left.active){
         PVector temp = dir.copy();
         temp.rotate(radians(-45));
         pos.x += temp.x * deltaMovSpeed*diagSpeedFactor;
         pos.y += temp.y * deltaMovSpeed*diagSpeedFactor;
      }
      if(keys.up.active && keys.right.active){
         PVector temp = dir.copy();
         temp.rotate(radians(45));
         pos.x += temp.x * deltaMovSpeed*diagSpeedFactor;
         pos.y += temp.y * deltaMovSpeed*diagSpeedFactor;
      }
    }
    

    
   
    pDir = PVector.add(pos, dir);
    camL = PVector.add(pDir, cam);
    camR = PVector.sub(pDir, cam);
  }
 }
