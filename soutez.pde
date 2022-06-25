
final int CELLS_HORIZONTAL   = 8;
final int CELLS_VERTICAL     = 7;
final int CELLS_COUNT        = CELLS_HORIZONTAL * CELLS_VERTICAL;
final int IMG_SIZE           = 482;
final int CELL_EYE_OFFSET    = 16;
final color EYE_THRESHOLD    = color(127); 
final int CELL_SIZE          = IMG_SIZE / CELLS_HORIZONTAL;
final String SAVE_FILENAME   = "reseni.bmp";
final String SOURCE_FILENAME = "priklad01.bmp";
final int CELL_MIDDLE_LINE_OFFSET = 8;

PImage fieldImage;

Cell[] cells;
ArrayList<Stone> stones = new ArrayList<Stone>();

Button btnHint, btnComplete;

String alertMessage = "";
boolean gameFinished = false;

void settings()
{
  size(IMG_SIZE, IMG_SIZE);
}

void setup()
{ 
  btnHint     = new Button("Nápověda", 10, height - BUTTON_HEIGHT - 10);
  btnComplete = new Button("Dokončit", 10 + BUTTON_WIDTH + 10, height - BUTTON_HEIGHT - 10);
  
  fieldImage = loadImage("assets/" + SOURCE_FILENAME);
  
  cells = getCellsFromImage(fieldImage);
}

void draw()
{
  background(0);
  image(fieldImage, 0, 0);
  
  fill(255, 0, 255);
  noStroke();
  
  btnHint.draw();
  btnComplete.draw();
  
  for (Stone stone : stones)
  {
    stone.draw();
  }
  //rect(0, 0, CELL_SIZE, CELL_SIZE);
  //circle(10, 10, 8);
  /*
  noStroke();
  fill(255, 80);
  rect(0, 0, 100, 32);
  fill(0);
  text(isSpaceToPlace() ? "Je místo" : "Není!", 10, 10);
  */
  
  if (alertMessage.length() > 0)
  {
    noStroke();
    
    fill(255, 220);
    rectMode(CENTER);
    rect(width/2, height/2, width, height);
    
    fill(0);
    textSize(28);
    text(alertMessage, width/2, height/2 - 4);
    
    textSize(14);
    text("Pro zavření klikni", width/2, height/2 + 24);
  }
  
  if (gameFinished) 
  {
    noLoop();
    return;
  }
}

void mousePressed()
{
  if (alertMessage.length() > 0)
  {
    alertMessage = "";
    return;
  }
  
   int mx = mouseX, my = mouseY;
   
   if (mx > 0 && my > 0 && mx < IMG_SIZE && my < IMG_SIZE)
   {
     // Verikální uložení kamene
     for (int yy = 0; yy < CELLS_VERTICAL-1; yy++)
     {
        for (int xx = 0; xx < CELLS_HORIZONTAL; xx++)
        {
          Cell c1 = getCellOnPos(xx, yy), c2 = getCellOnPos(xx, yy+1);
          
          if (c1 == null || c2 == null) continue;
          
          PVector c1pos = c1.getCenterPos(), c2pos = c2.getCenterPos();
          
          if (c1pos.y < my && c2pos.y > my && abs(c1pos.x - mx) < CELL_SIZE / 2 && abs(c1pos.y + CELL_SIZE/2 - my) < CELL_MIDDLE_LINE_OFFSET)
          {
            if (tryRemoveStoneWhereCells(c1, c2)) break;
            
            placeStone(c1, c2);
          }
        }
     }
      
     // Horizontální uložení kamene
     for (int yy = 0; yy < CELLS_VERTICAL; yy++)
     {
        for (int xx = 0; xx < CELLS_HORIZONTAL-1; xx++)
        {
          Cell c1 = getCellOnPos(xx, yy), c2 = getCellOnPos(xx+1, yy);
          
          if (c1 == null || c2 == null) continue;
          
          PVector c1pos = c1.getCenterPos(), c2pos = c2.getCenterPos();
          
          if (c1pos.x < mx && c2pos.x > mx && abs(c1pos.y - my) < CELL_SIZE/2 && abs(c1pos.x + CELL_SIZE/2 - mx) < CELL_MIDDLE_LINE_OFFSET)
          {
            if (tryRemoveStoneWhereCells(c1, c2)) break;
            
            placeStone(c1, c2);
          }
        }
     }
  
      if (isFinished())
      {
         saveField();
         alertMessage = "Hra dokončena!";
         gameFinished = true;
         return;
      }
       
     if (!isSpaceToPlace())
     {
       alertMessage = "Došlo místo na kameny!";
     }
   }
   
   if (btnHint.hover)
   {
     placeHint();
     alertMessage = "";
   }
   
   if (btnComplete.hover)
   {
     completeStonesField();
   }
}

