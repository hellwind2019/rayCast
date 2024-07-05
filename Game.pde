
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

  public void fovRays(boolean isRayDraw) {
    colorMode(HSB);
    PVector rayDir = player.dir.copy();
    float fov = player.getFOVangle();
    rayDir.mult(0.1);
    float angle = -fov / 2;
    rayDir.rotate(radians(angle));
    int raysCount = width;
    float angleStep = fov / raysCount;
    for (int i =0; i < raysCount; i++) {
      strokeWeight(1);
      PVector pRayDir = PVector.add(player.pos, rayDir);
      stroke(#9D2525);
      //line(player.pos, pRayDir);
      rayDir.rotate(radians(angleStep));
      angle+=angleStep;
      Ray ray = new Ray();
      ray.visible = isRayDraw;
      ray.cast(player.pos, pRayDir);
      float brightness = 1;
      if (ray.side == 1) brightness = 1;
      if (ray.side == 0) brightness = 0.5;

      drawVerticalLine(i, ray.length, setBrightness(getColor(ray.rayColor), brightness));
    }
    colorMode(RGB);
  }
  public void fovRaysFishEyeCorr(boolean isVisible) {
    int RAYS_COUNT = width;
    colorMode(HSB);
    for (int i = 0; i < RAYS_COUNT; i++) {
      float t = i/(float)RAYS_COUNT;
      PVector planePoint = PVector.lerp(player.camL, player.camR, t);
      PVector dirPoint = PVector.lerp(player.pos, planePoint, 0.1);
      Ray ray = new Ray();
      ray.visible = isVisible;
      ray.cast(player.pos, dirPoint);
      float brScale = 1;
      if (ray.side == 1) brScale = 1;
      if (ray.side == 0) brScale = 0.5;
      float brightness = map(ray.length, height/2, 0, 0, 1);
      
      drawVerticalLine(i, ray.length, setBrightness(getColor(ray.rayColor), brightness*brScale));
    }
   colorMode(RGB);
  }
  public void perpRays(boolean isRayDraw) {
    int RAYS_COUNT = 300;
    PVector camV = PVector.sub(player.camL, player.camR);
    float camVLen = camV.mag();
    PVector camVnorm = new PVector(camV.x, camV.y).normalize();
    for (int i = 0; i >  width; i--) {

      strokeWeight(3);
      stroke(255, 255, 255);
      PVector dotOnPlane = new PVector(player.camR.x + i * camVnorm.x, player.camR.y + i * camVnorm.y);

      PVector dirNorm = new PVector(player.dir.x, player.dir.y).normalize();
      PVector dirFromPoint = PVector.add(dirNorm, dotOnPlane);
      if (isRayDraw) {
        point(dotOnPlane.x, dotOnPlane.y);
        point(dirFromPoint.x, dirFromPoint.y);
      }
      Ray ray = new Ray();
      ray.visible = isRayDraw;
      ray.cast(player.pos, dotOnPlane);


      int x = (int)map(i, 0, 100, 0, width);
      float brightness = 1;
      if (ray.side == 1) brightness = 1;
      if (ray.side == 0) brightness = 0.5;
      drawVerticalLine(x, ray.length, setBrightness(getColor(ray.rayColor), brightness));
    }
  }
  void drawGrid() {
    int sh = scene.length;
    int sw = scene[0].length;
    int cs = height / sh;
    fill(40, 40, 40);
    stroke(0, 0, 0);
    rect(0, 0, sh * cs, sw * cs);
    stroke(52, 52, 52);
    strokeWeight(3);
    for (int i = 0; i < sh; ++i) {
      int x = i * cs;
      line(x, height, x, 0);
    }
    for (int i = 0; i < sh; ++i) {
      int y = i * cs;
      line(2, y, sw * cs, y);
    }
    for (int i = 0; i < sh; ++i) {
      for (int j = 0; j < sw; ++j) {
        if (scene[j][i] != 0) {
          fill(80, 80, 80);
          noStroke();
          rect(i * cs, j * cs, cs, cs);
        }
      }
    }
  }
  public void drawPlayer() {
    fill(200, 50, 50);
    circle(player.pos.x, player.pos.y, 30);
    stroke(50, 30, 180);
    line(player.camL, player.camR);
    stroke(180, 30, 30);
    line(player.pos, player.camL);
    line(player.pos, player.camR);
  }
}
public void drawVerticalLine(int x, float wallDist, color col) {
  int lineHeight = (int)(height / wallDist*10);
  int drawStart = -lineHeight / 2 + height / 2;
  if (drawStart < 0) drawStart = 0;
  int drawEnd = lineHeight / 2 + height / 2;
  if (drawEnd >= height) drawEnd = height - 1;
  // line(x, drawStart, x, drawEnd);
  drawLine(x, drawStart, drawEnd, col);
}
