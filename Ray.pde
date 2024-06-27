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
    if (d < 0) return floor(p / cs) * cs - 0.1;
    if (d > 0) return ceil(p / cs) * cs + 0.1;
    return 0;
  }
}
