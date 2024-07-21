public class Ray {
    float   length    = 99999;
    int     side      = 0;
    boolean visible   = false;
    int     rayColor  = 1; 
    PVector hitCell = new PVector();
    PVector hitCellXY = new PVector();
    public void cast(PVector p, PVector m) {
        PVector d = PVector.sub(m, p);
        PVector p1 = p.copy();
        float k;
        if (d.x != 0) k = d.y / d.x;
        else k = 99999999;
        float b = p.y - k * p.x;

        for (int i = 0; i < 40; ++i) {
            m = rayStep(m, d, b, k);
            int h = floor(m.x/level.cellSize);
            int w = floor(m.y/level.cellSize);
            if(level.outsideScene((int)p1.x, (int)p1.y)){
                p1 = m.copy();
                continue;
            }  
            if(level.outsideScene(w, h) || level.scene[w][h] != 0){
                PVector rayVector = PVector.sub(m, p); 
                PVector pDir = player.dir.copy().normalize();
                float perpWallDist = PVector.dot(rayVector, pDir); //Да как в конце концов считать расстояние
                this.length = perpWallDist;
                this.rayColor = level.scene[w][h]; 
                this.hitCell.set(w,h);
                this.hitCellXY.set(m);
                stroke(200, 10, 10);
                strokeWeight(0.2);
                line(p.x, p.y, m.x, m.y);
                return;
            }
        }
        return;
    }
    private PVector rayStep(PVector m, PVector d, float b, float k) { //Returns a next point on the grid
        float x1 = snap(m.x, d.x);
        float y1 = snap(m.y, d.y);
        float x = (y1 - b) / k;
        
        float y = k * x1 + b;
        float distX = dist(m.x, m.y, x1, y);
        float distY = dist(m.x, m.y, x, y1);
        
        if (distX <= distY) {
            this.side = 0;
            return new PVector(x1, y);
        }
        this.side = 1;
        return new PVector(x, y1);
    }
  private float snap(float p, float d) {
        
        if (d < 0) return floor(p/level.cellSize) *level.cellSize - 0.00001;
        if (d > 0) return ceil(p/level.cellSize) *level.cellSize + 0.00001;
        return 0;
}
}
