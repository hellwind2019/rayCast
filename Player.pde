public class Player{
    PVector pos;
    PVector dir = new PVector(0, 45);
    PVector cam = new PVector(30, 0);
    PVector pDir;
    PVector camL;
    PVector camR;
    float rotSpeed = PI/2 * 0.1;
    float movSpeed = 0.3;
    public Player(PVector _pos) {
        pos = _pos;
        
        pDir = PVector.add(pos, dir);
        camL = PVector.add(pDir, cam);
        camR = PVector.sub(pDir, cam);
    }
    public float getFOVangle(){
        float dirLen = this.dir.mag();
        float camPlaneLen = this.cam.mag();
        float FOV = degrees(2*atan(camPlaneLen/dirLen));
        return  FOV; 
    }
    public void move(char key){
        if(key == 'w' || key == 'W' || key == 'ц') {
        pos.x += dir.x * movSpeed;
        pos.y += dir.y * movSpeed;
    }
    if(key == 's' || key == 'S'|| key == 'і') {
        pos.x -= dir.x * movSpeed;
        pos.y -= dir.y * movSpeed;
    }
    if(key == 'a' || key == 'A'|| key == 'ф') {
        dir.rotate(-rotSpeed);
        cam.rotate(-rotSpeed);
    }
    if(key == 'd' || key == 'D'|| key == 'в') {
        dir.rotate( rotSpeed);
        cam.rotate( rotSpeed);
    }
     pDir = PVector.add(pos, dir);
     camL = PVector.add(pDir, cam);
     camR = PVector.sub(pDir, cam);
    }
}
