void setup()
{
    size(1024, 1024);
    background(#000020); //Have the background color to be dark blue using hex
    CreateStars(); //Draw all the stars
    
    //Draw the planets
    colorMode(RGB, 255, 255, 255); //Make sure you have the color mode on RGB
    DrawPlanet(256, 256, 256, 256, 0);
    DrawPlanet(896, 360, 128, 128, 1);
    DrawPlanet(768, 128, 96, 96, 2);
    DrawPlanet(544, 96, 64, 64, 3);
    DrawPlanet(704, 640, 64, 64, 4);
    DrawPlanet(288, 512, 64, 64, 5);
    
    DrawSatalight(); //Draw the satalight
}
 
void CreateStars() //Draw a lot of stars
{
    drawStar(64, 64, 8);
    drawStar(128, 48, 6);
    drawStar(96, 128, 8);
    drawStar(96, 256, 4);
    drawStar(448, 448, 8);
    drawStar(320, 544, 4);
    drawStar(256, 768, 6);
    drawStar(72, 448, 8);
    drawStar(640, 320, 6);
    drawStar(768, 48, 8);
    drawStar(960, 96, 6);
    drawStar(992, 32, 4);
    drawStar(704, 256, 8);
    drawStar(512, 160, 6);
    drawStar(384, 320, 8);
    drawStar(384, 320, 4);
    drawStar(256, 160, 8);
    drawStar(160, 384, 4);
}

void DrawPlanet(int x, int y, int w, int h, int index)
{
  //Create an array of colors for the planet to have with a specific index
  Color[] colors = {  new Color(255, 64, 128), 
  
                      new Color(255, 128, 0),
                      new Color(32, 255, 128),
                      new Color(64, 0, 255),
                      new Color(255, 255, 0),
                      new Color(128, 255, 0) };
  if(index >= colors.length)
    return;
  
  Color col = colors[index]; //Grab the color from the array
  strokeWeight(32);
  stroke(0, 0, 255, 64);
  fill(col.r, col.g, col.b);
  ellipse(x, y, w, h);
  
  switch(index)
  {
    case 0: //Have three rings around planet index 0
      noFill();
      stroke(col.r / 2, col.g / 2, col.b / 2, 128);
      
      strokeWeight(12);
      bezier(x - (w/2) - 16, y+16, x - (w/2) - 384, y - 16, x + (w/2) + 384, y - 16, x + (w/2) + 8, y+16);
      
      strokeWeight(8);
      bezier(x - (w/2), y - 32, x - (w/2) - 256, y - 64, x + (w/2) + 256, y - 64, x + (w/2), y - 32); 
      bezier(x - (w/2), y + 64, x - (w/2) - 256, y+32, x + (w/2) + 256, y+32, x + (w/2), y + 64); 
      break;
    case 1: //Have triangles all around planet index 1
      noStroke();
      fill(col.r / 2, col.g / 2, col.b / 2, 128);
      DrawTriangle(x+12, y+24, 32, 8);
      DrawTriangle(x-24, y-24, 24, -8);
      DrawTriangle(x+32, y-16, 16, 16);
      DrawTriangle(x-28, y+16, 16, 16);
      DrawTriangle(x+4, y-8, 16, 0);
      DrawTriangle(x+8, y-24, 8, 2);
      DrawTriangle(x+28, y+16, 8, 4);
      DrawTriangle(x-8, y+20, 8, 8);
    break;
    case 2: //Have planet with index 2 to have one ring
     noFill();
      stroke(col.r / 2, col.g / 2, col.b / 2, 128);
      
      strokeWeight(8);
      bezier(x - (w/2) - 8, y+16, x - (w/2) - 128, y - 16, x + (w/2) + 128, y - 16, x + (w/2) + 8, y+16);
    break;
    case 5: //Have planet with index 5 to have one ring
     noFill();
      stroke(col.r / 2, col.g / 2, col.b / 2, 128);
      
      strokeWeight(8);
      bezier(x - (w/2) - 8, y+16, x - (w/2) - 128, y - 16, x + (w/2) + 128, y - 16, x + (w/2) + 8, y+16);
    break;
    default: //Any other indexes get nothing
    break;
  }
}

void DrawSatalight()
{
  noStroke();
  colorMode(HSB, 360, 100, 100, 100); //Change color mode to HSB
  //Satalight stems
  fill(240, 100, 38);
  beginShape();
  vertex(448, 448);
  vertex(576, 576);
  vertex(640, 384);
  beginContour();
  vertex(608, 416);
  vertex(560, 560);
  vertex(464, 464);
  endContour();
  endShape(CLOSE);
  //Satalight ball
  fill(330, 100, 50);
  ellipse(640, 384, 32, 32);
  //Satalight dish
  fill(240, 100, 50);
  arc(512, 512, 256, 256, QUARTER_PI, 5 * QUARTER_PI, PIE);
  //Joints
  fill(240, 100, 25);
  ellipse(416, 608, 64, 64);
  quad(376, 704, 392, 704, 424, 608, 408, 608);
  ellipse(384, 704, 64, 64);
  quad(368, 704, 400, 704, 528, 768, 496, 768);
  ellipse(512, 768, 64, 64);
  //Building
  fill(240, 100, 38);
  quad(416, 768, 608, 768, 640, 832, 384, 832);
  quad(384, 1024, 640, 1024, 640, 832, 384, 832);
  //Rays
  noFill();
  stroke(330, 100, 50, 33);
  strokeWeight(16);
  bezier(544, 288, 640, 224, 800, 384, 736, 480);
  stroke(330, 100, 50, 66);
  strokeWeight(8);
  bezier(576, 320, 640, 256, 768, 384, 704, 448);
  stroke(330, 100, 50);
  strokeWeight(4);
  bezier(608, 352, 640, 288, 736, 384, 672, 416);
}

void drawStar(float x, float y, int w) //draws a star at x, y position with w for strokeWeight, and one across the (-x, -y) axis
{
    stroke(255);
    strokeWeight(w);
    point(x, y);
    point(width-x, height-y);
}

void DrawTriangle(int x, int y, int w, int r) //Draws a triangle at x, y position with w width and r rotation
{
  triangle(x - (w/2) + (r/2), y + (w/2) + (r/2), x + (w/2) + (r/2), y + (w/2) - (r/2), x - (r/2),  y - (w/2) + (r/4));
}

class Color //Color class to hold information on RGB color
{
  public int r; //Red
  public int g; //Green 
  public int b; //Blue
  public int a; //Alpha
  
  public Color() //Default constructor sets the color to white
  { 
    r = 255; g = 255; b = 255; a = 255;
  }
  
  public Color(int nR, int nG, int nB) //Gets parameters for red, green, and blue then sets the color to that value
  {
    r = nR; g = nG; b = nB; a = 255;
  }
  
  public Color(int nR, int nG, int nB, int nA) //Same as above but adds alpha
  {
    r = nR; g = nG; b = nB; a = nA;
  }
}
