import processing.sound.*;
SoundFile pizzaTime;

int lastTime = 0;
int delta = 0;
float deltaTime = 0;
float timeElapsed = 0.0;

PImage logo, place;
ArrayList<Button> menuButtons = new ArrayList<Button>();
ArrayList<Button> toppingButtons = new ArrayList<Button>();
ArrayList<Topping> pepporonies = new ArrayList<Topping>();
enum UserAction { inMenu, idle, doughing, rolling, sausing, cheesing, topping };
public UserAction action;

PVector rollerPos;
PVector doughPos;
PVector sausePos;
PVector cheesePos;
PVector compartmentSize = new PVector(96, 96);
PVector rollerSize = new PVector(192, 32);
PVector sauseSize = new PVector(160, 32);
float  pizzaSize = 288;
int makeTopping = -1;
int totalToppings = 12;

public int currentPizza = -1;
public ArrayList<Pizza> pizzas;
public boolean viewOvens = false;

PVector mouse;
PVector centerPizzaPos;

void setup() /*************************************************** SETUP ***************************************************/
{ 
  frameRate(60); //Set frame rate to 60 fps
  size(1280, 768);
  viewOvens = false;
  centerPizzaPos = new PVector(width/2, height/2 + 192);
  rollerPos = new PVector(centerPizzaPos.x, centerPizzaPos.y - 456);
  doughPos = new PVector(centerPizzaPos.x - 170, centerPizzaPos.y - 144);
  sausePos = new PVector(centerPizzaPos.x, centerPizzaPos.y - 224);
  cheesePos = new PVector(centerPizzaPos.x + 170, centerPizzaPos.y - 144);
  logo = loadImage("logo.png");
  place = loadImage("place.png");
  pizzaTime = new SoundFile(this, "PizzaTime.wav");
  action = UserAction.inMenu;
  CreateMenuButtons();
}

void CreateMenuButtons()
{
  menuButtons = new ArrayList<Button>();
  Button play = new Button(new PVector(width/2, height/2+128), 
                new PVector(256, 64), "PLAY", new Color(64, 255, 128));
  menuButtons.add(play);
  
  Button quit = new Button(new PVector(width/2, height/2+208), 
                new PVector(256, 64), "QUIT", new Color(255, 128, 64));
  menuButtons.add(quit);
}

void DrawMenu()
{
  timeElapsed += deltaTime;
  if(timeElapsed > 0.5)
  {
    pepporonies.add(new Topping(0, new PVector(random(16, width-16), 0)));
    timeElapsed = 0;  
  }
  
  noStroke();
  fill(255, 192);
  rect(0, 0, width, height);
  
  for(int i = 0; i < pepporonies.size(); i++) //Draw menu buttons
  {
    Topping p = pepporonies.get(i);
    p.localPos = PVector.add(p.localPos, PVector.mult(new PVector(0, 16), deltaTime));
    CreateTopping(p.index, p.localPos);
  }
  
  image(logo, width/2 - 256, height/2 - 288, 512, 256); //Draw logo
  for(int i = 0; i < menuButtons.size(); i++) //Draw menu buttons
  {
    Button b = menuButtons.get(i);
    b.Draw();
  }
}

void DrawTiles(int w, int h, int x, int y, int rows, Color one, Color two)
{
  int r = 0;
  int i = 0;
  PVector pos = new PVector(x, y);
  while(r < rows)
  {
    Color col = (i % 2 == 0) ? one : two;
    noStroke();
    fill(col.r, col.g, col.b);
    rect(pos.x, pos.y, w, h);
    pos.x += w;
    i++;
    if(pos.x >= width)
    {
      pos = new PVector(x, pos.y + h);
      i++;
      r++;
    }
  }
}

