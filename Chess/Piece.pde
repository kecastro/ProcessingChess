public class Piece{
  int id;
  String name;
  boolean alive;
  boolean selected;
  PShape s;
  Cell location;
  ArrayList<Cell> posibleMoves;
  ArrayList<Cell> board;
  
  
  public Piece(String name, Cell cell, int id, ArrayList<Cell> board){
    this.id = id;
    this.alive = true;
    this.selected = false;
    this.name = name;
    this.location = cell;
    this.board = board;
    if (this.name.equals("rook")){
      this.s=loadShape("models/rook.obj");
    }
    else if (this.name.equals("bishop")){
      this.s=loadShape("models/bishop.obj");
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

    pg.translate(this.location.x, this.location.y, this.location.z + 5);
    
     //Torre
    if(this.id == 1 || this.id == 8 || this.id == 17 || this.id == 24){
      pg.fill(0,0,200);
      //this.s.translate(0, 0, 0); 
      pg.shape(this.s, 0, 0, 10,10);
    }
    else if (this.id == 3 || this.id == 5 || this.id == 20 || this.id == 21){
      pg.fill(0,0,200);
      pg.shape(this.s, 0, 0, 10,10);
    }
    else {
      pg.sphere(10);
    }
    pg.popMatrix();
 
  }
  
public void select(InteractiveFrame f){
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
         for(int c = pos + 8; c < 64; c += 8){ //Movement forward
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              break;
            }
         }
         for(int c = pos - 8; c >= 0; c -= 8){ //Movement backward
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              break;
            }
         }
         for(int c = pos + 1; c < row * 8 ; c++){ //Movement rigth
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              break;
            }
         }
         for(int c = pos - 1; c >= (row - 1) * 8 ; c--){ //Movement left
            if(board.get(c).isEmpty()){
               board.get(c).activate();
               board.get(c).possiblePiece = this;
            }
            else{
              break;
            }
         }
       }
       else if(this.name.equals("bishop")){
         
         for (int c = pos - 7; c >= 0 && (pos+1)%8!=0 ; c -= 7){//Movement backward diagonal left
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
         for(int c = pos - 9; c >= 0 && pos%8!=0; c -= 9){ //Movement backward digonal right
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
         for(int c = pos + 9; c < 64 && (pos+1)%8!=0 ; c += 9){ //Movement forward diagonal left
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
         for(int c = pos + 7; c < 64 && pos%8!=0; c += 7){ //Movement forward diagonal right
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
          if ((pos + 8) < 64 &&  board.get(pos + 8).isEmpty()){//Movement foward
            board.get(pos + 8).activate();
            board.get(pos + 8).possiblePiece = this;
          } 
          else if ((pos - 8) >= 0 &&  board.get(pos - 8).isEmpty()){//Movement backward
            board.get(pos - 8).activate();
            board.get(pos - 8).possiblePiece = this;
          } 
          else if ((pos - 1) >= 0 &&  board.get(pos - 1).isEmpty() && pos%8 !=0){//Movement right 
            board.get(pos - 8).activate();
            board.get(pos - 8).possiblePiece = this;
          } 
          else if ((pos + 1) >= 0 &&  board.get(pos - 1).isEmpty() && (pos+1)%8 !=0){//Movement right 
            board.get(pos - 8).activate();
            board.get(pos - 8).possiblePiece = this;
          } 
       }
       else if(this.name.equals("queen")){
          if ((pos + 8) < 64 &&  board.get(pos + 8).isEmpty()){//Movement foward
            board.get(pos + 8).activate();
            board.get(pos + 8).possiblePiece = this;
          } 
          else if ((pos - 8) >= 0 &&  board.get(pos - 8).isEmpty()){//Movement backward
            board.get(pos - 8).activate();
            board.get(pos - 8).possiblePiece = this;
          } 
          else if ((pos - 1) >= 0 &&  board.get(pos - 1).isEmpty() && pos%8 !=0){//Movement right 
            board.get(pos - 8).activate();
            board.get(pos - 8).possiblePiece = this;
          } 
          else if ((pos + 1) >= 0 &&  board.get(pos - 1).isEmpty() && (pos+1)%8 !=0){//Movement right 
            board.get(pos - 8).activate();
            board.get(pos - 8).possiblePiece = this;
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