Tile [] [] tiles = new Tile[10][10];//24x20 18x14 10x8
resetButton tron = new resetButton(410,25,75,25);
difficultyButton ez = new difficultyButton(410,50,75,25, 0);
difficultyButton mid = new difficultyButton(410,75,75,25, 1);
difficultyButton hard = new difficultyButton(410,100,75,25, 2);
difficultyButton[] buttons = {ez, mid, hard};
boolean gameOver = false;
int totalMines, tilesPopped; //wincondition variables
boolean zeroGen;
PFont font;
void setup(){
  size(500,400);
  tilesPopped = 0;
  totalMines = 0;
  font = createFont("SansSerif", 12);
  textFont(font);
  for (int i = 0; i < tiles.length; i++){ //fill the grid with tiles
    for (int j = 0; j < tiles[i].length; j++){
      tiles[i][j]=(new Tile(i*20, j*20));
      if (tiles[i][j].hasMine()){totalMines++;} //counts total mines for wincondition
    }
  }
  for (int r = 0; r < tiles.length; r++){ //count each tile's minesNear and storeInVar
    for (int c = 0; c < tiles[r].length;c++){
      tiles[r][c].setMinesNear(countmines(r,c));
    }
  }

}

void draw(){
  background(200);
  if (!gameOver){
    for (int i = 0; i < tiles.length; i++){ //show tiles
      for (int j = 0; j < tiles[i].length;j++){
        tiles[i][j].show();
        tiles[i][j].detectConditions(); //is game over?
      }
    }
    //gameOver = true; //cheatcodes
    //tilesPopped = 400-totalMines;
  } else{
    noLoop();
    if(winCondition()){
      fill(255,200);
      rect(155,180,90,30);
      fill(50,200,50);
      textSize(15);
      text("You Win! :)",160,200);
    } else{
      for (int i = 0; i < tiles.length; i++){ //show bombs
        for (int j = 0; j < tiles[i].length;j++){
          stroke(0);
          tiles[i][j].show();
        }
      }
      fill(0,200);
      rect(155,180,90,30);
      fill(255,0,0);
      textSize(15);
      text("Game Over",160,200);
    }
  }
      tron.show();
      for (int i = 0; i < buttons.length; i++){
        buttons[i].show();
      }
}

void mousePressed(){
  for (int i = 0; i < tiles.length; i++){ //detect if mouse lands on tile hitbox
    for (int j = 0; j < tiles[i].length;j++){
      tiles[i][j].detectColl();
    }
  }
  tron.detectColl();
  tron.clicked();
  for (int i = 0; i < buttons.length; i++){
     buttons[i].detectColl();
     buttons[i].setDiff();
     buttons[i].clicked();
  }
}

int countmines(int r, int c){
  //counts mines nearby and returns int
  int mines = 0;
  try{ //catch error that happens for some reason
  for (int i = r-1; i < r+2; i++){
    for (int j = c-1; j < c+2; j++){
      if (validSpot(tiles,i,j)){if (tiles[i][j].hasMine()){mines++;}}
    }
  }
  if(tiles[r][c].hasMine()){mines--;} //subtract self
  } catch (Exception NullPointerException){}
  return mines;
}

void popNeighbors(int r, int c){
  //pops neighbors of zero bomb neighbors
  try{ //catch error that happens for some reason
    for (int i = r-1; i < r+2; i++){
      for (int j = c-1; j < c+2; j++){
        if (i!=r || j!=c){ //if not self(avoid infinite recursion)
          if (validSpot(tiles,i,j)){tiles[i][j].popMine();}}
      }
    }
  } catch (Exception NullPointerException){}
}

void reGen(){
  //for zeroGen---a reroll
  totalMines = 0;
  for (int i = 0; i < tiles.length; i++){ //reroll all mines
    for (int j = 0; j < tiles[i].length; j++){
      tiles[i][j].reMine();
      if (tiles[i][j].hasMine()){totalMines++;} //counts total mines for wincondition
    }
  }
  for (int r = 0; r < tiles.length; r++){ //count each tile's minesNear and storeInVar
    for (int c = 0; c < tiles[r].length;c++){
      tiles[r][c].setMinesNear(countmines(r,c));
    }
  }
  
}

