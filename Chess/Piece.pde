public class Piece{
  int id;
  String name;
  boolean alive;
  boolean selected;
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
      pg.fill(0,0,200);
    }
    pg.sphere(10);
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
       if(this.name.equals("peon")){
         if(this.id < 16 && pos + 8 < 64){
               if(board.get(pos + 8).isEmpty()){
                 board.get(pos + 8).activate();
                 board.get(pos + 8).possiblePiece = this;
               }
           //this.posibleMoves.add();
         }
       } 
       else if(this.name.equals("torre")){
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