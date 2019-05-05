int sunDrop = 48; //The y-coordinate of the sun
int sunSize = 64; //The radius of the sun
int bColor = 64; //background color
int change = 32; //color and size change for the sunrays
int limit = (256 - bColor) / change; //limit for the sunrays (so the rays don't go darker than the background)
float growth = 6.4f; //multiplier for the sunrays growth

//Setup the scene
void setup()
{
  size(1024, 512);
  background(bColor); 
  drawSun();
  
  
  drawMonorail();
  
  //Draw the back layer buildings
  drawBuilding(-192, 128, 240, 2, 2);
  drawBuilding(192, 128, 240, 2, 2);
  
  //Draw the middle layer buildings
  drawBuilding(-140, 128, 128, 2, 1);
  drawBuilding(140, 128, 128, 2, 1);
  drawBuilding(-360, 128, 240, 2, 1);
  drawBuilding(360, 128, 240, 2, 1);
  
  //Draw the front layer buildings
  drawBuilding(0, 128, 240, 2, 0);
  drawBuilding(-224, 160, 160, 3, 0);
  drawBuilding(224, 160, 160, 3, 0);
  drawBuilding(448, 96, 160, 2, 0);
  drawBuilding(-448, 96, 160, 2, 0);
  
  drawFog();
  drawStars();
  
  //Make sun glow above the fog
  noStroke();
  ellipseMode(CENTER);
  fill(250);
  ellipse(width / 2, sunDrop, sunSize + (change / 2), sunSize + (change / 2));
  fill(255);
  ellipse(width / 2, sunDrop, sunSize, sunSize);
} 

//Draw the sun and sunrays
void drawSun()
{
  for(int i = (limit - 1); i >= 0; i--) //Loop backwards so the sunrays are behind eachother
  {
    int adjust = (change * i);
    noStroke();
    fill(255 - adjust);
    ellipse(width / 2, sunDrop, sunSize + (adjust * growth), sunSize + (adjust * growth));
  }
}
//Draw a building using infomation
void drawBuilding(int xOffset, int w, int h, int windows, int layer)
{
  noStroke();
  fill(change * layer * 2); //get lighter depending on the layer
  
  int x= width / 2 - (w / 2) + xOffset; //calculate the x-coordinate
  int y = height - h; //calculate the y-coordiante
  rect(x, y, w, h, 8); //Draw the building
  drawWindows(w, h, x, y, windows, layer); //Call the windows using this building's infomation
}

//Function to create windows using building information
void drawWindows(int w, int h, int x, int y, int windows, int layer)
{
  int wSize = 32; //Size for the windows
  int wGap = (w - (wSize * windows)) / (windows * 2); //Calcualte gaps between windows
  int wStart = x + wGap; //get the starting x-coordinate
  int wDif = wSize + (wGap * 2); //get the difference between the windwos
  for(int yPos = y + wGap; yPos < height; yPos += (int)(wDif * (1.0f + (1.0f / windows)))) //loop till the y-coordinate is larger than the height
  {
    for(int i = 0; i < windows; i++) //Loop for the amount of windows wanted
    {
      fill(255 - (change * layer * 1.75f)); //Get darker depending on the layer
      rect(wStart + (wDif * i), yPos, wSize, wSize); //create the window
    }
  }
}

void drawMonorail()
{
  int yPos = 224; //y-coordinate of bridge
  
  //Create bridge
  stroke(bColor + change); // Color the bridge
  strokeWeight(24);
  line(0, yPos, width, yPos);

  //Creating bridge support beams
  noFill();
  strokeWeight(16); 
  rect(128, yPos, 128, height);
  rect(384, yPos, 128, height);
  rect(640, yPos, 128, height);
  rect(896, yPos, 128, height);
  
  //Create bridge top
  line(0, yPos - 32, 256, yPos - 32);
  line(256, yPos - 32, 368, yPos - 96);
  line(368, yPos - 96, 656, yPos - 96);
  line(656, yPos - 96, 768, yPos - 32);
  line(768, yPos - 32, width, yPos - 32);

  //Create bridge top beams
  strokeWeight(8);
  rect(128, yPos - 32, 128, 32);
  rect(320, yPos - 64, 384, 64);
  rect(384, yPos - 96, 128, 96);
  rect(448, yPos - 96, 128, 96);
  rect(512, yPos - 96, 128, 96);
  rect(768, yPos - 32, 128, 32);
}

void drawStars()
{
  stroke(255);
  strokeWeight(8);
  //Create stars
  point(32, 64);
  point(72, 160);
  point(128, 128);
  point(224, 48);
  point(256, 96);
  point(160, 32);
  point(348, 192);
  point(256, 160);
  point(320, 48);
  point(424, 64);
  //Flip stars 
  point(992, 64);
  point(952, 160);
  point(896, 128);
  point(800, 48);
  point(768, 96);
  point(864, 32);
  point(676, 192);
  point(768, 160);
  point(704, 48);
  point(600, 64);
}

void drawFog()
{
  int fogDis = 32;
  strokeWeight(fogDis);
  int limit = height / fogDis;
  int aStart = 128;
  int aDif = aStart / limit;
  for(int i = 0; i < limit; i++)
  {
    int yPos = height - (fogDis * (i + 1)) + (fogDis / 2); 
    stroke(0, aStart - (aDif * i));
    line(0, yPos, width, yPos); 
  }
}
