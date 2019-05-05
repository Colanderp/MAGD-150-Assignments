int lastTime = 0;
int delta = 0;
float deltaTime = 0;
float timeElapsed = 0.0;

boolean grow = false;
float growPerSec = 64;
float popSize = 256;

ArrayList<Bubble> bubbles;

void setup()
{
  frameRate(60); //Set frame rate to 60 fps
  size(768, 768); //Set the size of the window
  bubbles = new ArrayList<Bubble>(); //Initilize the bubble list
}

void draw()
{
  //Get time from last frame
  delta = millis() - lastTime;
  lastTime = millis();  
  deltaTime = (delta / 1000.0);
  
  background(90,137, 171); //Set background and clear drawings
  DrawBackground(); //Redraw the background
  DrawBath(); //Redraw the bath
  
  UpdateBubbles(); //Update all the bubbles
  
  if(grow) //If growing bubble then keep increasing timeElapsed and size
  {
    timeElapsed += deltaTime;
    float size = growPerSec * timeElapsed;
    if(size < popSize)
      DrawBubbleCreation(size); //Draw the bubble being grown
    else //If too big, pop the bubble and stop growing
      grow = false;
  }
  
  DrawBubbleWand(mouseX, mouseY); //Draw the wand at the mouse position
  Tutorial();
}

void Tutorial()
{
  fill(0);
  textAlign(CENTER);
  textSize(12);
  text("Hold any mouse button to begin growing bubbles", width/2, 32);
  text("Let go at the size you want (don't let it go too big)", width/2, 48);
  text("Fling your mouse when letting go to throw the bubble", width/2, 64);
  text("Any key press will clear all the bubbles", width/2, height - 32);
  
}

void DrawBackground() //Draw the walls
{
  noStroke();
  fill(128);
  quad(0, height, 0, height-48, width, height-48, width, height);
  fill(168,136,111);
  quad(0, height-80, 0, height-48, width, height-48, width, height-80);
  fill(171,219,222);
  quad(0, height/2, width, height/2, width, height-80, 0, height-80);
  quad(0, 0, width, 0, width, 96, 0, 96);
  quad(0, height/2, 0, 96, width/2 - 96, 96, width/2 - 96, height/2);
  quad(width, height/2, width, 96, width/2 + 96, 96, width/2 + 96, height/2);
  
  noFill();
  stroke(255);
  strokeWeight(8);
  quad(width/2 - 96, height/2 - 8,  width/2 - 96, 96, width/2 + 96, 96, width/2 + 96, height/2 - 8);
  strokeWeight(4);
  line(width/2, height/2 - 8, width/2, 96);
  line(width/2 - 96, height/2 - 200, width/2 + 96, height/2 - 200);
  line(width/2 - 96, height/2 - 112, width/2 + 96, height/2 - 112);
  line(width/2 - 96, height/2 - 26, width/2 + 96, height/2 - 26);
  
  noStroke();
  fill(168,136,111);
  quad(width/2 + 104, height/2, width/2 - 104, height/2, width/2 - 104, height/2-24, width/2 + 104, height/2-24);
}

void DrawBath() //Draw a bath
{
  noStroke();
  fill(245, 245, 255); //Fake Bubbles
  ellipse(width / 2 + 160, height - 192, 256, 224);
  ellipse(width / 2 - 160, height - 192, 256, 224);
  ellipse(width / 2, height - 192, 320, 320);
  
  ellipse(width / 2, height - 328, 96, 96);
  ellipse(width / 2 - 64, height - 328, 72, 72);
  ellipse(width / 2 + 64, height - 328, 72, 72);
  ellipse(width / 2 - 96, height - 312, 64, 64);
  ellipse(width / 2 + 96, height - 312, 64, 64);
  ellipse(width / 2 - 128, height - 296, 72, 72);
  ellipse(width / 2 + 128, height - 296, 72, 72);
  ellipse(width / 2 - 176, height - 280, 72, 72);
  ellipse(width / 2 + 176, height - 280, 72, 72);
  ellipse(width / 2 - 208, height - 256, 96, 96);
  ellipse(width / 2 + 208, height - 256, 96, 96);
  ellipse(width / 2 - 264, height - 208, 72, 72);
  ellipse(width / 2 + 264, height - 208, 72, 72);
  
  fill(255, 254, 231); //Bath
  arc(width / 2 + 192, height - 192, 256, 360, 0, HALF_PI); 
  arc(width / 2 - 192, height - 192, 256, 360, HALF_PI, PI); 
  quad(width / 2 + 192, height - 12, width / 2 - 192, height - 12, width / 2 - 192, height - 192, width / 2 + 192, height - 192); 
  stroke(255, 254, 231);
  strokeWeight(32);
  line(width / 2 - 320, height -192, width / 2 + 320, height - 192);
  stroke(222, 208, 129); //Extras
  line(width / 2 - 192, height - 48, width / 2 - 192, height + 32);
  line(width / 2 + 192, height - 48, width / 2 + 192, height + 32);
  strokeWeight(4);
  fill(222, 208, 129); //Extras
  quad(width / 2 - 336, height - 208, width / 2 - 336, height -192,  width / 2 + 336, height - 192, width / 2 + 336, height - 208);

  stroke(222, 208, 129, 128);
  line(width / 2 - 320, height -176, width / 2 + 320, height - 176);
}

void DrawBubbleWand(int x, int y)
{
  int diameter = 64;
  float r45 = (diameter / 2.0 * 0.771);
  stroke(0, 255, 128);
  strokeWeight(12);
  noFill();
  ellipse(x, y, diameter, diameter);
  line(x-r45, y+r45, x - 64, y + 64);
  strokeWeight(4);
  ellipse(x-72, y+72, 22, 22);
}

