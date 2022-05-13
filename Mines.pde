class Mines{
  int squaresize = 25;
  boolean originopen = true;
  int[][] mines;
  boolean playerdead = false;
  void GenerateMines(int num){
    mines = new int[num][num];
    int xpos = (int)random(40);//0-39
    int ypos = (int)random(40);//0-39
    for(int i = 0; i < num; i++){//foreach mine
      boolean keepgoing = true;
      while(keepgoing){//if it doesn't exist, create it
        xpos = (int)random(40);//0-39
        ypos = (int)random(40);//0-39
        if(!Exists(xpos, ypos, false)){//if dne
          mines[0][i] = xpos;
          mines[1][i] = ypos;
          keepgoing = false;
        }
      }
    }
  }
  int[] getAdjacentMines(int[][] spaces){//get adjacent mines from a set of spaces
    int spacesnum = spaces[0].length;
    int[] adjacentarray = new int[spacesnum];
    for(int x = 0; x < spacesnum; x++){//foreach space
      int adjacentmmines = 0;
      for(int i = 0; i < minesnum; i++){//foreach mine again to check if one is near
        if((mines[0][i] == spaces[0][x] - 1 && (mines[1][i] == spaces[1][x] - 1 || mines[1][i] == spaces[1][x] || mines[1][i] == spaces[1][x] + 1)) || (mines[0][i] == spaces[0][x] && (mines[1][i] == spaces[1][x] - 1 || mines[1][i] == spaces[1][x] + 1)) || (mines[0][i] == spaces[0][x] + 1 && (mines[1][i] == spaces[1][x] - 1 || mines[1][i] == spaces[1][x] || mines[1][i] == spaces[1][x] + 1))){//if mine is one away
          adjacentmmines++;
        }
      }
      adjacentarray[x] = adjacentmmines;
      adjacentmmines = 0;
    }
    return adjacentarray;
  }
  void Show(int[][] mines, int[] adjacentmines){//this method is for showing a set of mines with the color scheme
    int greenval = 255;
    int reddotx;
    int reddoty;
    for(int i = 0; i < adjacentmines.length; i++){
      //fill(redval - (adjacentmines[i] * 25), 0, blueval + (adjacentmines[i] * 25));
      fill(0, greenval - (adjacentmines[i] * 25), 0);
      //rect(mines[0][i] * squaresize, mines[1][i] * squaresize, squaresize, squaresize);
      ellipse(mines[0][i] * squaresize + (squaresize/2), mines[1][i] * squaresize + (squaresize/2), squaresize - 5, squaresize - 5);
      fill(255, 0, 0);
      //noStroke();
      reddotx = (int)random(1,3);//rand 1-2
      reddoty = (int)random(1,3);
      if(reddotx == 1)
        reddotx = 10;
      else
        reddotx = 15;
      if(reddoty == 1)
        reddoty = 10;
      else
        reddoty = 15;
      ellipse(mines[0][i] * squaresize + reddotx, mines[1][i] * squaresize + reddoty, 5, 5);
      stroke(0);
    }
  }
  boolean Exists(int x, int y, boolean formove){
    boolean exists = false;
    for(int i = 0; i < mines[0].length; i++){
      if(x == mines[0][i] && y == mines[1][i])
        exists = true;
    }
    if(!formove){
      if(x == 0 && y == 0 && originopen){
        exists = false;
        originopen = false;
      }else if((x == 19 || x == 20 || x == 21) && (y == 19 || y == 20 || y == 21))
        exists = true;//do not allow center
    }
    return exists;
  }
  int[][] Move(int x, int y, int[][] foundspaces, int[][] edges){//returns new found spaces with a given move
    if(Exists(x, y, true)){
      println("Looks like you are dead :(");
      playerdead = true;
      return null;
    }else{
      boolean newmove = true;
      try{
      for(int i = 0; i < foundspaces[0].length; i++){
        if(x == foundspaces[0][i] && y == foundspaces[1][i])
          newmove = false;
      }}catch(Exception e){}
      try{
      for(int i = 0; i < edges[0].length; i++){
        if(x == edges[0][i] && y == edges[1][i])
          newmove = false;
      }}catch(Exception e){}
      if(!newmove){
        playerdead = false;
        return foundspaces;
      }else{//if is a new move
        boolean allspacesfound = false;
        ArrayList<Integer> newxfound = new ArrayList<Integer>();
        ArrayList<Integer> newyfound = new ArrayList<Integer>();
        newxfound.add(x);
        newyfound.add(y);
        while(!allspacesfound){
          allspacesfound = true;
          for(int i = 0; i < newxfound.size(); i++){//for each new space found
            //check adjacents for if mine exists, foreach non mine non part of newxy non part of foundspaces space, add it, if didn't add any, allspacesfound = true;
            if(NewSpace(newxfound.get(i) - 1, newyfound.get(i) - 1, newxfound, newyfound, foundspaces)){//left top
              newxfound.add(newxfound.get(i) - 1);
              newyfound.add(newyfound.get(i) - 1);
              allspacesfound = false;
            }
            if(NewSpace(newxfound.get(i) - 1, newyfound.get(i), newxfound, newyfound, foundspaces)){//left middle
              newxfound.add(newxfound.get(i) - 1);
              newyfound.add(newyfound.get(i));
              allspacesfound = false;
            }
            if(NewSpace(newxfound.get(i) - 1, newyfound.get(i) + 1, newxfound, newyfound, foundspaces)){//left lower
              newxfound.add(newxfound.get(i) - 1);
              newyfound.add(newyfound.get(i) + 1);
              allspacesfound = false;
            }
            if(NewSpace(newxfound.get(i), newyfound.get(i) - 1, newxfound, newyfound, foundspaces)){//middle top
              newxfound.add(newxfound.get(i));
              newyfound.add(newyfound.get(i) - 1);
              allspacesfound = false;
            }
            if(NewSpace(newxfound.get(i), newyfound.get(i) + 1, newxfound, newyfound, foundspaces)){//middle bottom
              newxfound.add(newxfound.get(i));
              newyfound.add(newyfound.get(i) + 1);
              allspacesfound = false;
            }
            if(NewSpace(newxfound.get(i) + 1, newyfound.get(i) - 1, newxfound, newyfound, foundspaces)){//right top
              newxfound.add(newxfound.get(i) + 1);
              newyfound.add(newyfound.get(i) - 1);
              allspacesfound = false;
            }
            if(NewSpace(newxfound.get(i) + 1, newyfound.get(i), newxfound, newyfound, foundspaces)){//right middle
              newxfound.add(newxfound.get(i) + 1);
              newyfound.add(newyfound.get(i));
              allspacesfound = false;
            }
            if(NewSpace(newxfound.get(i) + 1, newyfound.get(i) + 1, newxfound, newyfound, foundspaces)){//right bottom
              newxfound.add(newxfound.get(i) + 1);
              newyfound.add(newyfound.get(i) + 1);
              allspacesfound = false;
            }
          }
        }
        int[][] newfoundspaces;
        if(foundspaces != null){
          newfoundspaces = new int[newxfound.size() + foundspaces[0].length][newyfound.size() + foundspaces[0].length];//the sizes should be the same
          for(int i = 0; i < foundspaces[0].length; i++){
            newfoundspaces[0][i] = foundspaces[0][i];
            newfoundspaces[1][i] = foundspaces[1][i];
          }
          for(int i = foundspaces[0].length; i < newfoundspaces[0].length; i++){
            newfoundspaces[0][i] = newxfound.get(i - foundspaces[0].length);
            newfoundspaces[1][i] = newyfound.get(i - foundspaces[0].length);
          }
        }else{
          try{
            newfoundspaces = new int[newxfound.size()][newyfound.size()];//the sizes should be the same
            for(int i = 0; i < newfoundspaces[0].length; i++){
              newfoundspaces[0][i] = newxfound.get(i);
              newfoundspaces[1][i] = newyfound.get(i);
            }
          }catch(Exception e){
            int[] adj = new int[mines[0].length];
            for(int i = 0; i < adj.length; i++)
              adj[i] = 69;
            Show(mines, adj);
            newfoundspaces = new int[1][1];//the sizes should be the same
            newfoundspaces[0][0] = x;
            newfoundspaces[1][0] = y;
          }
        }
        return newfoundspaces;
      }
    }
  }
  boolean NewSpace(int x, int y, ArrayList<Integer> newx, ArrayList<Integer> newy, int[][] foundspaces){
    boolean allow = true;
    for(int i = 0; i < newx.size(); i++){//check to see if it equals any of the other new spaces and it is one of the already found spaces
      if(x == newx.get(i) && y == newy.get(i))
        allow = false;
    }
    try{
    for(int i = 0; i < foundspaces.length; i++){//checks to see if it equals any of the previously found spaces
      if(x == foundspaces[0][i] && y == foundspaces[1][i])
        allow = false;
    }}catch(Exception e){}
    if(Exists(x, y, true))
      allow = false;
    int[][] adjinput ={{x},{y}};
    if(getAdjacentMines(adjinput)[0] > 0)
      allow = false;
    if(x > 39 || x < -1 || y > 39 || y < -1)
      allow = false;
    if(allow)
      return true;
    else
      return false;
  }
  int[][] getEdges(int[][] spaces, int[] move, boolean useMove){//gets all non 0 scores from the adjacent pieces to spaces
    ArrayList<Integer> edgeslistx = new ArrayList<Integer>();
    ArrayList<Integer> edgeslisty = new ArrayList<Integer>();
    for(int i = 0; i < spaces[0].length; i++){//foreach space
      boolean lefttop = true;//left top is free
      boolean leftmid = true;
      boolean leftbot = true;
      boolean midtop = true;
      boolean midbot = true;
      boolean righttop = true;
      boolean rightmid = true;
      boolean rightbot = true;
      for(int x = 0; x < spaces[0].length; x++){//again
        if(spaces[0][x] - 1 == spaces[0][i] && spaces[1][x] - 1 == spaces[1][i])
          lefttop = false;
        if(spaces[0][x] - 1 == spaces[0][i] && spaces[1][x] == spaces[1][i])
          leftmid = false;
        if(spaces[0][x] - 1 == spaces[0][i] && spaces[1][x] + 1 == spaces[1][i])
          leftbot = false;
        if(spaces[0][x] == spaces[0][i] && spaces[1][x] - 1 == spaces[1][i])
          midtop = false;
        if(spaces[0][x] == spaces[0][i] && spaces[1][x] + 1 == spaces[1][i])
          midbot = false;
        if(spaces[0][x] + 1 == spaces[0][i] && spaces[1][x] - 1 == spaces[1][i])
          righttop = false;
        if(spaces[0][x] + 1 == spaces[0][i] && spaces[1][x] == spaces[1][i])
          rightmid = false;
        if(spaces[0][x] + 1 == spaces[0][i] && spaces[1][x] + 1 == spaces[1][i])
          rightbot = false;
        if(lefttop){
          edgeslistx.add(spaces[0][i] - 1);
          edgeslisty.add(spaces[1][i] - 1);
          lefttop = false;
        }if(leftmid){
          edgeslistx.add(spaces[0][i] - 1);
          edgeslisty.add(spaces[1][i]);
          leftmid = false;
        }if(leftbot){
          edgeslistx.add(spaces[0][i] - 1);
          edgeslisty.add(spaces[1][i] + 1);
          leftbot = false;
        }if(midtop){
          edgeslistx.add(spaces[0][i]);
          edgeslisty.add(spaces[1][i] - 1);
          midtop = false;
        }if(midbot){
          edgeslistx.add(spaces[0][i]);
          edgeslisty.add(spaces[1][i] + 1);
          midbot = false;
        }if(righttop){
          edgeslistx.add(spaces[0][i] + 1);
          edgeslisty.add(spaces[1][i] - 1);
          righttop = false;
        }if(rightmid){
          edgeslistx.add(spaces[0][i] + 1);
          edgeslisty.add(spaces[1][i]);
          rightmid = false;
        }if(rightbot){
          edgeslistx.add(spaces[0][i] + 1);
          edgeslisty.add(spaces[1][i] + 1);
          rightbot = false;
        }
      }
    }
    for(int i = 0; i < spaces[0].length; i++){//add any missing pieces
      boolean hastl = false;//top left
      boolean hasbl = false;
      boolean hastr = false;
      boolean hasbr = false;
      boolean hasl = false;
      boolean hasr = false;
      boolean hasu = false;
      boolean hasd = false;
      for(int j = 0; j < edgeslistx.size(); j++){
        if(spaces[0][i] == edgeslistx.get(j) - 1 && spaces[1][i] == edgeslisty.get(j) - 1)
          hastl = true;
        if(spaces[0][i] == edgeslistx.get(j) - 1 && spaces[1][i] == edgeslisty.get(j) + 1)
          hasbl = true;
        if(spaces[0][i] == edgeslistx.get(j) + 1 && spaces[1][i] == edgeslisty.get(j) - 1)
          hastr = true;
        if(spaces[0][i] == edgeslistx.get(j) + 1 && spaces[1][i] == edgeslisty.get(j) + 1)
          hasbr = true;  
        if(spaces[0][i] == edgeslistx.get(j) - 1 && spaces[1][i] == edgeslisty.get(j))
          hasl = true;
        if(spaces[0][i] == edgeslistx.get(j) + 1 && spaces[1][i] == edgeslisty.get(j))
          hasr = true;
        if(spaces[0][i] == edgeslistx.get(j) && spaces[1][i] == edgeslisty.get(j) - 1)
          hasu = true;
        if(spaces[0][i] == edgeslistx.get(j) && spaces[1][i] == edgeslisty.get(j) + 1)
          hasd = true;
      }
      if(!hastl){
        edgeslistx.add(spaces[0][i] + 1);
        edgeslisty.add(spaces[1][i] + 1);
      }else if(!hasbl){
        edgeslistx.add(spaces[0][i] + 1);
        edgeslisty.add(spaces[1][i] - 1);
      }else if(!hastr){
        edgeslistx.add(spaces[0][i] - 1);
        edgeslisty.add(spaces[1][i] + 1);
      }else if(!hasbr){
        edgeslistx.add(spaces[0][i] - 1);
        edgeslisty.add(spaces[1][i] - 1);
      }
      if(!hasl){
        edgeslistx.add(spaces[0][i] + 1);
        edgeslisty.add(spaces[1][i]);
      }else if(!hasr){
        edgeslistx.add(spaces[0][i] - 1);
        edgeslisty.add(spaces[1][i]);
      }else if(!hasu){
        edgeslistx.add(spaces[0][i]);
        edgeslisty.add(spaces[1][i] + 1);
      }else if(!hasd){
        edgeslistx.add(spaces[0][i]);
        edgeslisty.add(spaces[1][i] - 1);
      }
    }
    for(int i = 0; i < edgeslistx.size(); i++){//remove dupelicates
      for(int j = 0; j < edgeslistx.size(); j++){
        try{
        if(edgeslistx.get(i) == edgeslistx.get(j) && edgeslisty.get(i) == edgeslisty.get(j) && i != j){//if duplicate
          edgeslistx.remove(i);
          edgeslisty.remove(i);
        }}catch(Exception e){}
      }
    }
    if(useMove){
      int[][] adjinput = {{move[0]},{move[1]}};
      if(getAdjacentMines(adjinput)[0] > 0){
        edgeslistx.add(move[0]);
        edgeslisty.add(move[1]);
      }
    }
    int numofedges = edgeslistx.size();
    int[][] edgepieces = new int[numofedges][numofedges];
    for(int i = 0; i < numofedges; i++){
      edgepieces[0][i] = edgeslistx.get(i);
      edgepieces[1][i] = edgeslisty.get(i);
    }
    int[] edgepiecesscores = getAdjacentMines(edgepieces);
    for(int i = 0; i < numofedges; i++)
      edgepieces[2][i] = edgepiecesscores[i];//make scores added to edgepieces
    ArrayList<Integer> edgesx = new ArrayList<Integer>();
    ArrayList<Integer> edgesy = new ArrayList<Integer>();
    ArrayList<Integer> edgesscore = new ArrayList<Integer>();
    for(int i = 0; i < edgepieces[0].length; i++){
      if(edgepieces[2][i] != 0){
        boolean hitsmine = false;
        for(int j = 0; j < mines[0].length; j++){
          if(edgepieces[0][i] == mines[0][j] && edgepieces[1][i] == mines[1][j])
            hitsmine = true;
        }
        if(!hitsmine){
          edgesx.add(edgepieces[0][i]);
          edgesy.add(edgepieces[1][i]);
          edgesscore.add(edgepieces[2][i]);
        }
      }
    }
    edgepieces = new int[edgesx.size()][edgesx.size()];
    for(int i = 0; i < edgepieces[0].length; i++){
      edgepieces[0][i] = edgesx.get(i);
      edgepieces[1][i] = edgesy.get(i);
      edgepieces[2][i] = edgesscore.get(i);
    }
    numofedges = edgepieces[0].length;
    int[][] edges = new int[3][numofedges];   
    for(int i = 0; i < numofedges; i++){
      edges[0][i] = edgepieces[0][i];
      edges[1][i] = edgepieces[1][i];
      edges[2][i] = edgepieces[2][i];
    }
    return edges;
  }
  boolean checkForWin(ArrayList<Integer> flaggedminesx, ArrayList<Integer> flaggedminesy){
    boolean winner = true;
    boolean found = false;
    if(flaggedminesx.size() != 0){
      for(int i = 0; i < mines[0].length && winner; i++){//foreach mine while winner == true
        for(int j = 0; j < flaggedminesx.size(); j++){//foreach flagged mine
          if(mines[0][i] == flaggedminesx.get(j) && mines[1][i] == flaggedminesy.get(j))
            found = true;
        }
        if(!found)
          winner = false;
        found = false;
      }
    }else
      winner = false;
    return winner;
  }
}
