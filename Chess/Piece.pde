public class Piece{
  int id;
  String name;
  boolean alive;
  boolean selected;
  PShape s;
  Cell location;
  ArrayList<Cell> posibleMoves;
  ArrayList<Cell> board;
  //to castle = hacer enroque rey y torre, el rey  no debe estar en jaque 
  //check   =jaque 
  //checkmate = jaque mate
  //stelamate = no esta en jaque el rey pero si se mueve el rey entra en jaque y eso es empate
  //enpassant =  captura al paso o comer al paso (solo )
  // verificar si tiene fichas suficientes para hacer hacke si no son tablas
  // para torneo si hace clic la debe mover, toca cambiar para que solo on hover se muestre los movimiento si hace clic le toca mover esa
  // tiempo total para torneos 
  
  public Piece(String name, Cell cell, int id, ArrayList<Cell> board){
    this.id = id;
    this.alive = true;
    this.selected = false;
    this.name = name;
    this.location = cell;
    this.board = board;
    if(this.name.equals("rook")){
      this.s=loadShape("data/rook.obj");
    }
    else if(this.name.equals("horse")){
      this.s=loadShape("data/knight.obj");
    }
    else if(this.name.equals("bishop")){
      this.s=loadShape("data/bishop.obj");
    }
    else if(this.name.equals("queen")){
      this.s=loadShape("data/queen.obj");
    }
    else if(this.name.equals("king")){
      this.s=loadShape("data/king.obj");
    }
    else{
      this.s=loadShape("data/pawn.obj");
    }
  }
  
  public void move(Cell cell){
    this.location.move();
    this.location = cell;
  }
  
  public void kill(){
    this.alive = false;
  }
  
  public boolean isAlive(){
    return alive;
  }
  
  public void piecesDrawing(PGraphics pg) {  
    pg.noStroke();
    
    if(this.id <= 16){
      if(this.selected == true){
        pg.fill(240,0,0);
      }
      else{
        pg.fill(230);
      }
    }
    else{
      if(this.selected == true){
        pg.fill(240,0,0);
      }
      else{
        pg.fill(50);
      }
    }
       
    pg.pushMatrix();
    pg.translate(this.location.x, this.location.y, this.location.z + 2);
    pg.rotateX(radians(90));
    pg.scale(6);
    
    if(this.id <= 16){
       this.s.setFill(color(230));
    }
    else{
       this.s.setFill(color(50));
    }
   
    pg.shape(this.s);

    pg.popMatrix();
 
  }
  
public void select(InteractiveFrame f){
  
    for(int c = 0; c < this.board.size(); c++){
      if(board.get(c).myPiece != null){
         board.get(c).myPiece.selected = false;
      }
    }
  
  
    int i = this.location.i;
    int j = this.location.j;
    
    int pos = board.indexOf(this.location);
    int row = (pos/8) + 1;
    
    this.posibleMoves = new ArrayList<Cell>();
    
    if(this.selected == false){
       this.selected = true;
      for(int k = 0; k < this.board.size(); k++){
         board.get(k).deactivate();
       }
       if(this.name.equals("pawn")){
         if(this.id < 16 && pos + 8 < 64){
               if(board.get(pos + 8).isEmpty()){
                 board.get(pos + 8).activate();
                 board.get(pos + 8).possiblePiece = this;
               }
           //this.posibleMoves.add();
         }
       } 
       else if(this.name.equals("rook")){
         for(int c = pos + 8; c < 64; c += 8){ //Movement foward
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
                board.get(pos + 8).activate();
                board.get(pos + 8).possiblePiece = this;
              }
              break;
            }
         }
         for(int c = pos - 8; c >= 0; c -= 8){ //Movement backward
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
                board.get(pos + 8).activate();
                board.get(pos + 8).possiblePiece = this;
              }
              break;
            }
         }
         for(int c = pos + 1; c < row * 8 ; c++){ //Movement rigth
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
                board.get(pos + 8).activate();
                board.get(pos + 8).possiblePiece = this;
              }
              break;
            }
         }
         for(int c = pos - 1; c >= (row - 1) * 8 ; c--){ //Movement left
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
                board.get(pos + 8).activate();
                board.get(pos + 8).possiblePiece = this;
                board.get(pos + 8).possibleCapture = this;
              }
              break;
            }
         }
       }
       else if(this.name.equals("horse")){
         if(pos+10 < 64 && pos < row*8 - 2 && row < 8){
            if(board.get(pos + 10).isEmpty()){
              board.get(pos + 10).activate();
              board.get(pos + 10).possiblePiece = this;
            }      
         }
         if(pos+17 < 64 && pos < row*8 - 1 && row < 7){
           if(board.get(pos + 17).isEmpty()){
            board.get(pos + 17).activate();
            board.get(pos + 17).possiblePiece = this;
           }
         }
         if(pos+15 < 64 && pos > (row - 1) * 8 && row < 7){
           if(board.get(pos + 15).isEmpty()){
            board.get(pos + 15).activate();
            board.get(pos + 15).possiblePiece = this;
           }
         }
         if(pos+6 < 64 && pos > ((row - 1) * 8) + 1 && row < 8){
           if(board.get(pos + 6).isEmpty()){
            board.get(pos + 6).activate();
            board.get(pos + 6).possiblePiece = this;
           }
         }
         if(pos-6 >= 0 && pos < row*8 - 2 && row > 1){
           if(board.get(pos - 6).isEmpty()){
            board.get(pos - 6).activate();
            board.get(pos - 6).possiblePiece = this;
           }
         }
         if(pos-15 >= 0 && pos < row*8 - 1 && row > 2){
           if(board.get(pos - 15).isEmpty()){
            board.get(pos - 15).activate();
            board.get(pos - 15).possiblePiece = this;
           }
         }
         if(pos-17 >= 0 && pos > (row - 1) * 8 && row > 2){
           if(board.get(pos - 17).isEmpty()){
            board.get(pos - 17).activate();
            board.get(pos - 17).possiblePiece = this;
           }
         }
         if(pos-10 >= 0 && pos > (row - 1) * 8 + 1 && row > 1){
           if(board.get(pos - 10).isEmpty()){
            board.get(pos - 10).activate();
            board.get(pos - 10).possiblePiece = this;
           }
         }
       }
       else if(this.name.equals("bishop")){
         
         for (int c = pos - 7; c >= 0 && (pos+1)%8!=0 ; c -= 7){//left  backwards diagonal movement
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
               if ((c+1)%8==0){
                 break;
               }
            }
            else{
              break;
            }
         }
         for(int c = pos - 9; c >= 0 && pos%8!=0; c -= 9){ //right backwards diagonal movement
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
               println (pos);
               println (c);
               if ((c)%8==0){
                 break;
               }
               
            }
            else{
              println (c);
              break;
            }
         }
         for(int c = pos + 9; c < 64 && (pos+1)%8!=0 ; c += 9){ //left forward diagonal movement
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
               if ((c+1)%8==0){
                 break;
               }
            }
            else{
              break;
            }
         }
         for(int c = pos + 7; c < 64 && pos%8!=0; c += 7){ //right  forwards diagonal Movement
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
               if ((c)%8==0){
                 break;
               }
            }
            else{
              break;
            }
         }
         
       }
       else if(this.name.equals("king")){

          if ((pos + 8) < 64 ){//fowards movement 
            if(board.get(pos + 8).isEmpty()){ 
                board.get(pos + 8).activate();
                board.get(pos + 8).possiblePiece = this;
            }
          } 
          if ((pos - 8) >= 0){//backward movement 
            if(board.get(pos - 8).isEmpty()){
              board.get(pos - 8).activate();
              board.get(pos - 8).possiblePiece = this;
            }
            
          }  
          if (pos < 64 && (pos+1)%8!=0){//left movement  
            if(board.get(pos + 1).isEmpty()){
              board.get(pos + 1).activate();
              board.get(pos + 1).possiblePiece = this;
            }
          }
          if ((pos) > 0 && pos%8!=0 ){// right movement
            if(board.get(pos - 1).isEmpty()){
                board.get(pos - 1).activate();
                board.get(pos - 1).possiblePiece = this;
            }
          }
          if ((pos - 7) > 0 && (pos+1)%8!=0){
            if(board.get(pos - 7).isEmpty()){ //left  backwards diagonal movement
                board.get(pos - 7).activate();
                board.get(pos - 7).possiblePiece = this;
            }
          } 
          if ((pos - 9) >= 0 && (pos)%8!=0){
            if(board.get(pos - 9).isEmpty()){ //right backwards diagonal movement
              board.get(pos - 9).activate();
              board.get(pos - 9).possiblePiece = this;
            }
            
          } 
          if ((pos + 9) < 64 && (pos+1)%8!=0){//left forward diagonal movement
            if(board.get(pos + 9).isEmpty()){
              board.get(pos +9).activate();
              board.get(pos +9).possiblePiece = this;
            }
          } 
          if ((pos + 7) < 64 && (pos)%8!=0){ //right  forwards diagonal Movement
            if(board.get(pos + 7).isEmpty()){
                board.get(pos + 7).activate();
                board.get(pos + 7).possiblePiece = this;
            }
          } 

     }
       else if(this.name.equals("queen")){
          for (int c = pos - 7; c >= 0 && (pos+1)%8!=0 ; c -= 7){//left  backwards diagonal movement
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
               if ((c+1)%8==0){
                 break;
               }
            }
            else{
              break;
            }
         }
         for(int c = pos - 9; c >= 0 && pos%8!=0; c -= 9){ //right backwards diagonal movement   
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
               if ((c)%8==0){
                 break;
               }
               
            }
            else{
              break;
            }
         }
         for(int c = pos + 9; c < 64 && (pos+1)%8!=0 ; c += 9){ //left forward diagonal movement
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
               if ((c+1)%8==0){
                 break;
               }
            }
            else{
              break;
            }
         }
         for(int c = pos + 7; c < 64 && pos%8!=0; c += 7){ //right  forwards diagonal Movement
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
               if ((c)%8==0){
                 break;
               }
            }
            else{
              break;
            }
         }
         for(int c = pos + 8; c < 64; c += 8){ //fowards movement 
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              break;
            }
         }
         for(int c = pos - 8; c >= 0; c -= 8){ //backward movement 
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              break;
            }
         }
         for(int c = pos + 1; c < row * 8 ; c++){ //rigth movement 
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              break;
            }
         }
         for(int c = pos - 1; c >= (row - 1) * 8 ; c--){ // left movement
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              break;
            }
         }
         
       }
    }
    else{
      this.selected = false;
      for(int c = 0; c < this.board.size(); c++){
        if(board.get(c).activated == true){
          board.get(c).activated = false;
        }
      }
    }
  }

}