void DrawPizzaPlace()
{
  noStroke();
  fill(192, 168, 120);
  rect(0, 120, width, 208);
  
  DrawTiles(64, 64, 0, 128, 3, new Color(224, 0, 0), new Color(255, 255, 255));
  
  //Walls
  fill(192);
  rect(0, 328, width, height-328);
  
  if(viewOvens) return;
  
  fill(192, 168, 120);
  rect(width/2 - 160, 0, 320, 96);
  image(place, width/2 - 156, 0, 312, 92);
  
  //Roller Stand
  noStroke();
  fill(160);
  rect(rollerPos.x - 128, rollerPos.y + 16, 256, 24);
  fill(192);
  rect(rollerPos.x - 128, rollerPos.y + 16, 256, 8);
  fill(0, 128);
  rect(rollerPos.x - 128, rollerPos.y + 16, 256, 32);
  
  //Compartments
  stroke(160);
  strokeWeight(4);
  fill(96);
  ellipse(doughPos.x, doughPos.y, compartmentSize.x, compartmentSize.y); //Dough Compartment
  ellipse(cheesePos.x, cheesePos.y, compartmentSize.x, compartmentSize.y); //Cheese Compartment
  quad(sausePos.x - (sauseSize.x / 2), sausePos.y - (sauseSize.y / 2) - 8, sausePos.x + (sauseSize.x / 2), sausePos.y - (sauseSize.y / 2) - 8,
  sausePos.x + (sauseSize.x / 1.5) + 8, sausePos.y + (sauseSize.y / 2) + 4, sausePos.x - (sauseSize.x / 1.5) - 8, sausePos.y + (sauseSize.y / 2) + 4);
  
  //Sause in compartment
  strokeWeight(4);
  stroke(160, 0, 0);
  fill(192, 0, 0);
  quad(sausePos.x - (sauseSize.x / 2), sausePos.y - (sauseSize.y / 2), sausePos.x + (sauseSize.x / 2), sausePos.y - (sauseSize.y / 2),
  sausePos.x + (sauseSize.x / 1.5), sausePos.y + (sauseSize.y / 2), sausePos.x - (sauseSize.x / 1.5), sausePos.y + (sauseSize.y / 2));
  
  if(action != UserAction.sausing) //If we are not using the ladle, then draw it in the sause
  {
    PVector pos = new PVector(sausePos.x + (sauseSize.x / 4), sausePos.y);
    //Handle
    noStroke();
    fill(144);
    quad(pos.x + 30, pos.y - 8, pos.x + 30, pos.y + 8, pos.x + 60, pos.y - 64, pos.x + 60, pos.y - 80);
    fill(152);
    quad(pos.x + 60, pos.y - 64, pos.x + 60, pos.y - 80, pos.x + 90, pos.y - 32, pos.x + 90, pos.y - 16);
    
    //Cover Handle
    fill(192, 0, 0);
    ellipse(pos.x, pos.y, 72, 24);
  }
  
  //Dough in compartment
  strokeWeight(4);
  stroke(224, 180, 128);
  fill(255, 224, 160);
  ellipse(doughPos.x, doughPos.y, compartmentSize.x - 8, compartmentSize.y - 32);
  arc(doughPos.x, doughPos.y, compartmentSize.x - 8, compartmentSize.y - 8, 0, PI, OPEN);
  
  //Cheese in compartment
  strokeWeight(4);
  stroke(224, 178, 56);
  fill(255, 224, 64);
  ellipse(cheesePos.x, cheesePos.y, compartmentSize.x - 8, compartmentSize.y - 32);
  arc(cheesePos.x, cheesePos.y, compartmentSize.x - 8, compartmentSize.y - 8, 0, PI, OPEN);
  
  //Compartments
  noStroke();
  fill(144);
  rect(width/2 - 288, 0, 64, 320);
  rect(width/2 + 224, 0, 64, 320);
  DrawToppingArea(new PVector(width/2 - 256, 16), 0);
  DrawToppingArea(new PVector(width/2 - 256, 72), 1);
  DrawToppingArea(new PVector(width/2 - 256, 128), 2);
  DrawToppingArea(new PVector(width/2 - 256, 184), 3);
  DrawToppingArea(new PVector(width/2 - 256, 240), 4);
  DrawToppingArea(new PVector(width/2 - 256, 296), 5);
  DrawToppingArea(new PVector(width/2 + 256, 16), 6);
  DrawToppingArea(new PVector(width/2 + 256, 72), 7);
  DrawToppingArea(new PVector(width/2 + 256, 128), 8);
  DrawToppingArea(new PVector(width/2 + 256, 184), 9);
  DrawToppingArea(new PVector(width/2 + 256, 240), 10);
  DrawToppingArea(new PVector(width/2 + 256, 296), 11);
}

