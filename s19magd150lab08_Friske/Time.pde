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
