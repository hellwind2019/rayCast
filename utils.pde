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
void line(PVector p1, PVector p2) {
  line(p1.x, p1.y, p2.x, p2.y);
}
void drawFPS() {
  int fps = (int)frameRate;
  text(fps, 10, 10);
}
void drawPixel(int x, int y, color col) {
    int offcet = (x + y * height);
    buffer[offcet] = col;
    
    
}
void drawLine(int x1, int y1, int y2, color col) {
    for (int y = y1; y < y2; y++) {
        drawPixel(x1, y, col);
    }
}