void DrawToppingArea(PVector pos, int t)
{
  noStroke();
  fill(0, 96);
  rect(pos.x-48, pos.y+48, 96,8);
  
  strokeWeight(4);
  fill(96);
  stroke(96);
  rect(pos.x-48, pos.y+32, 96,16);
  stroke(160);
  fill(192);
  quad(pos.x-32, pos.y, pos.x + 32, pos.y, pos.x+48, pos.y+32, pos.x-48, pos.y+32);
  
  CreateTopping(t, new PVector(pos.x, pos.y + 16));
}

void draw() /**************************************************** DRAW ****************************************************/
{
  mouse = new PVector(mouseX, mouseY);
  delta = millis() - lastTime;
  lastTime = millis();  
  deltaTime = (delta / 1000.0);
  
  background(255, 224, 160);
  DrawPizzaPlace();
  if(action == UserAction.inMenu)
  {
    DrawRoller(rollerPos);
    DrawMenu();
  }  
  else
  {
    UpdateGame();
    
    if(action == UserAction.sausing)
      DrawSauseLadle(mouse);
    if(action == UserAction.doughing)
      DrawHangingDough(mouse);
    if(action == UserAction.cheesing)
      DrawHangingCheese(mouse);
    if(action == UserAction.topping && makeTopping != -1)
      CreateTopping(makeTopping, mouse);
      
    DrawTrashCan(new PVector(centerPizzaPos.x + 144, centerPizzaPos.y + 144));
    
    fill(0);
    textSize(16);
    textAlign(CENTER);
    text("Press any key to cycle pizzas", width/2, height-16);
  }
}

void PlayGame()
{
  pizzaTime.play();
  viewOvens = false;
  pizzas = new ArrayList<Pizza>();
  pizzas.add(new Pizza(centerPizzaPos));
  pizzas.add(new Pizza(centerPizzaPos));
  pizzas.add(new Pizza(centerPizzaPos));
  toppingButtons = new ArrayList<Button>();
  CreateToppingButtons();
  currentPizza = 0;
  makeTopping = -1;
  action = UserAction.idle;
}

void CreateToppingButtons()
{
  toppingButtons.add(new Button(new PVector(width/2 - 256, 32), new PVector(96, 32), "", new Color()));
  toppingButtons.add(new Button(new PVector(width/2 - 256, 88), new PVector(96, 32), "", new Color()));
  toppingButtons.add(new Button(new PVector(width/2 - 256, 144), new PVector(96, 32), "", new Color()));
  toppingButtons.add(new Button(new PVector(width/2 - 256, 200), new PVector(96, 32), "", new Color()));
  toppingButtons.add(new Button(new PVector(width/2 - 256, 256), new PVector(96, 32), "", new Color()));
  toppingButtons.add(new Button(new PVector(width/2 - 256, 312), new PVector(96, 32), "", new Color()));
  toppingButtons.add(new Button(new PVector(width/2 + 256, 32), new PVector(96, 32), "", new Color()));
  toppingButtons.add(new Button(new PVector(width/2 + 256, 88), new PVector(96, 32), "", new Color()));
  toppingButtons.add(new Button(new PVector(width/2 + 256, 144), new PVector(96, 32), "", new Color()));
  toppingButtons.add(new Button(new PVector(width/2 + 256, 200), new PVector(96, 32), "", new Color()));
  toppingButtons.add(new Button(new PVector(width/2 + 256, 256), new PVector(96, 32), "", new Color()));
  toppingButtons.add(new Button(new PVector(width/2 + 256, 312), new PVector(96, 32), "", new Color()));
}

