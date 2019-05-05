Time time;
PVector playerPos;
PImage[] sprites;

int gridSize = 16;

int fillPercent = 50;
int smoothing = 5;
int stopColliding = 3;
String[] sPaths = 
{
  "sprites/full.png",
  "sprites/left.png",
  "sprites/right.png",
  "sprites/upleft.png",
  "sprites/upright.png"
};

PVector[] normals =
{
  new PVector(-1, 1),
  new PVector(1, 1),
  new PVector(-1, -1),
  new PVector(1, -1)
};

int[][] level;
int w, h;

float gravity = -9.81;

ArrayList<Ball> myBalls;

/*
Retro games we're very simple
This recreates that simplicilty
*/
void setup()
{
  size(1280, 720);
  time = new Time();
  myBalls = new ArrayList<Ball>();
  LoadSprites();
  Generate();
}

//A collection of functions to create the map
void Generate()
{
  GenerateLevel();
  for(int i = 0; i < smoothing; i++) //Smooth multiple times to create a better map
    SmoothMap();
    
  SetIndexes();
}

//Load all the images (call on setup)
void LoadSprites()
{
  sprites = new PImage[sPaths.length];
  for(int i = 0; i < sprites.length; i++)
  {
    sprites[i] = loadImage(sPaths[i]);
  }
}

//Generate the level
void GenerateLevel()
{
  w = width / gridSize;
  h = height / gridSize;
  println("Map Generating ("+w+", "+h+")");
  level = new int[w][h];
  for(int x = 0; x < w; x++)
  {
    for(int y = 0; y < h; y++)
    {
      if(x == 0 || x >= (w-1) || y == 0 || y >= (h-1)) //Fill edge
      {
        level[x][y] = 1;
        continue;
      }
      
      int random = int(random(0, 100));
      level[x][y] = (random < fillPercent) ? 1 : 0;
    }
  }
}

//Smooth the map according to surrounding walls for all indexes
void SmoothMap()
{
  for(int x = 0; x < w; x++)
  {
    for(int y = 0; y < h; y++)
    {
      int wC = GetSurroundingWalls(x, y);
      if (wC > 4)
        level[x][y] = 1;
      else if(wC < 4)
        level[x][y] = 0;
    }
  }
}

//Set the indexes depending on what is next to it (create the angles)
void SetIndexes()
{
  for(int x = 0; x < w; x++)
  {
    for(int y = 0; y < h; y++)
    {
      if(level[x][y] == 0 || x == 0 || x == w - 1 || y == 0 || y == h - 1) continue;
      level[x][y] = 1; //Reset all indexes
      
      int up = level[x][y+1];
      int down = level[x][y-1];
      int left = level[x-1][y];
      int right = level[x+1][y];
      
      int upperLeft = level[x-1][y+1];
      int lowerLeft = level[x-1][y-1];
      int lowerRight = level[x+1][y-1];
      int upperRight = level[x+1][y+1];
      
      if(up > 0 && down > 0 && right > 0 && left > 0 && upperLeft > 0 && lowerLeft > 0 && lowerRight > 0 && upperRight > 0)
        continue;
      
      if(upperLeft == 0 && left == 0 && up == 0 && right > 0)
        level[x][y] = 2;
      if(upperRight == 0 && right == 0 && up == 0 && left > 0)
        level[x][y] = 3;
      if(lowerLeft == 0 && left == 0 && down == 0 && right > 0)
        level[x][y] = 4;
      if(lowerRight == 0 && right == 0 && down == 0 && left > 0)
        level[x][y] = 5;
    }
  }
}

//Get all the full blocks (walls) around (x, y)
int GetSurroundingWalls(int x, int y)
{
  int walls = 0;
  for(int nX = x - 1; nX <= x + 1; nX++)
  {
    for(int nY = y - 1; nY <= y + 1; nY++)
    {
      if(nX >= 0 && nX < w && nY >= 0 && nY < h)
      {
        if(nX != x || nY != y)
          walls+=level[nX][nY];
      }
      else
        walls++;
    }
  }
  return walls;
}

