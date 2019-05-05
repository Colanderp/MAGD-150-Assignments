import processing.pdf.*;

Time time;
PFont title, credit;
PImage background;
PVector mouse, pMouse;

float creditsY;
String[] credits;
String movieTitle = "VIRTUAL\nREALITY";

int randomize =  0;
boolean recording = false;

void setup()
{
  background(0);
  size(512, 896); 
  time = new Time();
  background = loadImage("movieposter.png");
  title = createFont("Potra.ttf", 64);
  credit = createFont("SF Movie Poster Condensed.ttf", 48);
  creditsY = height - 96;
}

//Draws the title in the center of the screen
void DrawTitle()
{
  textFont(title);
  textAlign(CENTER);
  PVector pos = new PVector(width/2, height/2);
  //Draw the movie title but randomize it according to the variable 'randomize'
  DrawText(RandomizeText(movieTitle, randomize), animatedVector(pos), color(255), color(0), 2, 96, 72);
}

//Draws the credits in the bottom of the screen
void DrawCredits()
{
  textFont(credit);
  textAlign(CENTER);
  credits = loadStrings("credits.txt");
  String combined = ""; //Combined all the lines with '\n' between the lines
  for (int i = 0 ; i < credits.length; i++) {
    //Randomize (4 times more than the title) each line while adding it to the combined string
    combined += RandomizeText(credits[i], randomize * 4);
    if(i < (credits.length - 1))//If it is not the last credits line
      combined += "\n";  //Add a new line
  }
  PVector pos = new PVector(width/2, creditsY);
  DrawText(combined, animatedVector(pos), color(255), color(0), 1, 40, 32);
}

//Randomizes a character in a string (m) 'r' times
String RandomizeText(String m, int r)
{
  String newM = m;
  for(int i = 0; i < r; i++) //Loop 'r' times
  {
    int n = int(random(0, newM.length())); //random index in string
    char rando = (char)int(random(33, 127)); //random character
    newM = setCharAt(newM, n, rando); //set that character to the random one
  }
  return newM;
}

//Sets a character (c) at an index (index) in a string (m)
String setCharAt(String m, int index, char c)
{
  String newM = "";
  //Loop through the string and add the regular character or the random one if its at the index
  for(int i = 0; i < m.length(); i++)
  {
    char ch = m.charAt(i);
    if(i != index || ch == '\n' || ch == ' ') //Always add spaces and new lines
      newM += ch;
    else if(i == index)
      newM += c;
  }
  return newM;
}

//Draw text function handles all texts with added outline feature and leading
void DrawText(String msg, PVector pos, color text, color outline, int oS, int tS, int tLead)
{
  textSize(tS);
  textLeading(tLead);
  fill(outline);
  for(int i = 1; i <= oS; i++) //Outline
  {
    text(msg, pos.x - i, pos.y);
    text(msg, pos.x + i, pos.y);
    text(msg, pos.x, pos.y - i);
    text(msg, pos.x, pos.y + i);
    text(msg, pos.x - i, pos.y - i);
    text(msg, pos.x + i, pos.y - i);
    text(msg, pos.x + i, pos.y + i);
    text(msg, pos.x - i, pos.y + i);
  }
  
  fill(text);
  text(msg, pos.x, pos.y); //Original message
}

//Animate a vector accordingly to the mouse movement
PVector animatedVector(PVector pos)
{
  PVector dif = PVector.mult(PVector.sub(mouse, pMouse), time.deltaTime * 2);
  return PVector.sub(pos, dif);
}

//Animate the background image accordingly to mouse movement
void DrawAnimatedBackground()
{
  PVector dif = PVector.mult(PVector.sub(mouse, pMouse), time.deltaTime * 3);
  float w, h;
  w = 660; h = 1020;
  PVector pos = new PVector(dif.x+(width - w) / 2, dif.y+(height - h) / 2);
  image(background, pos.x, pos.y, w, h);
}

void draw()
{
  time.Update(); //Update time
  background(0);
  mouse = new PVector(mouseX, mouseY);
  pMouse = new PVector(pmouseX, pmouseY);
  
  //Set the randomization accordingly to the speed of the mouse movement
  randomize = int(PVector.mult(PVector.sub(mouse, pMouse), time.deltaTime).mag());
  
  DrawAnimatedBackground();
  DrawCredits();
  DrawTitle();
  
  if(recording) //If recording a PDF, stop it so it only goes a frame
  {
    endRecord();
    recording = false;
  }
}

void CreatePDF() //Create a PDF if not already recording one
{
  if(recording) return;
  beginRecord(PDF, "movieposter-lab8.pdf");
  recording = true;
}

void keyPressed() //If 'r' is pressed then create a pdf
{
  if(key == 'r')
    CreatePDF();
}