void UpdateGame()
{
  UpdatePizzaPositions();
  if(viewOvens) return;
    
  for(int i = 0; i < pizzas.size(); i++)
  {
    Pizza p = pizzas.get(i);
    
    //Pizza pan
    fill(160);
    stroke(128);
    strokeWeight(8);
    ellipse(p.pizzaPos.x, p.pizzaPos.y, pizzaSize + 16, pizzaSize + 16);
    
    if(action == UserAction.rolling)
    {
      if(p.doughLevel >= 0)
      {
        //Increase dough level when rolling over the dough
         PVector roll = new PVector(mouseX - pmouseX, mouseY - pmouseY);
         if(PVector.dist(new PVector(mouseX, mouseY), p.pizzaPos) < (pizzaSize / 2))
         {
           p.doughMag += roll.mag() * deltaTime;
           //println(roll.mag() * deltaTime);  
         }
         
         if(p.doughMag > ((p.doughLevel + 1) * 2))
         {
           p.doughLevel++;
           p.doughMag = 0;  
         }
      }
    }
    
    p.Draw();
  }
  
  DrawRoller((action != UserAction.rolling) ? rollerPos : mouse); //If the user is rolling, go to the mouse, otherwise go on the rack
}

void UpdatePizzaPositions()
{
  for(int i = 0; i < pizzas.size(); i++)
  {
    Pizza p = pizzas.get(i);
    int dif = (i - currentPizza);
    p.pizzaPos = new PVector(centerPizzaPos.x + (dif * (pizzaSize + 56)), centerPizzaPos.y);
  }
}

void DrawRoller(PVector pos)
{
  stroke(232, 186, 134);
  strokeWeight(4);
  fill(232, 186, 134);
  rect(pos.x - 128, pos.y - 4, 256, 8);
  fill(232, 199, 164);
  rect(pos.x - 96, pos.y - 16, rollerSize.x, rollerSize.y);
}

void DrawSauseLadle(PVector pos)
{
  //Ladle
  noStroke();
  fill(128);
  quad(pos.x - 32, pos.y, pos.x + 32, pos.y, pos.x + 24, pos.y + 32, pos.x - 24, pos.y + 32);
  ellipse(pos.x, pos.y + 32, 48, 24);
  stroke(144);
  strokeWeight(4);
  ellipse(pos.x, pos.y, 62, 24);
  
  //Handle
  noStroke();
  fill(144);
  quad(pos.x + 30, pos.y - 8, pos.x + 30, pos.y + 8, pos.x + 60, pos.y - 64, pos.x + 60, pos.y - 80);
  fill(152);
  quad(pos.x + 60, pos.y - 64, pos.x + 60, pos.y - 80, pos.x + 90, pos.y - 32, pos.x + 90, pos.y - 16);
  
  fill(208, 0, 0);
  ellipse(pos.x, pos.y, 58, 8);
  arc(pos.x, pos.y, 58, 22, 0, PI, PIE);
}

void DrawHangingDough(PVector pos)
{
  strokeWeight(4);
  stroke(224, 180, 128);
  fill(255, 224, 160);
  ellipse(pos.x, pos.y, 64, 64);
  arc(pos.x, pos.y, 64, 96, 0, PI, OPEN);
}

void DrawHangingCheese(PVector pos)
{
  strokeWeight(4);
  stroke(224, 178, 56);
  fill(255, 224, 64);
  ellipse(pos.x, pos.y, 64, 64);
}

void DrawFlame(PVector pos)
{
  fill(255, 0, 0);
  stroke(0);
  strokeWeight(2);
  ellipse(pos.x, pos.y+8, 24, 24);
  arc(pos.x, pos.y+12, 16, 64, PI, 2 * PI, OPEN);
  ellipse(pos.x+12, pos.y+8, 12, 16);
  arc(pos.x+12, pos.y+8, 12, 36, PI, 2 * PI, OPEN);
  ellipse(pos.x-12, pos.y+8, 12, 16);
  arc(pos.x-12, pos.y+8, 12, 36, PI, 2 * PI, OPEN);
  noStroke();
  ellipse(pos.x, pos.y+8, 22, 22);
  fill(255, 192, 0);
  ellipse(pos.x, pos.y+12, 12, 12);
  arc(pos.x, pos.y+12, 12, 40, PI, 2*PI);
  ellipse(pos.x+10, pos.y+10, 8,8);
  arc(pos.x+10, pos.y+10, 8, 18, PI, 2*PI);
  ellipse(pos.x-10, pos.y+10, 8, 8);
  arc(pos.x-10, pos.y+10, 8, 18, PI, 2*PI);
}

