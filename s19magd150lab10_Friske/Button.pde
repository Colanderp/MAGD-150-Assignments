//Button class to interact and draw a button
public class Button
{
  public PVector pos;
  public PVector size;
  public String text;
  color normal;
  color over;
  
  public Button(PVector p, PVector s, String t, color n, color o)
  {
    pos = p; size = s; text = t; normal = n; over = o;
  }
  
  public boolean MouseOver()
  {
    PVector mouse = new PVector(mouseX, mouseY);
    return (abs(mouse.x - pos.x) <= (size.x / 2) && abs(mouse.y - pos.y) <= (size.y / 2));
  }
  
  public void DrawButton()
  {
    rectMode(CENTER);
    
    stroke(0);
    strokeWeight(4);
    fill((MouseOver()) ? over : normal);
    rect(pos.x, pos.y, size.x, size.y, 8);
    
    fill(255);
    textSize(size.y / 2);
    textAlign(CENTER, CENTER);
    text(text, pos.x, pos.y, size.x, size.y);
  }
}
