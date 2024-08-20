public class Level {
    int[][] scene;
    int cellSize = 1;
    int height;
    int width;
    PImage wall1;
    public Level(int[][] scene, PImage wall1) {
        this.scene = scene;
        this.height = scene.length;
        this.width = scene[0].length;
        this.wall1 = wall1; 
    }
    public boolean outsideScene(int h, int w){
        return h < 1 || w < 1 || h>= this.height-1 || w >= this.width-1;
    }
    public PImage getWall(int x, int y){
        //Maybe swap X Y
        if(this.scene[x][y] != 0){
            return this.wall1;
        }
        return new PImage(0,0);
    } 
}