void DrawOvenmit(PVector pos)
{
  fill(255, 255, 0);
  stroke(0);
  strokeWeight(2);
  ellipse(pos.x+12, pos.y+4, 24, 12);
  arc(pos.x+12, pos.y+4, 24, 16, 0, 3 * QUARTER_PI);
  ellipse(pos.x, pos.y-12, 24, 24);
  rect(pos.x-12, pos.y-16, 24, 32, 8);
  
  stroke(255, 255, 0);
  ellipse(pos.x, pos.y-12, 20, 18);
}

boolean DrawTrashCan(PVector pos)
{
  boolean over = (abs(pos.x - mouseX) < 16 && abs(pos.y - mouseY) < 24);
  fill((over) ? 96 : 128);
  stroke(0);
  strokeWeight(2);
  rect(pos.x - 4, pos.y - 12, 8, 4);
  rect(pos.x - 12, pos.y - 8, 24, 8, 4);
  rect(pos.x - 9, pos.y, 18, 24);
  line(pos.x - 3, pos.y + 8, pos.x - 3, pos.y + 24);
  line(pos.x + 3, pos.y + 8, pos.x + 3, pos.y + 24);
  return over;
}

void mousePressed() /******************************************* MOUSE PRESSED ********************************************/
{
  if(action == UserAction.inMenu)
  {
    if(menuButtons.get(0).MouseOver())//If hovering over the play button
      PlayGame();
    else if(menuButtons.get(1).MouseOver())//If hovering over the quit button
      exit();
  }
  else if(action == UserAction.idle)
  {
    if(OverDough())
      action = UserAction.doughing;
    if(OverRoller())
      action = UserAction.rolling;
    if(OverSause())
      action = UserAction.sausing;
    if(OverCheese())
      action = UserAction.cheesing;
    for(int i = 0; i < toppingButtons.size(); i++)
    {
      Button b = toppingButtons.get(i);
      if(b.MouseOver())
      {
        action = UserAction.topping;
        makeTopping = i;
        break;
      }
    }
    for(int p = 0; p < pizzas.size(); p++)
    {
      Pizza pizza = pizzas.get(p);
      for(int i = pizza.toppings.size() - 1; i >= 0; i--)
      {
        Topping t = pizza.toppings.get(i);
        if(t.MouseOver(pizza.pizzaPos))
        {
          pizza.toppings.remove(i);
          break; //Don't continue the loop since the list has changed
        }
      }
    }
    if(DrawTrashCan(new PVector(centerPizzaPos.x + 144, centerPizzaPos.y + 144)))
        pizzas.set(currentPizza, new Pizza(centerPizzaPos));
  }
}

void mouseReleased() /****************************************** MOUSE RELEASED *******************************************/
{
  if(action == UserAction.inMenu || action == UserAction.idle)
    return;
    
  int p = OverPizza();
  switch(action)
  {
    case doughing:
      if(p != -1)
      {
        Pizza currentPizza = pizzas.get(p);
        if(currentPizza.doughLevel == -1)
          currentPizza.doughLevel = 0;
      }
    break;
    case sausing:
      if(p != -1)
      {
        Pizza currentPizza = pizzas.get(p);
        if(!currentPizza.cheese && !currentPizza.sause && currentPizza.doughLevel >= 10 && currentPizza.toppings.size() == 0)
          currentPizza.sause = true;
      }
    break;
    case cheesing:
      if(p != -1)
      {
        Pizza currentPizza = pizzas.get(p);
        if(!currentPizza.cheese && currentPizza.doughLevel >= 10 && currentPizza.toppings.size() == 0)
          currentPizza.cheese = true;
      }
    break;
    case topping:
      if(p != -1)
      {
        Pizza currentPizza = pizzas.get(p);
        if(currentPizza.doughLevel >= 10)
        {
          Topping t = new Topping(makeTopping, PVector.sub(mouse, currentPizza.pizzaPos));
          currentPizza.toppings.add(t);
        }
      }
    break;
  }
  action = UserAction.idle;
}

