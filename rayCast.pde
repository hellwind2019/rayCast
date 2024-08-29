import java.awt.Robot;
Robot robot;
float currentRotationX = 0;
float mouseDist = 0;
float sens = 1/30.0;
final int SCREEN_HEIGHT = 600;
final int SCREEN_WIDTH = 900;
float MINMAP_SCALE = 15;
int bufferSize = width * height;
Player player = new Player(new PVector(3.5, 3.5));
Level level;
Game game;

PImage imageData = createImage(SCREEN_WIDTH, SCREEN_HEIGHT, RGB);
color[] buffer = new color[SCREEN_HEIGHT * SCREEN_WIDTH];
int lastTime = 0;
int delta = 0;
int halfWidth, halfHeight;
boolean threadFlag = true;
PImage wall;
void settings() {
    size(SCREEN_WIDTH, SCREEN_HEIGHT);
}
void setup() {
    wall = loadImage("assets/troll.jpg");
    level = new Level(sceneArray, wall);
    game = new Game(player, level.scene);
    halfHeight =(int)(displayHeight*0.5);
    halfWidth =(int)(displayWidth *0.5);
   surface.setLocation((displayWidth / 2) - (width / 2),(displayHeight / 2) - (height / 2));
  frameRate(300);
  println(player.getFOVangle());
  try {
      robot = new Robot();
    }
  catch(Throwable e) {
}
   robot.mouseMove(displayWidth / 2, displayHeight / 2);
}
void draw() {
    delta = millis() - lastTime;
    background(18, 18, 18);
  
    renderBuffer();
    scale(MINMAP_SCALE);
    game.drawGrid();
    game.drawPlayer();
    game.fovRaysFishEyeCorr(true);
    scale(1/MINMAP_SCALE);

    game.handlePlayerMovement();



    scale(4);
    drawFPS();

    lastTime = millis();    
}

void mouseMoved() { 
    if(!(mouseX >= displayWidth/2 + width/2)){
        mouseDist = mouseX - width / 2 + 9;
        player.rotateToAngle(mouseDist*sens);
    }
  robot.mouseMove(halfWidth, halfHeight);
}
void keyPressed() {
    game.handlePressedKeys(key);
}
void keyReleased() {
    game.handleReleasedKeys(key); 
}
void renderBuffer() {
    imageData.loadPixels();
    for (int i = 0; i < imageData.pixels.length; i++) {
        imageData.pixels[i] = buffer[i];
}
    imageData.updatePixels();
    image(imageData, 0, 0);
    cleanBuffer();
}
void cleanBuffer() {
    buffer = new int[SCREEN_WIDTH * SCREEN_HEIGHT];
    
}