boolean validSpot(Tile[][] map, int r, int c){//returns if r,c is valid in map
  return r>=0 && c >=0 && r<map.length && c<map[r].length;
}

boolean winCondition(){ //returns if yer winning son
  return (tiles.length * tiles[0].length)-tilesPopped == totalMines;
}



class Tile{
  //creates a tile that can have a mine and has a fixed x and y and can popOrBeFlagged
  private int x, y, minesNear; //set minesNear outside
  private boolean hasMine, popped, flag;
  public Tile(int myX, int myY){
    x = myX;
    y = myY;
    hasMine = (Math.random() < 0.20625);//0.4); //randomly assigns mines, 40% chance
    popped = false;
    flag = false;
    //if (y == 0
  }
  
  public void show(){//draw color depending on state its in
    if (!gameOver){
      if (!popped){
        fill(140, 200, 120);
      } else{
        if (hasMine){
          fill(255,0,0);
        }else{
        fill(255);
         }
      }
      rect(x,y,20,20);
      if (popped){//adds modifiers like flags and numbers
        fill(0);
        if(!(minesNear == 0)){textSize(12);text(minesNear,x+7,y+15);}
      } else if (flag){
        fill(255,0,0);
        rect(x+5, y+5, 10,10); //flag is just a red square rn
      }
    } else{ //if game over
      if (hasMine && !winCondition()){
        fill(255, 0, 0);
      } else{
        if (!popped){
          fill(140,200,120);
        }else{
        fill(255);
         }
      }
      rect(x,y,20,20);
      if (popped){//adds modifiers like flags and numbers in gameOver
        fill(0);
        if(!(minesNear == 0)){textSize(12);text(minesNear,x+7,y+15);} //if not 0, write
      } else if (flag){
        if (!hasMine){
          stroke(255,0,0);
          line(x,y,x+20,y+20);
          line(x+20,y,x,y+20);
        }else{
          fill(255,0,0);
          rect(x+5, y+5, 10,10); //flag is just a red square rn
        }
      }
    }
  }
  
  public void detectColl(){//detect if mouse is in 20x20 sqare that tile is in
    if (mousePressed && (mouseX >= x && mouseX < x+20 && mouseY >= y && mouseY < y+20)){
      if (mouseButton == LEFT && flag == false){ //pop tile with no flag
        popMine();
      } else if (mouseButton == RIGHT){ //toggle flag on right click
        flag = !flag;
      }
    }
  }
  
  public void detectConditions(){//detect if any game-ending conditions are in play
    if ((hasMine && popped) || winCondition()){
      gameOver = true;
    }
  }
  
  public void popMine(){
    while (!zeroGen){
      if (minesNear !=0 || hasMine){reGen();} else{zeroGen = true;} //zerogeneration
    }
    if(!popped){
      popped = true;
      tilesPopped++;
      if(minesNear == 0 && !hasMine){ //if i am zerominesnear then pop neighbors
        popNeighbors(x/20,y/20);
      }
    }
  }
  
  //getters
  public int getX(){
    return x;
  }
  
  public int getY(){
    return y;
  }
  
  public boolean hasMine(){
    return hasMine;
  }
  
  public int getMinesNear(){
   return minesNear; 
  }
  //setters
  public void setMinesNear(int mines){
    minesNear = mines;
  }
  
  public void reMine(){
    hasMine = (Math.random() < 0.20625);//0.4); //randomly assigns mines, 40% chance
  }
  
}

class UIButton{
  //creates a tile that can have a mine and has a fixed x and y and can popOrBeFlagged
  protected int x, y, w, h;
  protected boolean isClicked, icon;
  protected color c;
  protected String str="defaaulttext";
  