void keyPressed()
{
  if(currentPizza >= pizzas.size()-1)
    currentPizza = 0;
  else
    currentPizza++;
}

int OverPizza()
{
  for(int i = 0; i < pizzas.size(); i++)
  {
    Pizza p = pizzas.get(i);
    if(PVector.dist(mouse, p.pizzaPos) < (pizzaSize / 2))
      return i;
  }
  return -1;
}

boolean OverRoller()
{
  return (abs(mouseX - rollerPos.x) < (rollerSize.x / 2) && abs(mouseY - rollerPos.y) < (rollerSize.y / 2));
}

boolean OverDough()
{
  return (abs(mouseX - doughPos.x) < (compartmentSize.x / 2) && abs(mouseY - doughPos.y) < (compartmentSize.y / 2));
}

boolean OverSause()
{
  return (abs(mouseX - sausePos.x) < (sauseSize.x / 2) && abs(mouseY - sausePos.y) < (sauseSize.y / 2));
}

boolean OverCheese()
{
  return (abs(mouseX - cheesePos.x) < (compartmentSize.x / 2) && abs(mouseY - cheesePos.y) < (compartmentSize.y / 2));
}

void DrawTopping(Topping t, PVector pos)
{
  CreateTopping(t.index, PVector.add(pos, t.localPos));
}

void CreateTopping(int i, PVector pos)
{
  noFill();
  noStroke();
  switch(i)
  {
    case 1: //Sausage
    fill(160, 96, 48);
    ellipse(pos.x, pos.y, 16, 16);
    ellipse(pos.x + 4, pos.y + 4, 8, 8);
    fill(128, 64, 24);
    ellipse(pos.x +2, pos.y - 6, 8, 8);
    ellipse(pos.x - 4, pos.y + 6, 6, 6);
    ellipse(pos.x - 6, pos.y - 4, 4, 4);
    ellipse(pos.x + 6, pos.y + 4, 6, 6);
    break;
    case 2: //Grilled chicken
    fill(255, 192, 160);
    rect(pos.x - 16, pos.y - 10, 32, 20, 8);
    fill(224, 180, 128);
    rect(pos.x - 16, pos.y - 10, 32, 16, 4);
    fill(192, 160, 96);
    rect(pos.x-8, pos.y - 6, 16, 2);
    rect(pos.x-12, pos.y - 2, 24, 2);
    rect(pos.x-8, pos.y + 3, 16, 2);
    break;
    case 3: //Meatball
    fill(128, 64, 64);
    ellipse(pos.x, pos.y, 20, 20);
    ellipse(pos.x+8, pos.y, 8, 12);
    ellipse(pos.x, pos.y-8, 12, 8);
    ellipse(pos.x-8, pos.y, 8, 12);
    ellipse(pos.x-6, pos.y-6, 9, 9);
    ellipse(pos.x+6, pos.y-6, 9, 9);
    ellipse(pos.x+6, pos.y+6, 9, 9);
    ellipse(pos.x-6, pos.y+6, 9, 9);
    ellipse(pos.x, pos.y+8, 12, 8);
    break;
    case 4: //Bacon
    fill(128, 64, 64);
    rect(pos.x - 14, pos.y - 8, 28, 16, 2);
    fill(192, 128, 128);
    rect(pos.x - 12, pos.y - 6, 24, 4, 2);
    fill(160, 72, 72);
    rect(pos.x - 12, pos.y + 4, 24, 2, 2);
    break;
    case 5: //Canadian Bacon
    stroke(160, 72, 72);
    strokeWeight(2);
    fill(192, 128, 128);
    ellipse(pos.x, pos.y, 20, 20);
    break;
    case 6: //Mushroom
    fill(192, 128, 128);
    arc(pos.x, pos.y, 20, 20, PI, 2*PI, OPEN);
    stroke(192, 128, 128);
    strokeWeight(8);
    line(pos.x, pos.y, pos.x, pos.y + 8);
    break;
    case 7: //Green pepper
    stroke(64, 192, 96);
    strokeWeight(8);
    bezier(pos.x-12, pos.y+4, pos.x-8, pos.y-4, pos.x+8, pos.y-4, pos.x+12, pos.y+4);
    break;
    case 8: //Olives
    noFill();
    stroke(32, 16, 8);
    strokeWeight(4);
    ellipse(pos.x, pos.y, 12, 12);
    break;
    case 9: //Spinach
    fill(32, 128, 64);
    ellipse(pos.x, pos.y, 16, 16);
    arc(pos.x, pos.y, 16, 24, PI, 2*PI, OPEN);
    stroke(32, 128, 64);
    strokeWeight(4);
    line(pos.x, pos.y, pos.x, pos.y + 12);
    break;
    case 10: //Onion
    stroke(192, 32, 96);
    strokeWeight(4);
    bezier(pos.x-12, pos.y+4, pos.x-4, pos.y-4, pos.x+4, pos.y-4, pos.x+12, pos.y+4);
    break;
    case 11: //Pineapple
    fill(255, 192, 96);
    quad(pos.x+4, pos.y-6, pos.x-4, pos.y-6, pos.x-8, pos.y+6, pos.x+8, pos.y+6);
    break;
    default: //Default anything else to Pepporoni
    stroke(160, 0, 0);
    strokeWeight(2);
    fill(192, 0, 0);
    ellipse(pos.x, pos.y, 20, 20);
    fill(160, 0, 0);
    ellipse(pos.x - 2, pos.y + 3, 2, 2);
    ellipse(pos.x + 4, pos.y - 2, 4, 4);
    ellipse(pos.x - 3, pos.y - 4, 2, 2);
    break;
  }
}

