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
      this.s=loadShape("data/rook.obj");
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
    pg.translate(this.location.x, this.location.y, this.location.z + 10);
    
     //Torre
    if(this.id == 1 || this.id == 8 || this.id == 17 || this.id == 24){
      pg.shape(this.s, 0, 0, 10,10);
    }
    else if(this.id == 2 || this.id == 7 || this.id == 18 || this.id == 23){
      pg.sphere(10);
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
         for(int c = pos + 8; c < 64; c += 8){ //Movement foward
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