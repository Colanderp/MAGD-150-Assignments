float r = 0; //rotation of the season wheel
float radius; //radius of the wheel
PVector zero = new PVector(0, 0); //A variable that stores the zero position
Time time;  //Time class that is used to smooth drawings according to time (in seconds) between frames

int backgroundWidth;
int backgroundHeight;
int[][] backSeasons;
int backgroundSize = 64;

void setup()
{
  size(1024, 512);
  radius = height - 8;
  CreateBackground();
  time = new Time();
}

void CreateBackground()
{
  backgroundWidth = (width / backgroundSize) - 1;
  backgroundHeight = (height / backgroundSize) - 1;
  backSeasons = new int[backgroundWidth][backgroundHeight];
  int x = 0;
  int y = 0;
  int value = 0;
  int yValue = 1;
  while(x < backgroundWidth && y < backgroundHeight)
  {
    backSeasons[x][y] = value;
    value++;
    if(value > 3)
      value = 0;
    
    x++;
    if(x >= backgroundWidth)
    {
      x = 0;
      value = yValue;
      yValue++;
      if(yValue > 3)
        yValue = 0;
      y++;
    }
  }
}

void draw()
{
  PVector mouse = new PVector(mouseX, mouseY);
  PVector pmouse = new PVector(pmouseX, pmouseY);
  r += (PI * time.deltaTime * 0.125);
  background(64);
  DrawBackground();
  time.Update();
  
 
  pushStyle();
  float grow = 1f + (PVector.sub(mouse, pmouse).mag() / width); //Scale determined by the mouse movement
  scale(grow); //Use the scale above to grow this style
  
  translate(width/2/grow, height/2/grow); //Keep (0, 0) in the center while scaling
  rotate(r); //Rotate the wheel
  
  DrawSeasonWheel();
  popStyle();
  
  
  PVector spr = new PVector(1, 1);
  PVector sum = new PVector(-1, 1);
  PVector aut = new PVector(-1, -1);
  PVector win = new PVector(1, -1);
  spr = PVector.mult(spr.normalize(), radius / 3);
  sum = PVector.mult(sum.normalize(), radius / 3);
  aut = PVector.mult(aut.normalize(), radius / 3);
  win = PVector.mult(win.normalize(), radius / 3);
  DrawSeasonIcon(0, spr);
  DrawSeasonIcon(1, sum);
  DrawSeasonIcon(3, win);
  
  pushStyle();
  translate(aut.x, aut.y);
  rotate(HALF_PI * 3 + QUARTER_PI);
  DrawSeasonIcon(2, new PVector(0, 0));
  popStyle();
  spr.rotate(r);
  sum.rotate(r);
  aut.rotate(r);
  win.rotate(r);
}

//Draw the wheel that spins
void DrawSeasonWheel()
{
  /************ SPRING ************/
 
  noStroke();
  fill(0, 192, 255);
  arc(0, 0, radius, radius, 0, HALF_PI);
  fill(0, 255, 92);
  arc(0, 0, 256, 256, 0, HALF_PI);
  
  /************ SUMMER ************/
  
  noStroke();
  fill(0, 128, 255);
  arc(0, 0, radius, radius, HALF_PI, PI);
  fill(0, 255, 0);
  arc(0, 0, 256, 256, HALF_PI, PI);
  
  /************ AUTUMN ************/
  
  noStroke();
  fill(255, 224, 0);
  arc(0, 0, radius, radius, PI, HALF_PI * 3);
  fill(192, 255, 96);
  arc(0, 0, 256, 256, PI, HALF_PI * 3);
  
  /************ WINTER ************/
  
  noStroke();
  fill(0, 32, 64);
  arc(0, 0, radius, radius, HALF_PI * 3, 2 * PI);
  fill(255);
  arc(0, 0, 256, 256, HALF_PI * 3, 2 * PI);
  
  /************ OUTLINE ************/
  noFill();
  stroke(0);
  strokeWeight(8);
  arc(0, 0, radius, radius, HALF_PI * 3, 2 * PI, PIE);
  arc(0, 0, radius, radius, PI, HALF_PI * 3, PIE);
  arc(0, 0, radius, radius, HALF_PI, PI, PIE);
  arc(0, 0, radius, radius, 0, HALF_PI, PIE);
}

//Use the 2D array to create the background of the seasons' logos
void DrawBackground()
{
  for(int x = 0; x < backgroundWidth; x++)
  {
    for(int y = 0; y < backgroundHeight; y++)
    {
      PVector pos = new PVector((x+1) * backgroundSize, (y+1) * backgroundSize);
      DrawSeasonIcon(backSeasons[x][y], pos);
    }
  }
}

void DrawSeasonIcon(int index, PVector pos)
{
  noStroke();
  switch(index)
  {
    case 0: //Spring
    fill(160, 0, 144);
    ellipse(pos.x, pos.y, 32, 32);
    ellipse(pos.x + 16, pos.y, 32, 32);
    ellipse(pos.x - 16, pos.y, 32, 32);
    ellipse(pos.x, pos.y + 16, 32, 32);
    ellipse(pos.x, pos.y - 16, 32, 32);
    fill(255, 255, 0);
    ellipse(pos.x, pos.y, 32, 32);
    break;
    case 1: //Summer
    fill(255, 255, 0);
    ellipse(pos.x, pos.y, 48, 48);
    break;
    case 2: //Autumn
    fill(255, 160, 0);
    triangle(pos.x, pos.y - 32, pos.x + 16, pos.y, pos.x - 16, pos.y);
    triangle(pos.x + 8, pos.y - 8, pos.x + 14, pos.y + 8, pos.x + 24, pos.y - 16);
    triangle(pos.x - 8, pos.y - 8, pos.x - 14, pos.y + 8, pos.x - 24, pos.y - 16);
    triangle(pos.x, pos.y + 10, pos.x - 14, pos.y - 8, pos.x - 20, pos.y + 16);
    triangle(pos.x, pos.y + 10, pos.x + 14, pos.y - 8, pos.x + 20, pos.y + 16);
    ellipse(pos.x, pos.y, 32, 32);
    rectMode(CENTER);
    rect(pos.x, pos.y + 16, 8, 16);
    break;
    default: //Winter
    fill(255);
    rectMode(CENTER);
    rect(pos.x, pos.y-16, 4, 18);
    rect(pos.x-16, pos.y, 18, 4);
    rect(pos.x, pos.y+16, 4, 18);
    rect(pos.x+16, pos.y, 18, 4);
    stroke(255);
    strokeWeight(4);
    noFill();
    line(pos.x + 8, pos.y - 8, pos.x + 14, pos.y - 14);
    line(pos.x - 8, pos.y + 8, pos.x - 14, pos.y + 14);
    line(pos.x - 8, pos.y - 8, pos.x - 14, pos.y - 14);
    line(pos.x + 8, pos.y + 8, pos.x + 14, pos.y + 14);
    ellipse(pos.x, pos.y, 16, 16);
    break;
  }
}

public class Time
{
  int lastTime = 0;
  int delta = 0;
  public float deltaTime = 0;

  public Time()
  {
  }

  public void Update()
  {
    delta = millis() - lastTime;
    lastTime = millis();  
    deltaTime = (delta / 1000.0);
  }
}
