class AI{
 boolean firstmove = true;
 boolean foundallmines = false;
 int[][] foundmines;
 int[][] foundspaces;
 int[] foundspacesscores;
 int[][] edges;//x, y, score
 ArrayList<Integer> flaggedminesx = new ArrayList<Integer>();
 ArrayList<Integer> flaggedminesy = new ArrayList<Integer>();
 int[] move = {20, 20};
 void FlagMine(int x, int y){
   boolean flaggable = true;
   try{
   for(int i = 0; i < foundspaces[0].length; i++){
     if(x == foundspaces[0][i] && y == foundspaces[1][i])
       flaggable = false;
   }}catch(Exception e){}
   try{
   for(int i = 0; i < edges[0].length; i++){
     if(x == edges[0][i] && y == edges[1][i])
       flaggable = false;
   }}catch(Exception e){}
   if(flaggable){
     flaggedminesx.add(x);
     flaggedminesy.add(y);
   }
 }
 void Move(int x, int y){
   move[0] = x;
   move[1] = y;
 }
 int[] posindir(int x, int y, int dir){
   int[] pos = {x, y};
   switch(dir){
    case 1:pos[0]--;break;
    case 2:pos[0]++;break;
    case 3:pos[1]--;break;
    case 4:pos[1]++;break;
   }
   return pos;
 }
 void ShowDiscoveredSpaces(){
   try{
   for(int i = 0; i < foundspaces[0].length; i++){
     fill(90,30,30);//discovered color
     rect(foundspaces[0][i] * squaresize, foundspaces[1][i] * squaresize, squaresize, squaresize );//show spaces
   }}catch(Exception e){}
   for(int x = 0; x < edges[0].length; x++){
     fill(110,50,30);
     rect(edges[0][x] * squaresize, edges[1][x] * squaresize, squaresize, squaresize);//show edges
     fill(0);
     text(Integer.toString(edges[2][x]), edges[0][x] * squaresize + (squaresize/3), edges[1][x] * squaresize - (squaresize/3) + squaresize);
   }
   int reddotx;
   int reddoty;
   for(int i = 0; i < flaggedminesx.size(); i++){//flag mines
     fill(160);//gray
     ellipse(flaggedminesx.get(i) * squaresize + (squaresize/2), flaggedminesy.get(i) * squaresize + (squaresize/2), squaresize - 5, squaresize - 5);
      fill(255, 0, 0);
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
      ellipse(flaggedminesx.get(i) * squaresize + reddotx, flaggedminesy.get(i) * squaresize + reddoty, 5, 5);
      stroke(0);
   }
  }
  void SmartMove(){
    if(!firstmove){//AI time baybie
      int[][] possiblemines = getPossibleMines();
      int[] possibleminesscores = GetPosMinesScores(possiblemines);
      //println(possiblemines[0].length + " " + possibleminesscores.length);//should be the same
      for(int i = 0; i < possiblemines[0].length; i++){
        fill(i * 5, 0,0);
        rect(possiblemines[0][i] * squaresize, possiblemines[1][i] * squaresize, squaresize, squaresize);
      }
      for(int i = 0; i < possibleminesscores.length; i++){
        if(possibleminesscores[i] == 0){
          try{
            FlagMine(possiblemines[0][i], possiblemines[1][i]);
          }catch(Exception e){}
        }
        fill(255 - possibleminesscores[i] * 35);
        rect(possiblemines[0][i] * squaresize, possiblemines[1][i] * squaresize, squaresize, squaresize);
      }
      possibleminesscores = GetPosMinesScores(possiblemines);
      /*int[][] guaranteedmoves = getGuaranteedMoves(possiblemines);
      fill(255,0,0);
      for(int i = 0; i < guaranteedmoves[0].length; i++){
        try{
        rect(guaranteedmoves[0][i] * squaresize, guaranteedmoves[1][i] * squaresize, squaresize, squaresize);}catch(Exception e){}
      }*/
    }else{
      firstmove = false;
    }
  }
  int[][] getPossibleMines(){
    ArrayList<Integer> posminesx = new ArrayList<Integer>();
    ArrayList<Integer> posminesy = new ArrayList<Integer>();
    for(int i = 0; i < edges[0].length; i++){//foreach space
      boolean lefttop = true;//left top is free
      boolean leftmid = true;
      boolean leftbot = true;
      boolean midtop = true;
      boolean midbot = true;
      boolean righttop = true;
      boolean rightmid = true;
      boolean rightbot = true;
      for(int x = 0; x < edges[0].length; x++){//again
        if(edges[0][x] - 1 == edges[0][i] && edges[1][x] - 1 == edges[1][i]){
          lefttop = false;
        }
        if(edges[0][x] - 1 == edges[0][i] && edges[1][x] == edges[1][i]){
          leftmid = false;
        }
        if(edges[0][x] - 1 == edges[0][i] && edges[1][x] + 1 == edges[1][i]){
          leftbot = false;
        }
        if(edges[0][x] == edges[0][i] && edges[1][x] - 1 == edges[1][i]){
          midtop = false;
        }
        if(edges[0][x] == edges[0][i] && edges[1][x] + 1 == edges[1][i]){
          midbot = false;
        }
        if(edges[0][x] + 1 == edges[0][i] && edges[1][x] - 1 == edges[1][i]){
          righttop = false;
        }
        if(edges[0][x] + 1 == edges[0][i] && edges[1][x] == edges[1][i]){
          rightmid = false;
        }
        if(edges[0][x] + 1 == edges[0][i] && edges[1][x] + 1 == edges[1][i]){
          rightbot = false;
        }
        if(lefttop){
          posminesx.add(edges[0][i] - 1);
          posminesy.add(edges[1][i] - 1);
          lefttop = false;
        }if(leftmid){
          posminesx.add(edges[0][i] - 1);
          posminesy.add(edges[1][i]);
          leftmid = false;
        }if(leftbot){
          posminesx.add(edges[0][i] - 1);
          posminesy.add(edges[1][i] + 1);
          leftbot = false;
        }if(midtop){
          posminesx.add(edges[0][i]);
          posminesy.add(edges[1][i] - 1);
          midtop = false;
        }if(midbot){
          posminesx.add(edges[0][i]);
          posminesy.add(edges[1][i] + 1);
          midbot = false;
        }if(righttop){
          posminesx.add(edges[0][i] + 1);
          posminesy.add(edges[1][i] - 1);
          righttop = false;
        }if(rightmid){
          posminesx.add(edges[0][i] + 1);
          posminesy.add(edges[1][i]);
          rightmid = false;
        }if(rightbot){
          posminesx.add(edges[0][i] + 1);
          posminesy.add(edges[1][i] + 1);
          rightbot = false;
        }
      }
    }
    for(int i = 0; i < edges[0].length; i++){//add any missing pieces
      boolean hastl = false;//top left
      boolean hasbl = false;
      boolean hastr = false;
      boolean hasbr = false;
      boolean hasl = false;
      boolean hasr = false;
      boolean hasu = false;
      boolean hasd = false;
      for(int j = 0; j < posminesx.size(); j++){
        if(edges[0][i] == posminesx.get(j) - 1 && edges[1][i] == posminesy.get(j) - 1)
          hastl = true;
        if(edges[0][i] == posminesx.get(j) - 1 && edges[1][i] == posminesy.get(j) + 1)
          hasbl = true;
        if(edges[0][i] == posminesx.get(j) + 1 && edges[1][i] == posminesy.get(j) - 1)
          hastr = true;
        if(edges[0][i] == posminesx.get(j) + 1 && edges[1][i] == posminesy.get(j) + 1)
          hasbr = true;  
        if(edges[0][i] == posminesx.get(j) - 1 && edges[1][i] == posminesy.get(j))
          hasl = true;
        if(edges[0][i] == posminesx.get(j) + 1 && edges[1][i] == posminesy.get(j))
          hasr = true;
        if(edges[0][i] == posminesx.get(j) && edges[1][i] == posminesy.get(j) - 1)
          hasu = true;
        if(edges[0][i] == posminesx.get(j) && edges[1][i] == posminesy.get(j) + 1)
          hasd = true;
      }
      if(!hastl){
        posminesx.add(edges[0][i] + 1);
        posminesy.add(edges[1][i] + 1);
      }else if(!hasbl){
        posminesx.add(edges[0][i] + 1);
        posminesy.add(edges[1][i] - 1);
      }else if(!hastr){
        posminesx.add(edges[0][i] - 1);
        posminesy.add(edges[1][i] + 1);
      }else if(!hasbr){
        posminesx.add(edges[0][i] - 1);
        posminesy.add(edges[1][i] - 1);
      }
      if(!hasl){
        posminesx.add(edges[0][i] + 1);
        posminesy.add(edges[1][i]);
      }else if(!hasr){
        posminesx.add(edges[0][i] - 1);
        posminesy.add(edges[1][i]);
      }else if(!hasu){
        posminesx.add(edges[0][i]);
        posminesy.add(edges[1][i] + 1);
      }else if(!hasd){
        posminesx.add(edges[0][i]);
        posminesy.add(edges[1][i] - 1);
      }
    }
    for(int i = 0; i < posminesx.size(); i++){//foreach possible mine
    boolean removed = false;
      for(int x = 0; x < foundspaces[0].length && !removed; x++){//remove where overlaps with foundpieces
        if(posminesx.get(i) == foundspaces[0][x] && posminesy.get(i) == foundspaces[1][x]){
          posminesx.remove(i);
          posminesy.remove(i);
          i--;
          removed = true;
        }
      }
      for(int k = 0; k < edges[0].length && !removed; k++){//remove where overlaps with edges
        if(posminesx.get(i) == edges[0][k] && posminesy.get(i) == edges[1][k]){
          posminesx.remove(i);
          posminesy.remove(i);
          i--;
          removed = true;
        }
      }
      for(int l = 0; l < flaggedminesx.size() && !removed; l++){//remove where overlaps with flagged mines
        if(posminesx.get(i) == flaggedminesx.get(l) && posminesy.get(i) == flaggedminesy.get(l)){
          posminesx.remove(i);
          posminesy.remove(i);
          i--;
          removed = true;
        }
      }
      for(int j = 0; j < posminesx.size() && !removed; j++){
        if(posminesx.get(i) == posminesx.get(j) && posminesy.get(i) == posminesy.get(j) && i != j){//if duplicate
          posminesx.remove(i);
          posminesy.remove(i);
          i--;
          removed = true;
        }
      }
    }
    int[][] possiblemines = new int[posminesx.size()][posminesx.size()];
    for(int i = 0; i < possiblemines[0].length; i++){
      possiblemines[0][i] = posminesx.get(i);
      possiblemines[1][i] = posminesy.get(i);
    }
    return possiblemines;
  }
  int[] GetPosMinesScores(int[][] possiblemines){
    int[][] edgestouching = new int[possiblemines[0].length][possiblemines[0].length];//length == length of edges[][]
    for(int i = 0; i < possiblemines[0].length; i++){//foreach possible mine
      for(int j = 0; j < edges[0].length; j++){//foreach edge
        if(edges[0][j] == possiblemines[0][i] - 1 && edges[1][j] == possiblemines[1][i] - 1){//if hits edge on top right
            edgestouching[0][i]++;
            edgestouching[1][i] += edges[2][j];//+= num on edge piece
        }
        if(edges[0][j] == possiblemines[0][i] - 1 && edges[1][j] == possiblemines[1][i]){
            edgestouching[0][i]++;
            edgestouching[1][i] += edges[2][j];
        }
        if(edges[0][j] == possiblemines[0][i] - 1 && edges[1][j] == possiblemines[1][i] + 1){
            edgestouching[0][i]++;
            edgestouching[1][i] += edges[2][j];
        }
        if(edges[0][j] == possiblemines[0][i] && edges[1][j] == possiblemines[1][i] - 1){
            edgestouching[0][i]++;
            edgestouching[1][i] += edges[2][j];
        }
        if(edges[0][j] == possiblemines[0][i] && edges[1][j] == possiblemines[1][i] + 1){
            edgestouching[0][i]++;
            edgestouching[1][i] += edges[2][j];
        }
        if(edges[0][j] == possiblemines[0][i] + 1 && edges[1][j] == possiblemines[1][i] - 1){
            edgestouching[0][i]++;
            edgestouching[1][i] += edges[2][j];
        }
        if(edges[0][j] == possiblemines[0][i] + 1 && edges[1][j] == possiblemines[1][i]){
            edgestouching[0][i]++;
            edgestouching[1][i] += edges[2][j];
        }
        if(edges[0][j] == possiblemines[0][i] + 1 && edges[1][j] == possiblemines[1][i] + 1){
            edgestouching[0][i]++;
            edgestouching[1][i] += edges[2][j];
        }
      }
    }
    int[] edgescores = new int[possiblemines[0].length];
    for(int i = 0; i < edgescores.length; i++){
      edgescores[i] = edgestouching[1][i] - edgestouching[0][i];//the edgescore = sum of edge piece scores around it    -    num of edge pieces around it
      if(!isEdge(possiblemines[0][i], possiblemines[1][i]))
        edgescores[i]++;
      else{
        edgescores[i] = 0;
      }
    }
    return edgescores;
  }
  boolean isEdge(int x, int y){
    boolean edge = false;
    boolean b1 = false;
    boolean b2 = false;
    boolean b3 = false;
    boolean b4 = false;
    for(int i = 1; i <= 4; i++){//for tl, tr, bl, br corners
      boolean c1 = false;
      boolean c2 = false;
      boolean c3 = false;
      switch(i){
        case 1://tl
          for(int j = 0; j < edges[0].length; j++){//check for edges
            if(x - 1 == edges[0][j] && y == edges[1][j])
              c1 = true;
            if(x - 1 == edges[0][j] && y - 1 == edges[1][j])
              c2 = true;
            if(x == edges[0][j] && y - 1 == edges[1][j])
              c3 = true;
          }
          /*if(!c1 || !c2 || !c3){
            for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
              if(x - 1 == flaggedminesx.get(j) && y == flaggedminesy.get(j))
                c1 = true;
              if(x - 1 == flaggedminesx.get(j) && y - 1 == flaggedminesy.get(j))
                c2 = true;
              if(x == flaggedminesx.get(j) && y - 1 == flaggedminesy.get(j))
                c3 = true;
            }
          }*/
        break;case 2://tr
          for(int j = 0; j < edges[0].length; j++){//check for edges
            if(x == edges[0][j] && y - 1 == edges[1][j])
              c1 = true;
            if(x + 1 == edges[0][j] && y - 1 == edges[1][j])
              c2 = true;
            if(x + 1 == edges[0][j] && y == edges[1][j])
              c3 = true;
          }
          /*if(!c1 || !c2 || !c3){
            for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
              if(x == flaggedminesx.get(j) && y - 1 == flaggedminesy.get(j))
                c1 = true;
              if(x + 1 == flaggedminesx.get(j) && y - 1 == flaggedminesy.get(j))
                c2 = true;
              if(x + 1 == flaggedminesx.get(j) && y == flaggedminesy.get(j))
                c3 = true;
            }
          }*/
        break;case 3://bl
          for(int j = 0; j < edges[0].length; j++){//check for edges
            if(x == edges[0][j] && y + 1 == edges[1][j])
              c1 = true;
            if(x - 1 == edges[0][j] && y + 1 == edges[1][j])
              c2 = true;
            if(x - 1 == edges[0][j] && y == edges[1][j])
              c3 = true;
          }
          /*if(!c1 || !c2 || !c3){
            for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
              if(x == flaggedminesx.get(j) && y + 1 == flaggedminesy.get(j))
                c1 = true;
              if(x - 1 == flaggedminesx.get(j) && y + 1 == flaggedminesy.get(j))
                c2 = true;
              if(x - 1 == flaggedminesx.get(j) && y == flaggedminesy.get(j))
                c3 = true;
            }
          }*/
        break;case 4://br
          for(int j = 0; j < edges[0].length; j++){//check for edges
            if(x + 1 == edges[0][j] && y == edges[1][j])
              c1 = true;
            if(x + 1 == edges[0][j] && y + 1 == edges[1][j])
              c2 = true;
            if(x == edges[0][j] && y + 1 == edges[1][j])
              c3 = true;
          }
          /*if(!c1 || !c2 || !c3){
            for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
              if(x + 1 == flaggedminesx.get(j) && y == flaggedminesy.get(j))
                c1 = true;
              if(x + 1 == flaggedminesx.get(j) && y + 1 == flaggedminesy.get(j))
                c2 = true;
              if(x == flaggedminesx.get(j) && y + 1 == flaggedminesy.get(j))
                c3 = true;
            }
          }*/
        break;
      }
      if(c1 && c2 && c3){
        switch(i){//tl tr bl br
          case 1:
            b1 = true;
          case 2:
            b2 = true;
          case 3:
            b3 = true;
          case 4:
            b4 = true;
          break;
        }
      }
    }
    if(b1 || b2 || b3 || b4)
      edge = true;
    return edge;
  }
  int[][] getGuaranteedMoves(int[][] posmines){//gets all guaranteed moves based on flagged mines
    ArrayList<Integer> movesx = new ArrayList<Integer>();
    ArrayList<Integer> movesy = new ArrayList<Integer>();
    for(int i = 0; i < edges[0].length; i++){//foreach edge
      int posminesaround = 0;
      ArrayList<Integer> posminesx = new ArrayList<Integer>();
      ArrayList<Integer> posminesy = new ArrayList<Integer>();
      for(int x = 0; x < posmines[0].length; x++){//foreach possible mine
        boolean l = false;
        boolean r = false;
        boolean u = false;
        boolean d = false;
        boolean tl = false;
        boolean tr = false;
        boolean bl = false;
        boolean br = false;
        if(edges[0][i] - 1 == posmines[0][x] && edges[1][i] == posmines[1][x]){//if hits posmine on the left
          for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
            if(edges[0][i] - 1 != flaggedminesx.get(j) && edges[1][i] != flaggedminesy.get(j)){//if edge piece does not hit flagged mine on left
              posminesx.add(edges[0][i] - 1);
              posminesy.add(edges[1][i]);
            }
          }
          posminesaround++;
        }if(edges[0][i] + 1 == posmines[0][x] && edges[1][i] == posmines[1][x]){
          for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
            if(edges[0][i] + 1 != flaggedminesx.get(j) && edges[1][i] != flaggedminesy.get(j)){
              posminesx.add(edges[0][i] + 1);
              posminesy.add(edges[1][i]);
            }
          }
          r = true;
          posminesaround++;
        }if(edges[0][i] == posmines[0][x] && edges[1][i] - 1 == posmines[1][x]){
          for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
            if(edges[0][i] != flaggedminesx.get(j) && edges[1][i] - 1 != flaggedminesy.get(j)){
              posminesx.add(edges[0][i]);
              posminesy.add(edges[1][i] - 1);
            }
          }
          u = true;
          posminesaround++;
        }if(edges[0][i] == posmines[0][x] && edges[1][i] + 1 == posmines[1][x]){
          for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
            if(edges[0][i] != flaggedminesx.get(j) && edges[1][i] + 1 != flaggedminesy.get(j)){
              posminesx.add(edges[0][i]);
              posminesy.add(edges[1][i] + 1);
            }
          }
          d = true;
          posminesaround++;
        }if(edges[0][i] - 1 == posmines[0][x] && edges[1][i] - 1 == posmines[1][x]){//top left
          for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
            if(edges[0][i] - 1 != flaggedminesx.get(j) && edges[1][i] - 1 != flaggedminesy.get(j)){
              posminesx.add(edges[0][i] - 1);
              posminesy.add(edges[1][i] - 1);
            }
          }
          tl = true;
          posminesaround++;
        }if(edges[0][i] + 1 == posmines[0][x] && edges[1][i] - 1 == posmines[1][x]){
          for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
            if(edges[0][i] + 1 != flaggedminesx.get(j) && edges[1][i] - 1 != flaggedminesy.get(j)){
              posminesx.add(edges[0][i] + 1);
              posminesy.add(edges[1][i] - 1);
            }
          }
          tr = true;
          posminesaround++;
        }if(edges[0][i] - 1 == posmines[0][x] && edges[1][i] + 1 == posmines[1][x]){
          for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
            if(edges[0][i] - 1 != flaggedminesx.get(j) && edges[1][i] + 1 != flaggedminesy.get(j)){
              posminesx.add(edges[0][i] - 1);
              posminesy.add(edges[1][i] + 1);
            }
          }
          bl = true;
          posminesaround++;
        }if(edges[0][i] + 1 == posmines[0][x] && edges[1][i] + 1 == posmines[1][x]){
          for(int j = 0; j < flaggedminesx.size(); j++){//for each flagged mine
            if(edges[0][i] + 1 != flaggedminesx.get(j) && edges[1][i] + 1 != flaggedminesy.get(j)){
              posminesx.add(edges[0][i] + 1);
              posminesy.add(edges[1][i] + 1);
            }
          }
          br = true;
          posminesaround++;
        }
      }
      println(posminesx.size());
      if(edges[2][i] - posminesaround == 1){//if one free space: if edgescore - flagged mines around = 0
        for(int j = 0; j < posminesx.size(); j++){//foreach possible mine that is not a flagged mine
          movesx.add(posminesx.get(j));
          movesy.add(posminesy.get(j));
        }
      }//score - (posmines around - flagged mines)
    }
    println("num of guaranteed moves = " + movesx.size());
    int[][] moves = new int[movesx.size()][movesy.size()];
    for(int i = 0; i < moves[0].length; i++){
      moves[0][i] = movesx.get(i);
      moves[1][i] = movesy.get(i);
    }
    return moves;
  }
}
