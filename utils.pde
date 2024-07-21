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
    int offcet = ( x+ y * width);
    buffer[offcet] = col;
}
void drawLine(int x1, int y1, int y2, color col) {
  for (int y = y1; y < y2; y++) {
      drawPixel(x1, y, col);
  }
}
color getColor(int index){
switch ( index) {
   case 1 : return color(#292625); 
   case 2 : return color(50, 180, 180);
   case 3 : return color(120, 210, 180);
   case 4 : return color(150, 120, 180); 
   case 5 : return color(200, 190, 180); 
   default :
    return color(0, 50, 50);
}
}
color setBrightness(color col, float br)
{
    float h, s, b;
    h = hue(col);
    s = saturation(col);
    b = brightness(col);
    b *=br;
    return color(h,s,b);
}
