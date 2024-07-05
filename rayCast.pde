import java.awt.Robot;
Robot robot;
float currentRotationX = 0;
float mouseDist = 0;
float sens = 30;
final int SCREEN_HEIGHT = 600;
final int SCREEN_WIDTH = 900;
int bufferSize = width * height;
Player player = new Player(new PVector(181, 395));
Game game = new Game(player, scene);
PImage imageData = createImage(SCREEN_WIDTH, SCREEN_HEIGHT, RGB);
color[] buffer = new color[SCREEN_HEIGHT * SCREEN_WIDTH];

boolean threadFlag = true;
void settings() {
    size(SCREEN_WIDTH, SCREEN_HEIGHT);
    
}
void setup() {
  surface.setLocation((displayWidth / 2) - (width / 2),(displayHeight / 2) - (height / 2));
  frameRate(80);
  println(player.getFOVangle());
  try {
      robot = new Robot();
    }
  catch(Throwable e) {
}
}
void draw() {
    background(18, 18, 18);
    
    
    game.fovRaysFishEyeCorr(false);
    game.handlePlayerMovement();
    renderBuffer();
    
    scale(0.35);
    translate(50, 50);
    game.drawGrid();
    game.drawPlayer();
    scale(4);
    drawFPS();
    
}

void mouseMoved() { 
    mouseDist = mouseX - width / 2 + 9;
    currentRotationX += mouseDist / sens;
    player.rotateToAngle(mouseDist / sens);
    robot.mouseMove(displayWidth / 2, displayHeight / 2);
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
