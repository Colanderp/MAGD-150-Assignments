//Slider class keeps track of percent of the slider is at and draws them
public class Slider
{
  public float percent = 0.5;
  public PVector pos;
  public PVector size;
  public PVector knobSize;
  public boolean sliding = false;
  
  PImage gradient;
  
  public Slider(PVector p, PVector s, PVector k, String img)
  {
      sliding = false;
      gradient = loadImage(img);
      pos = p; size = s; knobSize = k;
  }
  
  public void DrawSlider()
  {
    image(gradient, pos.x, pos.y, size.x, size.y);
    fill((MouseOver() || sliding) ? 128 : 255);
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    rect(pos.x + (size.x * percent), pos.y + (size.y / 2), knobSize.x, knobSize.y);
  }
  
  public boolean MouseOver()
  {
     PVector mouse = new PVector(mouseX, mouseY);
     return (abs(mouse.x - (pos.x + (size.x * percent))) <= (knobSize.x / 2) 
     && abs(mouse.y - (pos.y + (size.y / 2))) <= (knobSize.y / 2));
  }
  
  public void UpdateSlide()
  {
    PVector mouse = new PVector(mouseX, mouseY);
    percent = constrain(mouse.x - pos.x, 0, size.x) / size.x; 
  }
}
