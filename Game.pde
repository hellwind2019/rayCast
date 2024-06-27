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
        rayDir.mult(0.1);
        float angle = -fov / 2;
        rayDir.rotate(radians(angle));
        int optimization = 1;
        int raysCount = width/optimization;
        float angleStep = fov / raysCount;
        for (int i = 0; i < raysCount; i++) {
            strokeWeight(1);
            PVector pRayDir = PVector.add(player.pos, rayDir);
            stroke(#9D2525);
            //line(player.pos, pRayDir);
            rayDir.rotate(radians(angleStep));
            Ray ray = new Ray();
            ray.visible = isRayDraw;
            ray.cast(player.pos, pRayDir);
            if (ray.side == 1) stroke(200, 200, 200);
            if (ray.side == 0) stroke(100, 100, 100);
            drawVerticalLine(optimization*i, ray.length*0.05);
              
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
    void drawGrid() {
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