void placeHint()
{ 
   // Verikální uložení kamene
   for (int yy = 0; yy < CELLS_VERTICAL-1; yy++)
   {
      for (int xx = 0; xx < CELLS_HORIZONTAL; xx++)
      {
        Cell c1 = getCellOnPos(xx, yy), c2 = getCellOnPos(xx, yy+1);
        
        if (c1 == null || c2 == null) continue;
        
        if (placeStone(c1, c2)) return;
      }
   }
    
   // Horizontální uložení kamene
   for (int yy = 0; yy < CELLS_VERTICAL; yy++)
   {
      for (int xx = 0; xx < CELLS_HORIZONTAL-1; xx++)
      {
        Cell c1 = getCellOnPos(xx, yy), c2 = getCellOnPos(xx+1, yy);
        
        if (c1 == null || c2 == null) continue;
       
        if (placeStone(c1, c2)) return;
      }
   }
}

void completeStonesField()
{
   for (int i = 0; i < 100; i++)
   {
     /*
     // Horizontal Stone Pos, Vertical Stone Pos
     PVector hsp, vsp;
     // Horizontal Placed, Vertical Places
     boolean hp, vp;
     
     hp = tryPlaceHorizontalStone();
     
     if (hp)
     {
       Stone s = stones.get(stones.size() - 1);
       hsp = new PVector(s.cell1.x, s.cell1.y);
       stones.remove(stones.size() - 1);
     }
     
     vp = tryPlaceVerticalStone();
     
     if (vp)
     {
       Stone s = stones.get(stones.size() - 1);
       vsp = new PVector(s.cell1.x, s.cell1.y);
       stones.remove(stones.size() - 1);
     }
     */
     
     tryPlaceHorizontalStone();
     tryPlaceVerticalStone();
   }
     
   if (isFinished())
   {
     alertMessage = "Vyřešeno!";
   }
   else
   { 
     alertMessage = "Nepodařilo se dokončit!";
   }
   return;  
}

boolean tryPlaceVerticalStone()
{
   // Verikální uložení kamene
   for (int yy = 0; yy < CELLS_VERTICAL-1; yy++)
   {
      for (int xx = 0; xx < CELLS_HORIZONTAL; xx++)
      {
        Cell c1 = getCellOnPos(xx, yy), c2 = getCellOnPos(xx, yy+1);
        
        if (c1 == null || c2 == null) continue;
        
        if (placeStone(c1, c2))
        {
         return true; 
        }
      }
   } 
   return false;
}

boolean tryPlaceHorizontalStone()
{
   // Horizontální uložení kamene
   for (int yy = 0; yy < CELLS_VERTICAL; yy++)
   {
      for (int xx = 0; xx < CELLS_HORIZONTAL-1; xx++)
      {
        Cell c1 = getCellOnPos(xx, yy), c2 = getCellOnPos(xx+1, yy);
        
        if (c1 == null || c2 == null) continue;
        
        if (placeStone(c1, c2))
        {
         return true; 
        }
      }
   }
   return false;
}

boolean tryRemoveStoneWhereCells(Cell c1, Cell c2)
{
  for (int i = 0; i < stones.size(); i++)
  {
    Stone s = stones.get(i);
    
    if (s.cell1 == c1 && s.cell2 == c2)
    {
      stones.remove(i);
      return true;
    }
  }
  return false;
}