public class Topping
{
  public int index = 0;
  public PVector localPos;
  
  public Topping()
  {
    index = 0;
    localPos = new PVector(0, 0);
  }
  
  public Topping(int i, PVector lPos)
  {
    index = i;
    localPos = lPos;
  }
  
  public boolean MouseOver(PVector pizzaPos)
  {
    PVector pos = PVector.add(pizzaPos, localPos);
    return (abs(mouseX - pos.x) < 8 && abs(mouseY - pos.y) < 8);
  }
}

public class Pizza
{
  public ArrayList<Topping> toppings;
  public PVector pizzaPos;
  public boolean sause = false;
  public boolean cheese = false;
  public int doughLevel = -1;
  public float doughMag = 0;
  public float cooked = 0;

  public Pizza(PVector p)
  {
    pizzaPos = p;
    toppings = new ArrayList<Topping>();
    sause = false;
    cheese = false;
    doughLevel = -1;
    doughMag = 0;
    cooked = 0;
  }
  
  public void Draw()
  {
    if(doughLevel < 10)
    {
      strokeWeight(4);
      stroke(224, 180, 128);
      fill(255, 224, 160);
      switch(doughLevel)
      {
        case 0:
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize / 3, pizzaSize / 4);
        arc(pizzaPos.x, pizzaPos.y, pizzaSize / 3, pizzaSize / 3, PI, 2*PI, OPEN);
        break;
        case 1:
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize / 2.5, pizzaSize / 5);
        arc(pizzaPos.x, pizzaPos.y, pizzaSize / 2.5, pizzaSize / 3.5, PI, 2*PI, OPEN);
        break;
        case 2:
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize / 2, pizzaSize / 6);
        arc(pizzaPos.x, pizzaPos.y, pizzaSize / 2, pizzaSize / 4, PI, 2*PI, OPEN);
        break;
        case 3:
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize / 2, pizzaSize / 3);
        arc(pizzaPos.x, pizzaPos.y, pizzaSize / 2, pizzaSize / 2.8, PI, 2*PI, OPEN);
        break;
        case 4:
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize / 1.8, pizzaSize / 2.8);
        arc(pizzaPos.x, pizzaPos.y, pizzaSize /  1.8, pizzaSize / 2.5, PI, 2*PI, OPEN);
        break;
        case 5:
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize / 1.6, pizzaSize / 2.5);
        arc(pizzaPos.x, pizzaPos.y, pizzaSize /  1.6, pizzaSize / 2.1, PI, 2*PI, OPEN);
        break;
        case 6:
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize / 1.4, pizzaSize / 2.1);
        arc(pizzaPos.x, pizzaPos.y, pizzaSize /  1.4, pizzaSize / 1.7, PI, 2*PI, OPEN);
        break;
        case 7:
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize / 1.3, pizzaSize / 1.7);
        arc(pizzaPos.x, pizzaPos.y, pizzaSize /  1.3, pizzaSize / 1.3, PI, 2*PI, OPEN);
        break;
        case 8:
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize / 1.2, pizzaSize / 1.3);
        arc(pizzaPos.x, pizzaPos.y, pizzaSize /  1.2, pizzaSize / 1.1, PI, 2*PI, OPEN);
        break;
        case 9:
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize / 1.1, pizzaSize / 1.1);
        break;
        case 10:
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize, pizzaSize);
        break;
      }
    }
    else
    {
      noStroke();
      fill(255, 224, 160);
      if(sause)
        fill(208, 0, 0);
      ellipse(pizzaPos.x, pizzaPos.y, pizzaSize, pizzaSize);
      
      if(cheese)
      {
        strokeWeight(4);
        stroke(224, 178, 56);
        fill(255, 224, 64);
        ellipse(pizzaPos.x, pizzaPos.y, pizzaSize - 24, pizzaSize- 24);
      }
      
      for(int i = 0; i < toppings.size(); i++)
        DrawTopping(toppings.get(i), pizzaPos);
        
      noFill();
      stroke(224, 160, 128);    
      strokeWeight(16);
      ellipse(pizzaPos.x, pizzaPos.y, pizzaSize, pizzaSize);
    }
  }
  
  public void LoadPizza(Pizza p)
  {
    pizzaPos = p.pizzaPos;
    sause = p.sause;
    cheese = p.cheese;
    doughLevel = p.doughLevel;
    doughMag = p.doughMag;
    cooked = p.cooked;
    toppings = new ArrayList<Topping>();
    for(int i = 0; i < p.toppings.size(); i++)
      toppings.add(p.toppings.get(i));
  }
}

