int bufferSize = width * height;
Player player = new Player(new PVector(303, 401));
Game game = new Game(player, scene);
PImage imageData = createImage(900, 900, RGB);
color[] buffer = new color[900*900];
void setup() {
    size(900, 900);
    frameRate(300);
    println(player.getFOVangle());
}
void draw() {
    background(18, 18, 18);

    game.fovRays(false);
 
    renderBuffer();
   
    drawFPS();
    scale(0.35);
    translate(50, 50 );
    game.drawGrid();
    game.drawPlayer();
    

}
void keyPressed() {
    player.move(key);
}
void renderBuffer(){
    imageData.loadPixels();
    for(int i = 0; i < imageData.pixels.length; i++){
        imageData.pixels[i] = buffer[i];
    }
    imageData.updatePixels();
    image(imageData, 0, 0);
    cleanBuffer();
}
void cleanBuffer(){
    buffer = new int[900*900];
//   for(int i = 0; i < buffer.length; i++){
//         buffer[i] = color(0,0,0);
//     }
}