boolean placeStone(Cell c1, Cell c2)
{
  Stone stone = new Stone(c1, c2);
  
  if (c1.getStone() != null || c2.getStone() != null)
  {
    alertMessage = "Již obsazeno okolním kamenem!";
    return false;
  }
  
  if (isStoneAlreadyTaken(stone))
  {
    alertMessage = "Již shodný kámen vybrán!";
    return false; 
  }
  
  if (!isCellsOriented(c1, c2))
  {
    alertMessage = "Není shodná orientace!";
    return false; 
  }
  
  stones.add(stone);
  
  if (hasFieldOddCell())
  {
    stones.remove(stones.size() - 1);
    alertMessage = "Lichý počet čtverců!";
    return false; 
  }
  
  return true;
}

boolean isCellsOriented(Cell c1, Cell c2)
{ 
  if (c1.orientation == c2.orientation)
  {
    return true;     
  }
  
  if (c1.orientation == ORIENT_SINGLE || c2.orientation == ORIENT_SINGLE)
  {
    return true; 
  }
  
  if (c1.orientation == ORIENT_HORIZONTAL && c2.orientation == ORIENT_DIAGONAL_LEFT ||
      c1.orientation == ORIENT_HORIZONTAL && c2.orientation == ORIENT_DIAGONAL_RIGHT ||
      c1.orientation == ORIENT_VERTICAL && c2.orientation == ORIENT_DIAGONAL_LEFT ||
      c1.orientation == ORIENT_VERTICAL && c2.orientation == ORIENT_DIAGONAL_RIGHT ||
      c2.orientation == ORIENT_HORIZONTAL && c1.orientation == ORIENT_DIAGONAL_LEFT ||
      c2.orientation == ORIENT_HORIZONTAL && c1.orientation == ORIENT_DIAGONAL_RIGHT ||
      c2.orientation == ORIENT_VERTICAL && c1.orientation == ORIENT_DIAGONAL_LEFT ||
      c2.orientation == ORIENT_VERTICAL && c1.orientation == ORIENT_DIAGONAL_RIGHT)
  {
    return true; 
  }
  
  return false;
}

Cell[] getCellsFromImage(PImage img)
{
  Cell[] cells = new Cell[CELLS_VERTICAL * CELLS_HORIZONTAL];
  int i = 0;
  
  for (int yy = 0; yy < CELLS_VERTICAL; yy++)
  {
    for (int xx = 0; xx < CELLS_HORIZONTAL; xx++)
    {
       cells[i++] = new Cell(xx, yy, getCellPosEyes(img, xx, yy));
    }     
  }
  
  return cells;
}

ArrayList<PVector> getCellPosEyes(PImage img, int x, int y)
{ 
  int tx = x * CELL_SIZE + CELL_SIZE / 2;
  int ty = y * CELL_SIZE + CELL_SIZE / 2;
  
  PVector[] eyePoses = {
    new PVector(tx - CELL_EYE_OFFSET, ty - CELL_EYE_OFFSET),
    new PVector(tx,                   ty - CELL_EYE_OFFSET),
    new PVector(tx + CELL_EYE_OFFSET, ty - CELL_EYE_OFFSET),
    
    new PVector(tx - CELL_EYE_OFFSET, ty                  ),
    new PVector(tx,                   ty                  ),
    new PVector(tx + CELL_EYE_OFFSET, ty                  ),
    
    new PVector(tx - CELL_EYE_OFFSET, ty + CELL_EYE_OFFSET),
    new PVector(tx,                   ty + CELL_EYE_OFFSET),
    new PVector(tx + CELL_EYE_OFFSET, ty + CELL_EYE_OFFSET)
  };
  
  ArrayList<PVector> eyes = new ArrayList<PVector>();

  for (int i = 0; i < eyePoses.length; i++) 
  {
    PVector eyePos = eyePoses[i];
    
    boolean hasEye = img.get((int)eyePos.x, (int)eyePos.y) < EYE_THRESHOLD;
     
    if (hasEye)
    {
      noStroke();
      fill(255, 0, 255);
      circle(eyePos.x, eyePos.y, 8);
      
      eyes.add(new PVector(eyePos.x, eyePos.y));
    }
  }
  
  return eyes;
}

