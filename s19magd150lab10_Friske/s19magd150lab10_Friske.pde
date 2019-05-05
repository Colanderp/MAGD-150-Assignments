float angle = 0;

PVector rot = new PVector(PI/4, PI, 0);
ArrayList<Drawn> drawings = new ArrayList<Drawn>();
PGraphics drawn;
PShape sphere; 

Button reset;
Slider red;
Slider green;
Slider blue;
Slider drawSize;
color chosen;
float chosenSize;

Button shape;
String name = "CUBE";
int curShape = 0;

boolean drawing = false;
boolean moving = false;

void setup()
{
  size(1024, 512, P3D);
  drawn = createGraphics(256, 256);

  reset = new Button(new PVector((width * 0.375) + 16, height/2+40), 
  new PVector(160, 48), "RESET", (128), (64));
  red = new Slider(new PVector(32, height/2 + 160),
  new PVector(448, 8), new PVector(16, 16), "redGradient.png");
  
  green = new Slider(new PVector(32, height/2 + 192),
  new PVector(448, 8), new PVector(16, 16), "greenGradient.png");
  
  blue = new Slider(new PVector(32, height/2 + 224),
  new PVector(448, 8), new PVector(16, 16), "blueGradient.png");
  
  drawSize = new Slider(new PVector((width * 0.25) + 64, height/2-32), 
  new PVector(160, 32), new PVector(16, 48), "sizeGradient.png");
  
  shape = new Button(new PVector((width * 0.75), 48), 
  new PVector(160, 48), "CUBE", (128), (64));
  
  sphere = createShape(SPHERE, 256);
}

void mousePressed()
{
  if(shape.MouseOver()) //Change shape when button hit
  {
    curShape++;
    if(curShape > 2)
      curShape = 0;
  }
  
  //Sliders interacting
  if(red.MouseOver())
    red.sliding = true;
  if(green.MouseOver())
    green.sliding = true;
  if(blue.MouseOver())
    blue.sliding = true;
  if(drawSize.MouseOver())
    drawSize.sliding = true;

  if(reset.MouseOver()) //Reset the drawing when button hit
    drawings = new ArrayList<Drawn>();
    
  //If pressed down in the graphics box, start drawing
  PVector mouse = new PVector(mouseX - 32, mouseY - 64);
  if(abs(mouse.x - 128) <= 128 && abs(mouse.y - 128) <= 128)
    drawing = true;
  
  //If clicked on the non-hud side start moving shape
  if(mouse.x+32 >= width/2)
    moving = true;
}

void mouseDragged()
{
  //Update UIs
  if(red.sliding) {
    red.UpdateSlide();
      return;    
  }
  
  if(green.sliding) {
    green.UpdateSlide();
    return;    
  }
  
  if(blue.sliding) {
    blue.UpdateSlide();
    return;    
  }
  
  if(drawSize.sliding) {
    drawSize.UpdateSlide();
    return;    
  }
  
  if(drawing) //Draw shapes when mouse is moved
  {
    PVector mouse = new PVector(mouseX - 32, mouseY - 64);
    if(abs(mouse.x - 128) <= 128 && abs(mouse.y - 128) <= 128)
    {
    
  
      Drawn d = new Drawn(chosen, mouse, chosenSize);
      drawings.add(d);
    }
  }
  else if(moving) //Rotate objects when mouse is moved
  {
    PVector dif = new PVector(pmouseX - mouseX, pmouseY - mouseY).normalize();
    rot.y += dif.x * PI * 0.01;
    rot.x += dif.y * PI * 0.01;
  }
}

//Stop doing everything
void mouseReleased()
{
  red.sliding = false;
  green.sliding = false;
  blue.sliding = false;
  drawSize.sliding = false;

  drawing = false;
  moving = false;
}

void DrawDrawings()
{
  for(int i = 0; i < drawings.size(); i++)
  {
    Drawn d = drawings.get(i);
    drawn.noStroke();
    drawn.fill(d.col);
    drawn.ellipse(d.pos.x, d.pos.y, d.size, d.size);
  }
}