public class Button
{
  public PVector pos;
  public PVector size;
  public Color col;
  public String text;
  
  public Button()
  {
    pos = new PVector(0, 0);
    size = new PVector(32, 32);
    col = new Color();
    text = "Button";
  }
  
  public Button(PVector p, PVector s, String t, Color c)
  {
    pos = p;
    size = s;
    col = c;
    text = t;
  }
  
  public void Draw()
  {
    stroke(0);
    strokeWeight(4);
    float a = (MouseOver()) ? 128 : 255; //Go transparent if held over
    fill(col.r, col.g, col.b, a);
    rect(pos.x - (size.x / 2), pos.y - (size.y / 2), size.x, size.y, 16);
    textSize(size.y / 2);
    textAlign(CENTER);
    
    fill(0);
    text(text, pos.x, pos.y + (size.y / 4) - 4);
  }
  
  public boolean MouseOver()
  {
    return (abs(mouseX - pos.x) < (size.x / 2) && abs(mouseY - pos.y) < (size.y / 2));
  }
}

public class Color
{
  public int r;
  public int g;
  public int b;
  
  public Color()
  {
    r = 0; g = 0; b= 0;
  }
  
  public Color(int Nr, int Ng, int Nb)
  {
    r = Nr; g = Ng; b = Nb;
  }
}