boolean isStoneAlreadyTaken(Stone stone)
{
  for (Stone s : stones)
  {
    boolean sameStraight  = (s.cell1.eyeCount == stone.cell1.eyeCount && s.cell2.eyeCount == stone.cell2.eyeCount);
    boolean sameCrossed   = (s.cell1.eyeCount == stone.cell2.eyeCount && s.cell1.eyeCount == stone.cell2.eyeCount);
    
    if (sameStraight || sameCrossed)
    {
       return true;
    }
  }
  return false;
}

Cell getCellOnPos(int x, int y)
{
  if (cells == null) return null;
  
  for (int i = 0; i < cells.length; i++)
  {
    Cell c = cells[i];
    
    if (c.x == x && c.y == y)
    {
      return c; 
    }
  }
  return null;
}

boolean isSpaceToPlace()
{
   boolean hasSpace = false;
   
   // Verikální uložení kamene
   for (int yy = 0; yy < CELLS_VERTICAL-1; yy++)
   {
      for (int xx = 0; xx < CELLS_HORIZONTAL; xx++)
      {
        Cell c1 = getCellOnPos(xx, yy), c2 = getCellOnPos(xx, yy+1);
        
        if (c1 == null || c2 == null) continue;
        
        if (c1.getStone() == null && c2.getStone() == null)
        {
          hasSpace = true;
        }
      }
   }
    
   // Horizontální uložení kamene
   for (int yy = 0; yy < CELLS_VERTICAL; yy++)
   {
      for (int xx = 0; xx < CELLS_HORIZONTAL-1; xx++)
      {
        Cell c1 = getCellOnPos(xx, yy), c2 = getCellOnPos(xx+1, yy);
        
        if (c1 == null || c2 == null) continue;
      
        if (c1.getStone() == null && c2.getStone() == null)
        {
          hasSpace = true;
        }
      }
   }
   
   return hasSpace;
}

boolean hasFieldOddCell()
{
   for (int yy = 0; yy < CELLS_VERTICAL; yy++)
   {
      for (int xx = 0; xx < CELLS_HORIZONTAL; xx++)
      {
        // current cell
        Cell cc = getCellOnPos(xx, yy);
        
        if (cc == null || cc.getStone() != null) continue;
        
        // cell left, right, top, bottom
        Cell  cl = getCellOnPos(xx-1, yy  ), 
              cr = getCellOnPos(xx+1, yy  ), 
              ct = getCellOnPos(xx,   yy-1), 
              cb = getCellOnPos(xx,   yy+1);
              
        // placed left, right, top, bottom
        boolean pl = false, pr = false, pt = false, pb = false;
        
        if (cl == null) pl = true;
        if (cr == null) pr = true;
        if (ct == null) pt = true;
        if (cb == null) pb = true; 
        
        if (cl != null && cl.getStone() != null) pl = true;
        if (cr != null && cr.getStone() != null) pr = true;
        if (ct != null && ct.getStone() != null) pt = true;
        if (cb != null && cb.getStone() != null) pb = true;
      
        if (pl && pr && pt && pb)
        {
          return true; 
        }
      }
   }
   
   return false;
}

boolean isFinished()
{
  for (int i = 0; i < cells.length; i++)
  {
    Cell c = cells[i];
    
    if (c.getStone() == null)
    {
      return false;
    }
  }
  return true;
}

void removeStones()
{
  for (int j = stones.size(); j-- != 0; stones.remove(j)); 
}

void saveField()
{
  PImage img = get(0, 0, CELLS_HORIZONTAL * CELL_SIZE, CELLS_VERTICAL * CELL_SIZE);
  
  img.save(SAVE_FILENAME);
}
