/* autogenerated by Processing revision 1293 on 2024-06-28 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class rayCast extends PApplet {

int bufferSize = width * height;
Player player = new Player(new PVector(303, 401));
Game game = new Game(player, scene);
PImage imageData = createImage(900, 900, RGB);
int[] buffer = new int[900*900];
public void setup() {
    /* size commented out by preprocessor */;
    frameRate(300);
    println(player.getFOVangle());
}
public void draw() {
    background(18, 18, 18);

    game.fovRays(false);
 
    renderBuffer();
   
    drawFPS();
    scale(0.35f);
    translate(50, 50 );
    game.drawGrid();
    game.drawPlayer();
    

}
public void keyPressed() {
    player.move(key);
}
public void renderBuffer(){
    imageData.loadPixels();
    for(int i = 0; i < imageData.pixels.length; i++){
        imageData.pixels[i] = buffer[i];
    }
    imageData.updatePixels();
    image(imageData, 0, 0);
    cleanBuffer();
}
public void cleanBuffer(){
    buffer = new int[900*900];
//   for(int i = 0; i < buffer.length; i++){
//         buffer[i] = color(0,0,0);
//     }
}
public class Game {
    Player player;
    int[][] scene;
    public Game(Player p, int[][] s) {
        player = p;
        scene = s;
    }
    public void fovRays(boolean isRayDraw) {
        PVector rayDir = player.dir.copy();
        float fov = player.getFOVangle();
        rayDir.mult(0.1f);
        float angle = -fov / 2;
        rayDir.rotate(radians(angle));
        int optimization = 1;
        int raysCount = width/optimization;
        float angleStep = fov / raysCount;
        for (int i = 0; i < raysCount; i++) {
            strokeWeight(1);
            PVector pRayDir = PVector.add(player.pos, rayDir);
            stroke(0xFF9D2525);
            //line(player.pos, pRayDir);
            rayDir.rotate(radians(angleStep));
            Ray ray = new Ray();
            ray.visible = isRayDraw;
            ray.cast(player.pos, pRayDir);
            if (ray.side == 1) stroke(200, 200, 200);
            if (ray.side == 0) stroke(100, 100, 100);
            drawVerticalLine(optimization*i, ray.length*0.05f);
              
            }
            
            
            
            
        }
        public void perpRays(boolean isRayDraw) {
        PVector camV = PVector.sub(player.camL, player.camR);
        float camVLen = camV.mag();
        PVector camVnorm = new PVector(camV.x, camV.y).normalize();
        float prevX = 0;
        for (int i = 0; i <=  camVLen; i++) {
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
            ray.cast(dotOnPlane, dirFromPoint);
            
            
            float x = map(i, 0, camVLen, 0, width);
            if (ray.side == 1) stroke(200, 200, 200);
            if (ray.side == 0) stroke(100, 100, 100);
            if (x > prevX) {
                for (int j = (int)prevX; j <x; j++) {
                   // drawVerticalLine(j, ray.length);
                }
            }
           // drawVerticalLine(x, ray.length);
            prevX = x;
        }
    }
    public void drawGrid() {
        int sh = scene.length;
        int sw = scene[0].length;
        int cs = height / sh;
        fill(40,40,40);
        stroke(0,0,0);
        rect(0, 0, sh*cs, sw*cs); 
        stroke(52, 52, 52);
        strokeWeight(3);
        for (int i = 0; i < sh; ++i) {
            int x = i * cs;
            line(x, height, x, 0);
        }
        for (int i = 0; i < sh; ++i) {
            int y = i * cs;
            line(2, y, sw*cs, y);
        }
        for (int i = 0; i < sh; ++i) {
            for (int j = 0; j < sw; ++j) {
                if (scene[j][i] != 0) {
                    fill(80, 80,80);
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
        line(player.pos,player.camL);
        line(player.pos,player.camR);
    }
}
public void drawVerticalLine(int x, float wallDist) {
    int lineHeight = (int)(height / wallDist);
    int drawStart = -lineHeight / 2 + height / 2;
    if (drawStart < 0) drawStart = 0;
    int drawEnd = lineHeight / 2 + height / 2;
    if (drawEnd >= height) drawEnd = height - 1;
   // strokeWeight(5);
   // line(x, drawStart, x, drawEnd);
   drawLine(x, drawStart, drawEnd, color(50, 50, 50));
}
public class Player{
    PVector pos;
    PVector dir = new PVector(0, 45);
    PVector cam = new PVector(30, 0);
    PVector pDir;
    PVector camL;
    PVector camR;
    float rotSpeed = PI/2 * 0.1f;
    float movSpeed = 0.3f;
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
public class Ray {
  float length = 0;
  int side = 0;
  boolean visible = false;
  
  public void cast(PVector p, PVector direction) {
    fill(50, 200, 50);
    PVector m = direction;
    stroke(50, 200, 50);
    if (visible)line(p.x, p.y, m.x, m.y);
    PVector d = PVector.sub(m, p);
    float k;
    if (d.x != 0) k = d.y / d.x;
    else  k = 999999999;

    float b = p.y - k * p.x;
    for (int i = 0; i < 15; ++i) {
      float x1 = snap(m.x, d.x);
      float y1 = snap(m.y, d.y);
      float x = (y1 - b) / k;

      float y = k * x1 + b;
      float distX = dist(m.x, m.y, x1, y);
      float distY = dist(m.x, m.y, x, y1);//

      fill(200, 10, 10);
      noStroke();
      if (distX <= distY) {
        stroke(10, 200, 10);
        if (visible) line(m.x, m.y, x1, y);

        m = new PVector(x1, y);
        side = 0;
      } else {
        stroke(10, 200, 10);
        if (visible) line(m.x, m.y, x, y1);
        m = new PVector(x, y1);
        side = 1;
      }
      float cs = cellSize(scene);
      int h = floor(m.x / cs);
      int w = floor(m.y / cs);

      if (h < 0 || w < 0 || h >=  scene.length || w >= scene.length ||scene[w][h] != 0) {
        length = dist(p.x, p.y, m.x, m.y);
        if (visible) circle(m.x, m.y, 2);

        return;
      }
    }
    return;
  }
  private float snap(float p, float d) {
    float cs = cellSize(scene);
    if (d < 0) return floor(p / cs) * cs - 0.1f;
    if (d > 0) return ceil(p / cs) * cs + 0.1f;
    return 0;
  }
}

public static  int[][] scene = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1} ,
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1} ,
    {1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1} ,
    {1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1} ,
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1} ,
    {1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1} ,
    {1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1} ,
    {1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1} ,
    {1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1} ,
    {1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1} ,
    {1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1} ,
    {1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1} ,
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1} ,
    {1, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1} ,
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1} ,
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
};
public void print2(float a, float b){ 
 print(a);
 print('\t');
 println(b);
}
public float cellSize(int[][] scene) {
  int sh = scene.length;
  int sw = scene[0].length;
  int cs = height / sh;
  return cs;
}
public void line(PVector p1, PVector p2) {
  line(p1.x, p1.y, p2.x, p2.y);
}
public void drawFPS() {
  int fps = (int)frameRate;
  text(fps, 10, 10);
}
public void drawPixel(int x, int y, int col) {
    int offcet = (x + y * height);
    buffer[offcet] = col;
    
    
}
public void drawLine(int x1, int y1, int y2, int col) {
    for (int y = y1; y < y2; y++) {
        drawPixel(x1, y, col);
    }
}


  public void settings() { size(900, 900); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "rayCast" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