//Explode around and at (x, y)
void Explode(int x, int y)
{
  if(x == 0 || x == w - 1 || y == 0 || y == h - 1)
    return;
  
  for(int nX = x - 1; nX <= x + 1; nX++)
  {
    for(int nY = y - 1; nY <= y + 1; nY++)
    {
      if(nX > 0 && nX < w - 1 && nY > 0 && nY < h - 1)
      {
        if(nX == x || nY == y)
          level[nX][nY] = 0;
      }
    }
  }
  
  SetIndexes();
}

void draw()
{
  time.Update();
  background(255);
  DrawLevel();
  UpdateBalls();
}

//Read key presses
void keyPressed()
{
  println(key);
  if(key == 'r') //Regenerate the map
  {
    Generate();
    println("Regenerating Map");
  }
  if(key == 'b') //Create a ball
  {
    //Create ball
    int x = int(mouseX / gridSize);
    int y = int(mouseY / gridSize);
    if(level[x][y] != 0) return;
    PVector p = new PVector(x * gridSize + (gridSize / 2), y * gridSize + (gridSize / 2));
    Ball b = new Ball(p, new PVector(1, -1), 8);
    println("Create Ball : ("+p.x+", "+p.y+")");
    myBalls.add(b);
  }
}

//Explode the map where the mouse is when mouse is pressed
void mousePressed()
{
  int x = (mouseX / gridSize);
  int y = (mouseY / gridSize);
  
  println("Explode ("+x+", "+y+")");
  Explode(x,y);
}

//Draw the level according to the images
void DrawLevel()
{  
  for(int x = 0; x < w; x++)
  {
    for(int y = 0; y < h; y++)
    {
      if(level[x][y] <= 0) continue;
      image(sprites[level[x][y]-1], x * gridSize, y * gridSize, gridSize, gridSize);
    }
  }
}

//Update all the balls on screen
void UpdateBalls()
{
  for(int i = 0; i < myBalls.size(); i++)
  {
    Ball b = myBalls.get(i);
    PVector bounceOff = new PVector(0, 0);
    PVector d = PVector.mult(b.dir.normalize(), time.deltaTime);
    PVector index = new PVector(int((b.pos.x + d.x) / gridSize), int((b.pos.y + d.y) / gridSize)); //Get the index right infront of the ball's movement
    int val = level[int(index.x)][int(index.y)];
    
    /*
    Below will change the bounce normal depending on what type of block it hits
    if the value is 1 then it is a full block and we bounce off the side we hit
    if the value isn't 0 then take that value and use the normal indicated above for that angle block
    
    It is very prototype, it needs a lot of work that I don't want to do
    */
    if(val == 1)
    {
      PVector pos = new PVector(index.x * gridSize + (gridSize / 2), index.y * gridSize + (gridSize / 2));
      PVector hit = PVector.sub(b.pos, pos);
      bounceOff = hit.normalize();
      println(bounceOff);
      if(abs(bounceOff.x) >= abs(bounceOff.y))
        bounceOff.y = 0;
      else
        bounceOff.x = 0;
    }
    else if(val != 0)
      bounceOff = normals[val - 2];
    
    if(bounceOff.x != 0 || bounceOff.y != 0) //If needed to bounce off
    {
        bounceOff.normalize();
        float n = b.dir.dot(bounceOff);
        PVector nDir = PVector.sub(b.dir, PVector.mult(bounceOff, 2 * n)); 
        b.dir = nDir;
    }
    
    float speed = b.size * 4; //Speed depends on size
    b.dir = PVector.mult(b.dir, speed); //make the direction use the speed
    b.dir = PVector.add(b.dir, PVector.mult(b.dir, -time.deltaTime)); //Slow down overtime
    b.dir.y -= gravity * time.deltaTime * b.size; //Always have the same gravity being applied
    b.pos = new PVector(constrain(b.pos.x + (b.dir.x * time.deltaTime), b.size / 2, width  - (b.size / 2)), constrain(b.pos.y + (b.dir.y * time.deltaTime), b.size / 2, height  - (b.size / 2))); //Move
    
    //Draw the ball
    noStroke();
    fill(255, 0, 0);
    ellipse(b.pos.x, b.pos.y, b.size, b.size);
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

class Ball
{
  public PVector pos;
  public PVector dir;
  public float size = 8;
  
  public Ball(PVector p, PVector d, float s)
  {
    pos = p;
    dir = d;
    size = s;
  }
}
