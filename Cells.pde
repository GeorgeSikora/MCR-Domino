
final int ORIENT_SINGLE = 0;
final int ORIENT_HORIZONTAL = 1;
final int ORIENT_VERTICAL = 2;
final int ORIENT_DIAGONAL_LEFT = 3;
final int ORIENT_DIAGONAL_RIGHT = 4;

class Cell {
  
  int x, y, eyeCount, orientation;
  ArrayList<PVector> eyes;

  Cell(int x, int y, ArrayList<PVector> eyes)
  {
    this.x = x;
    this.y = y;
    this.eyes = eyes;
    this.eyeCount = eyes.size();
    this.orientation = getOrientation();
  }
  
  int getOrientation()
  {
    int ys = eyes.size();
    
    if (ys == 3 || ys == 2)
    {
      int lineX = (int)eyes.get(0).x;
      
      if (lineX < eyes.get(1).x)
      {
        return ORIENT_DIAGONAL_RIGHT;
      }
      else
      {
        return ORIENT_DIAGONAL_LEFT;
      }
    }
    
    if (ys == 6)
    {
      int lineX = (int)eyes.get(0).x;
      
      if (lineX == (int)eyes.get(2).x)
      {
        return ORIENT_VERTICAL;
      }
      else
      {
        return ORIENT_HORIZONTAL;
      }
    }
    
    return ORIENT_SINGLE;
  }
  
  PVector getCenterPos()
  {
   return new PVector(x * CELL_SIZE + CELL_SIZE/2, y * CELL_SIZE + CELL_SIZE/2); 
  }
  
  Stone getStone()
  {
    for (Stone stone : stones)
    {
      if (this == stone.cell1 || this == stone.cell2)
      {
        return stone; 
      }
    }
    
    return null;
  }
}