void DrawBubbleCreation(float s) //A showcase of the bubble that will be created
{
  noStroke();
  fill(0, 96, 255, 128);
  ellipse(mouseX, mouseY, s, s);
}

void CreateBubble(float s) //Create a bubble with a size (s)
{
  PVector pos = new PVector(mouseX, mouseY); //Get the mouse position
  PVector oldPos = new PVector(pmouseX, pmouseY); //Get the old mouse position
  PVector dir = PVector.sub(pos, oldPos); //Get the direction the mouse is moving
  if(dir.mag() < 0.02) //If the mouse isnt moving enough, give it a direction of (0, 1) to move the bubble downwards
    dir = new PVector(0, 1);
    
  Bubble create = new Bubble(pos, dir, s); //Create the bubble
  bubbles.add(create); //Add it to the bubbles list to get updated and drawn
}

void UpdateBubbles()
{
  for(int x = 0; x < bubbles.size(); x++)
  {
    Bubble b = bubbles.get(x);                                      
    for(int y = 0; y < bubbles.size(); y++) //Check collision
    {
      Bubble b2 = bubbles.get(y);
      if(b == b2) continue; //skip the same bubble
      float dis = PVector.dist(b.pos, b2.pos);
      boolean touching = (dis <= ((b.size + b2.size) / 2));
      if(touching)
      {
        PVector n = PVector.sub(b.pos, b2.pos);
        n.normalize();
        // Find the length of the component of each of the movement vectors along n. 
        float a1 = b.dir.dot(n);
        float a2 = b2.dir.dot(n);
        
        // Using the optimized version, 
        // optimizedP =  2(a1 - a2)
        //              -----------
        //                m1 + m2
        float optimizedP = min((2.0 * (a1 - a2)) / (b.size + b2.size), 0);
        
        // Calculate Nv1, the new movement vector of b
        PVector Nv1 = PVector.sub(b.dir, PVector.mult(n, optimizedP * b2.size));
        
        // Calculate Nv2, the new movement vector of b2
        PVector Nv2 = PVector.add(b2.dir, PVector.mult(n, optimizedP * b.size));
        
        b.dir = Nv1;
        b2.dir = Nv2;
        println("Bubble Collision");
      }
    }
      
    //Keep the bubble within the boarders
    PVector bounceOff = new PVector(0, 0);
    if(b.pos.x <= (b.size / 2)) //If on the left side y = 1
      bounceOff.x = 1;
    else if(b.pos.x >= width - (b.size / 2)) //If on the right side y = -1
      bounceOff.x = -1;
      
    if(b.pos.y <= (b.size / 2)) //If on the top side x = 1
      bounceOff.y = 1;
    else if(b.pos.y >= height - (b.size / 2)) //If on the bottom side x = -1
      bounceOff.y = -1;
    
    if(bounceOff.x != 0 || bounceOff.y != 0) //If needed to bounce off
    {
        bounceOff.normalize();
        float n = b.dir.dot(bounceOff);
        PVector nDir = PVector.sub(b.dir, PVector.mult(bounceOff, 2 * n)); 
        b.dir = nDir;
        println("Bubble Bounce Off Side");
    }
    
    //Move the bubble according to its direction, constrain to the window
    float speed = deltaTime * (512 / b.size); //Speed depends on size
    b.pos = new PVector(constrain(b.pos.x + (b.dir.x * speed), b.size / 2, width  - (b.size / 2)), constrain(b.pos.y + (b.dir.y * speed), b.size / 2, height  - (b.size / 2)));
    
    //Create bubble look
    strokeWeight(8);
    stroke(255, 64);
    fill(0, 128, 255, 128);
    ellipse(b.pos.x, b.pos.y, b.size, b.size);
    
    noStroke();
    fill(255, 128);
    ellipse(b.pos.x - (b.size / 6.4), b.pos.y - (b.size / 3.2), b.size / 8, b.size / 8);
    
    noFill();
    strokeWeight(b.size / 16);
    stroke(255, 128);
    PVector p1 = new PVector(b.pos.x - (b.size / 4), b.pos.y - (b.size / 4));
    PVector p2 = new PVector(b.pos.x - (b.size / 2.5), b.pos.y - (b.size / 6));
    PVector p3 = new PVector(b.pos.x - (b.size / 2.5), b.pos.y + (b.size / 6));
    PVector p4 = new PVector(b.pos.x - (b.size / 4), b.pos.y + (b.size / 4));
    bezier(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y);
  }
}

void mousePressed() //Start growing bubble
{
  timeElapsed = 0;
  grow = true;
}

void mouseReleased() //Stop growing bubble
{
  if(grow) //If it is growing a bubble
  {
    float size = (growPerSec * timeElapsed); //Get the size of it
    if(size >= 32) //If the size is big enough
    {
      //Create the bubble
      println("Create Bubble: " + size + " size");  
      CreateBubble(size);
    }
    grow = false; //Stop growing
  }
}

void keyPressed() //Remove all bubbles
{
  bubbles = new ArrayList<Bubble>(); //Remove all bubbles
  println("Removed all bubbles");
}

public class Bubble //Bubble class, keeps a position, a move direction, and a size
{
  public PVector pos;
  public PVector dir;
  public float size;
  
  public Bubble() //Default contructor, never called
  {
    pos = new PVector(0, 0);
    dir = new PVector(0, 0);
    size = 64;
  }
  
  public Bubble(PVector p, PVector d, float s) //Constructor that takes in parameters for all variables
  {
    pos = p;
    dir = d;
    size = s;
  }
}