  public void detectColl(){//detect if mouse is in 20x20 sqare that tile is in
    if (mousePressed && (mouseX >= x && mouseX < x+w && mouseY >= y && mouseY < y+h)){
      if (mouseButton == LEFT){ //set isClicked to true when clicked
        isClicked = true;
      }
    }
  }
  public void show(){
    fill(c);
    rect(x,y,w,h);
    if (icon){
      drawIcon();
      fill(0);
      textSize(15);
      text(str,x+w/4+h/2,y+3*h/4);
    } else{
      fill(0);
      textSize(15);
      text(str,x+w/4,y+3*h/4);
    }
  }
  
  public void drawIcon(){
    fill(200);
    ellipse(x+w/4,y+h/2,h,h);
    
  }
  
}

class resetButton extends UIButton{
  public resetButton(){ //something needed for child
  }
  
  public resetButton(int myX, int myY, int wid, int hei){
    x = myX;
    y = myY;
    w = wid;
    h = hei;
    c = #FF0000;
    icon = true;
    str = "Reset";
  }
  
  public void drawIcon(){
    if (isClicked){
      c = #FF5050;
      fill(200,50,50);
      ellipse(x+w/4,y+h/2,3*h/4,3*h/4);
      fill(255,50,50);
      ellipse(x+w/4,y+h/2,h/2,h/2);
      noStroke();
      quad(x+w/4, y+h/2+10,x+w/4-5, y+h/2+10,x+w/4, y+h/2,x+w/4, y+h/2+10);
      stroke(1);
      line(x+w/4-5, y+h/2+8,x+w/4-3, y+h/2+6);
      fill(200,50,50);
      triangle(x+w/4,y+h/2,x+w/4+12, y+h/2, x+w/4-12, y+h/2+12);
    }else{
      fill(150,0,0);
      ellipse(x+w/4,y+h/2,3*h/4,3*h/4);
      fill(255,0,0);
      ellipse(x+w/4,y+h/2,h/2,h/2);
      noStroke();
      quad(x+w/4, y+h/2+10,x+w/4-5, y+h/2+10,x+w/4, y+h/2,x+w/4, y+h/2+10);
      stroke(1);
      line(x+w/4-5, y+h/2+8,x+w/4-3, y+h/2+6);
      fill(150,0,0);
      triangle(x+w/4,y+h/2,x+w/4+10, y+h/2+7, x+w/4, y+h/2+8);
    }
  }
  
  public void clicked(){
    if(isClicked){
      reset();
      
    }
    
  }
  
  public void reset(){
    tilesPopped = 0;
    totalMines = 0;
    zeroGen=false;
    gameOver=false;
  for (int i = 0; i < tiles.length; i++){ //fill the grid with tiles
    for (int j = 0; j < tiles.length; j++){
      tiles[i][j]=(new Tile(i*20, j*20));
      if (tiles[i][j].hasMine()){totalMines++;} //counts total mines for wincondition
    }
  }
  for (int r = 0; r < tiles.length; r++){ //count each tile's minesNear and storeInVar
    for (int c = 0; c < tiles[r].length;c++){
      tiles[r][c].setMinesNear(countmines(r,c));
    }
  }
   isClicked = false; 
   loop();
  }
  
}

class difficultyButton extends resetButton{
  protected int d;
  public difficultyButton(int myX, int myY, int wid, int hei, int diff){
    x = myX;
    y = myY;
    w = wid;
    h = hei;
    d = diff;
    icon = false;
    if (d == 0){
      c = #00FF00;
      str = "Easy";
    } else if (d == 1){
      c = #FFFF00;
      str = "Medium";
    } else {
      c = #ff0000;
      str = "Hard";
      
    }
  }
  
  public void setDiff(){
    if(isClicked){
      if (d == 0){
        tiles = new Tile[10][10];
      } else if (d == 1){
        tiles = new Tile[15][15];
      } else {
        tiles = new Tile[20][20];
      }
    }
  }
  
  
}




