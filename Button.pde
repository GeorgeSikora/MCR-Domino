
final int BUTTON_WIDTH = 100;
final int BUTTON_HEIGHT = 42;

class Button
{
  String text;
  int x, y;
  boolean hover = false;
  
  Button(String text, int x, int y)
  {
    this.text = text;
    this.x = x;
    this.y = y;
  }
  
  void draw()
  { 
    if (mouseOver())
    {
      hover = true;
      stroke(255, 255, 255);
      fill(255, 0, 255);
    }
    else
    {
      hover = false;
      stroke(255, 0, 255);
      fill(255, 200, 255);
    }
    rectMode(CORNER);
    rect(x, y, BUTTON_WIDTH, BUTTON_HEIGHT, 8);
    
    fill(0);
    textSize(18);
    textAlign(CENTER, CENTER);
    text(text, x + BUTTON_WIDTH/2, y + BUTTON_HEIGHT/2 - 2);

  }

  boolean mouseOver()
  {
    return (mouseX > x && mouseY > y && mouseX < x + BUTTON_WIDTH && mouseY < y + BUTTON_HEIGHT);
  }
}
