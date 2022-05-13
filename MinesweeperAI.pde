int squaresize = 25;
int mapsize = 1000;//40 by 40
int minesnum = 300;//300 mines
Mines m;
AI a;
int roundnum = 1;
boolean manual = false;//start manual or nah
private int[] adjacentminestomines;
void setup() {//runs once at start
 size(1000, 1000);
 background(130);
  for(int x = 0; x < mapsize; x+=squaresize) {//columns
    for(int y = 0; y < mapsize; y+=squaresize) {//rows
      //fill(160);
      fill(100,160,100);//undiscovered color
      rect( x, y, squaresize, squaresize );//make background
    }
  }
  m = new Mines();
  a = new AI();
  m.GenerateMines(minesnum);
  adjacentminestomines = m.getAdjacentMines(m.mines);
  //m.Show(m.mines, adjacentminestomines);//shows all mines
}

void draw() {//runs continuous
  if(!manual){
  a.SmartMove();//gets new values for move[]
  a.foundspaces = m.Move(a.move[0], a.move[1], a.foundspaces, a.edges);//gets new found spaces based on move
  if(a.foundspaces != null){
    a.foundspacesscores = m.getAdjacentMines(a.foundspaces);//gets scores of all spaces the AI knows
    a.edges = m.getEdges(a.foundspaces, a.move, true);//finds spaces adjacent to brown squares
    //a.possiblemines = m.getEdges(a.edges, a.move, false);//not for Move()
    //a.ParseForMines();//parses each space 1 away from edge and calculates probability for that space
    a.ShowDiscoveredSpaces();//shows the spaces the AI has discovered with the scores
    if(m.checkForWin(a.flaggedminesx, a.flaggedminesy)){
      println("You won!");
      setup();
    }
    }else{
      if(m.playerdead){
        setup();
        m.playerdead = false;
      }
    }
    try{
    m.Show(a.foundmines, a.foundspacesscores);}catch(Exception e){}
    if(a.foundallmines){
      m.GenerateMines(minesnum * roundnum/2);
      roundnum++;
      a.foundallmines = false;
      println("Found all mines. Starting round " + roundnum);
    }
    if (keyPressed) {
      if(key == 'm' || key == 'M') {
        if(manual)
          manual = false;
        else
          manual = true;
      }else if(key == 's' || key == 'S'){
        m.Show(m.mines, adjacentminestomines);//shows all mines
      }
    }
  }else
  if (keyPressed) {
    if(key == 'm' || key == 'M') {
      if(manual)
        manual = false;
      else
        manual = true;
    }else if(key == 's' || key == 'S'){
      m.Show(m.mines, adjacentminestomines);//shows all mines
    }
  }
}
void mousePressed(){
  if(manual){
    if(mouseButton == LEFT){
      a.Move(mouseX / squaresize, mouseY /squaresize);
      a.foundspaces = m.Move(a.move[0], a.move[1], a.foundspaces, a.edges);
      if(a.foundspaces != null){
        a.foundspacesscores = m.getAdjacentMines(a.foundspaces);
        a.edges = m.getEdges(a.foundspaces, a.move, true);
        a.ShowDiscoveredSpaces();
        if(m.checkForWin(a.flaggedminesx, a.flaggedminesy)){
          println("You won!");
          setup();
        }
      }else{
        if(m.playerdead){
          setup();
          m.playerdead = false;
        }
      }
    }else if(mouseButton == RIGHT){
      a.FlagMine(mouseX / squaresize, mouseY / squaresize);
      a.ShowDiscoveredSpaces();
      if(m.checkForWin(a.flaggedminesx, a.flaggedminesy)){
        println("You won!");
        setup();
      }
    }
  }
}
