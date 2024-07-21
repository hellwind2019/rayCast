public int RAYS_FACTOR = 1;  
public class Game {
  Player player;
  int[][] scene;
  Keys keys;
  public Game(Player p, int[][] s) {
    player = p;
    scene = s;
    keys = new Keys();
  }
  public void handlePlayerMovement() {
    player.move(keys);
  }
  public void handlePressedKeys(char key) {
    if (key == 'w' || key == 'W'|| key == 'ц') keys.up.active    = true;
    if (key == 's' || key == 'S'|| key == 'і') keys.down.active  = true;
    if (key == 'a' || key == 'A'|| key == 'ф') keys.left.active  = true;
    if (key == 'd' || key == 'D'|| key == 'в') keys.right.active = true;
  }
  public void handleReleasedKeys(char key) {
    if (key == 'w' || key == 'W'|| key == 'ц') keys.up.active    = false;
    if (key == 's' || key == 'S'|| key == 'і') keys.down.active  = false;
    if (key == 'a' || key == 'A'|| key == 'ф') keys.left.active  = false;
    if (key == 'd' || key == 'D'|| key == 'в') keys.right.active = false;
  }

   public void fovRaysFishEyeCorr(boolean isVisible) {
    int RAYS_COUNT =300; //width/RAYS_FACTOR;
    //TODO: Make a way to correct resolution, RAYS_FACTOR is a bad way, have to use like fractional part 
    colorMode(HSB);
    for (int i = 0; i < RAYS_COUNT; i++) {
      float t = i/(float)RAYS_COUNT;
      t=0.5;
      PVector planePoint = PVector.lerp(player.camL, player.camR, t);
      PVector dirPoint = PVector.lerp(player.pos, planePoint, 0.1);
      Ray ray = new Ray();
      ray.visible = isVisible;
      ray.cast(player.pos, dirPoint);
      float brScale = 1;
      if (ray.side == 1) brScale = 1;
      if (ray.side == 0) brScale = 0.5;
      float brightness = map(ray.length, height/2, 0, 0, 1);
      color col =  setBrightness(getColor(ray.rayColor), brightness*brScale);

      
      drawVerticalLine(i*RAYS_FACTOR, ray.length,col );
      drawTexturedLine(i*RAYS_FACTOR, ray );
    }
   colorMode(RGB);
  }
 
  void drawGrid() {
     noStroke();
    
    fill(50, 50, 50);
    rect(0,0, level.width, level.height);
    
    strokeWeight(0.05);
    stroke(0,0,0);

    for (int i = 0; i <= level.width; i++) {
        line(i, 0, i, level.height);
    }
    for (int i = 0; i <= level.height; i++) {
        line(0, i, level.width,i);
    }
    for (int i = 0; i < level.width; ++i) {
        for (int j = 0; j < level.height; ++j) {
        if(level.scene[j][i] != 0){
            color wallColor = getColor(level.scene[j][i]);
            fill(wallColor);
            rect(i, j, 1, 1);

        }
    }
    }
  }
  public void drawPlayer() {
    fill(200, 50, 50);
    circle(player.pos.x, player.pos.y, 0.3);
    stroke(50, 30, 180);
    line(player.camL, player.camR);
    stroke(180, 30, 30);
    line(player.pos, player.camL);
    line(player.pos, player.camR);
  }
}
public void drawTexturedLine(int x, Ray ray){
  float wallDist = ray.length;
  int lineHeight = (int)(height / wallDist);
  int drawStart = -lineHeight / 2 + height / 2;
  if (drawStart < 0) drawStart = 0;
  int drawEnd = lineHeight / 2 + height / 2;
  if (drawEnd >= height) drawEnd = height - 1;

  PImage wall = level.getWall((int)ray.hitCell.x, (int)ray.hitCell.y);
  println(ray.hitCellXY.x +" " + ray.hitCellXY.y);
  for(int y = drawStart; y <=drawEnd; y++){

  }

}
public void drawVerticalLine(int x, float wallDist, color col) {
  int lineHeight = (int)(height / wallDist);
  int drawStart = -lineHeight / 2 + height / 2;
  if (drawStart < 0) drawStart = 0;
  int drawEnd = lineHeight / 2 + height / 2;
  if (drawEnd >= height) drawEnd = height - 1;
  
  drawLine(x, 0, drawStart, color(100, 50, 150));
  // drawLine(x, drawStart, drawEnd, col);
  drawLine(x, drawEnd, height, color(159, 25, 150));
}