void draw()
{ 
  background(64);
  
  // Start of HUD
  hint(DISABLE_DEPTH_TEST);
  drawn.beginDraw();
  drawn.background(255); //Set to white
  
  DrawDrawings(); //Draw the drawings set
  
  //Outline of texture (so it is tileable)
  drawn.noStroke();
  drawn.fill(0);
  drawn.ellipse(0, 0, 64, 64);
  drawn.ellipse(drawn.width, 0, 64, 64);
  drawn.ellipse(0, drawn.height, 64, 64);
  drawn.ellipse(drawn.width, drawn.height, 64, 64);
  
  float edge = 8;
  drawn.rectMode(CORNER);
  drawn.rect(0, 0, drawn.width, edge);
  drawn.rect(0, 0, edge, drawn.height);
  drawn.rect(0, drawn.height - edge, drawn.width, edge);
  drawn.rect(drawn.width - edge, 0, edge, drawn.height);
  drawn.endDraw(); //Stop drawing the drawn graphics
  
  //UI
  rectMode(CORNER);
  imageMode(CORNER);
  fill(255, 128);
  rect(0, 0, width/2, height);
  image(drawn, 32, 64); //What we have drawn
  
  fill(255);
  textSize(32);
  textAlign(CENTER, BOTTOM);
  text("DRAW THE TEXTURE", 0, -8, width/2, 64);
  
  //Draw UI Buttons and sliders
  reset.DrawButton();
  red.DrawSlider();
  green.DrawSlider();
  blue.DrawSlider();
  drawSize.DrawSlider();
  
  //Get the selected color and size
  chosen = color(red.percent * 255, green.percent * 255, blue.percent * 255);
  chosenSize = (drawSize.percent * 28) + 4;
  
  //Showcase the selected size
  fill(0);
  noStroke();
  ellipse(width * 0.375 + 16, height/2 - 64, chosenSize, chosenSize);
    
  //Showcase the selected color
  stroke(0);
  strokeWeight(4);
  fill(chosen);
  rectMode(CORNER);
  rect(32, height/2+96, 448, 32);
  
  shape.text = name;
  shape.DrawButton();
  hint(ENABLE_DEPTH_TEST); //End HUD
  
  //Lights
  directionalLight(128, 128, 128, 0, 1, -1);
  ambientLight(128, 128, 128);
  
  
  pushMatrix(); //Showcase the 3D image with the texture
  translate(width * 0.75, height/2);
  scale(0.25);
  rotateX(rot.x);
  rotateY(rot.y);
  rotateZ(rot.z);
  textureMode(IMAGE);
  textureWrap(NORMAL); 

  //Depending on the curShape draw the wanted shape
  if(curShape == 0)
    TexturedCube(256);
  else if(curShape == 1)
    TexturedPyramid(256);
  else if(curShape == 2)
  {
    noStroke();
    fill(255);
    name = "SPHERE";
    sphere.setTexture(drawn);
    shape(sphere);
  }
  popMatrix();  
}


//Create a cube with the size and drawn texture
void TexturedCube(float size) 
{
  name = "CUBE";
  beginShape(QUADS);
  texture(drawn);
  noStroke();
  // +Z "front" face
  vertex(-size, -size,  size, 0, 0);
  vertex( size, -size,  size, size, 0);
  vertex( size,  size,  size, size, size);
  vertex(-size,  size,  size, 0, size);

  // -Z "back" face
  vertex( size, -size, -size, 0, 0);
  vertex(-size, -size, -size, size, 0);
  vertex(-size,  size, -size, size, size);
  vertex( size,  size, -size, 0, size);

  // +Y "bottom" face
  vertex(-size,  size,  size, 0, 0);
  vertex( size,  size,  size, size, 0);
  vertex( size,  size, -size, size, size);
  vertex(-size,  size, -size, 0, size);

  // -Y "top" face
  vertex(-size, -size, -size, 0, 0);
  vertex( size, -size, -size, size, 0);
  vertex( size, -size,  size, size, size);
  vertex(-size, -size,  size, 0, size);

  // +X "right" face
  vertex( size, -size,  size, 0, 0);
  vertex( size, -size, -size, size, 0);
  vertex( size,  size, -size, size, size);
  vertex( size,  size,  size, 0, size);

  // -X "left" face
  vertex(-size, -size, -size, 0, 0);
  vertex(-size, -size,  size, size, 0);
  vertex(-size,  size,  size, size, size);
  vertex(-size,  size, -size, 0, size);

  endShape();
}

//Draw a pyramid with the size t and the drawn texture
void TexturedPyramid(float t) 
{
  name = "PYRAMID";
  beginShape(TRIANGLES);
  texture(drawn);
  noStroke();
  vertex(-t, -t, t, 0, 0);
  vertex( t, -t, t, t, t);
  vertex( 0, 0, -t, t, 0);

  vertex( t, -t, t, 0, 0);
  vertex( t, t, t, t, t);
  vertex( 0, 0, -t, t, 0);

  vertex( t, t, t, 0, 0);
  vertex(-t, t, t, t, t);
  vertex( 0, 0, -t, t, 0);

  vertex(-t, t, t, 0, 0);
  vertex(-t, -t, t, t, t);
  vertex( 0, 0, -t, t, 0);
 
  endShape();
}
