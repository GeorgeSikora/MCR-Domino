
final int STONE_VERTICAL = 0;
final int STONE_HORIZONTAL = 1;

final int STONE_SELECTED_BORDER = 4;

class Stone {
  
  Cell cell1, cell2;
  
  Stone(Cell cell1, Cell cell2)
  {
    this.cell1 = cell1;
    this.cell2 = cell2;
  }
  
  void draw()
  {
    strokeWeight(STONE_SELECTED_BORDER);
    noFill();
    
    int cx = cell1.x * CELL_SIZE, cy = cell1.y * CELL_SIZE;
    
    if (getOrientation() == STONE_VERTICAL)
    {
      stroke(0, 0, 255); 
      rect(cx + STONE_SELECTED_BORDER, cy + STONE_SELECTED_BORDER, CELL_SIZE - STONE_SELECTED_BORDER, 2 * CELL_SIZE - STONE_SELECTED_BORDER);
    }
    else
    {
      stroke(255, 0, 0);
      rect(cx + STONE_SELECTED_BORDER, cy + STONE_SELECTED_BORDER, 2 * CELL_SIZE - STONE_SELECTED_BORDER, CELL_SIZE - STONE_SELECTED_BORDER);
    }
    strokeWeight(1);
  }
  
  int getOrientation()
  {
    if (cell1.y < cell2.y)
    {
      return STONE_VERTICAL;
    }
    
    if (cell1.x < cell2.x)
    {
      return STONE_HORIZONTAL;
    }
    
    return 0;
  }
}
