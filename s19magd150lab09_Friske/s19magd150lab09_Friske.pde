import processing.video.*;
import processing.sound.*;

public Time time;


int blink = 0;
float blinkTime = 0.25;
float scaryX = 100;
boolean lit = true;
boolean scare = false;

Capture cam;
WhiteNoise noise;
SoundFile jumpscare;
String[] cameras = Capture.list();
PImage bathroomLit, bathroomDark, scaryLady;

void setup()
{
  size(596, 891);
  time = new Time();
  
  //Load all the needed resources
  bathroomLit = loadImage("bathroom_lit.png");
  bathroomDark = loadImage("bathroom_dark.png");
  scaryLady = loadImage("scaryLady.png");
  jumpscare = new SoundFile(this, "jumpscare.wav");
  noise = new WhiteNoise(this);
  
  if (cameras.length != 0) //Check if any cameras are connected
  {
    cam = new Capture(this, cameras[0]); //Set cam to the first camera connected
    cam.start();
  }
  
  //Set the wait time till blinking
  blinkTime = random(2.0, 5.0);
  
  
  //Play ambient noise
  noise.play();
}

void draw()
{
  time.Update(); //Update the time class
  background((lit) ? 255 : 0); //White if lit is true and black if not
  GetCapture(); //Get the capture from the camera
  if(!lit && scare) //If the room is not lit, and scare is true
       DrawLady(); //Draw scary lady
  DrawBathroom(); //Draw the bathroom over everything (transparent mirror)
  
  noise.amp((lit) ? 0.05 : 0.125); //Set noise amplitude depending on lit
  
  if(blinkTime > 0) //If blinkTime is greater than 0
    blinkTime -= time.deltaTime; //Reduce blinkTime by the deltaTime (time in seconds between frames)
    
  if(blinkTime <= 0) //If blinkTime is less than or equal to 0
  {
    if(blink > 0) //If we are blinking the lights
    {
      blink--; //Reduce blink by one
      lit = !lit; //Toggle lit boolean
      if(lit) scare = false; //Scare is false if the lights are on
      else if(random(0.0, 1.0) > 0.75) //Only scare some of the time
      {
        jumpscare.play(); //Play scary noise (sorry)
        scaryX = random(-50, 50); //Set a random x value
        scaryX += (scaryX > 0) ? 50 : -50; //Gives a 100 leeway for center the webcam (where your head is most likely)
        scare = true; //Scare you (sorry again)
      }
      blinkTime = (blink <= 0) ? random(2.0, 5.0) : random(0.1, 0.5); //If we are out of blinks give a leeway time with no blinking else blink in a very little
    }
    else
      Blink(); //Blink the screen
  }
}

void GetCapture() //Grabs the capture from the webcam
{
  if(cam == null) return; //If no camera was set then don't run this
  if (cam.available() == true) //If it is available to get a capture from
    cam.read(); //Read the image from the camera
    
  if(!lit) tint(32); //Darken the image if not lit
  else noTint(); //Else regular
  
  //Draw camera image where the mirror is
  imageMode(CENTER);
  image(cam, width/2, 212, 384, 384);
}

void DrawBathroom() //Draws the bathroom over everything
{
  noTint(); //No tint needed because two different pictures (better quality darkness)
  
  //Draw bathroom lit or dark depeding on the boolean lit
  imageMode(CORNER);
  image((lit) ? bathroomLit : bathroomDark, 0, 0);
  
  if(lit) //Dilate the image if lit (light glow)
    filter(DILATE);
}

void DrawLady() //Draw scary lady
{
  tint(96); //Darken
  imageMode(CENTER);
  image(scaryLady, width/2 - scaryX, 192, 205, 169);
}

void Blink() //Start blinking
{
  if(blink > 0) return; //Don't continue if already blinking
  blinkTime = random(0.25, 0.75);
  blink = int(random(2, 8));
  blink *= 2; //Keep it always even so it always ends lit = true
}
