# Lab 6
### Organization
#### 03/17/2019 : 95/100 Points

1. Adhere to the theme: Retro Games
2. Define and call three of your own functions
* A function definition begins with the type of information the function will return (or output) when it's done
  * void myFunctionName ( ) { }
  * int sureThing ( ) { return -1; }
  * boolean trueOrFalse ( ) { return false; }
* Next is the function's name
  * void eyeball ( ) { }
  * void socket ( ) { }
  * void foo ( ) { }
* The next is the function's signature, a comma-separated list of parameters between parentheses. Parameters are the information the function needs as inputs in order to do its job. Each parameter consists of the data type and name of the parameter
  * void eyeball (float centerX, float centerY, color iris) { }
  * float average (float a, float b, float c) { return (a + b + c) / 3.0; }
* The last is the function definition's body in-between curly braces, the list of instructions to be executed when the function is called. If you promised that the definition would output information, be sure to include a return statement followed by information of that type
  * void drawNose () { ellipse(30, 40, 20, 50); ellipse(30, 65, 35, 35); }
  * PVector newLocation() { return new PVector(width / 2.0, height / 2.0, 0); }
3. Define and construct an instance of one class
* Create a new tab by clicking on the white arrow underneath the Run and Stop buttons
* Give the tab the same name as the class you intend to create. Enter class ClassName { }
* Define a constructor for the class in the new tab. class ClassName { ClassName() { } }
* In the main tab above setup, declare a variable of the class's data type. ClassName myInstanceVar;
* Initialize the variable using the class's constructor. void setup() { myInstanceVar = new ClassName(); }
* Access the instance's (object's) variables and methods using dot syntax
  * myInstanceVar.radius = 50;
  * myInstanceVar.pingPong();
* The first tab that opens when you create a new Processing sketch is your default, main sketch .pde. This is the only tab and the only .pde file that can contain void setup and void draw at global scope
4. Ensure that the code contains at least 4 single- or multi-line comments, written in complete sentences, that explain what the code is doing at key steps
