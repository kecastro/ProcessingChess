public class Piece{
  int id;
  String name;
  boolean alive;
  boolean selected;
  Cell location;
  ArrayList<Cell> posibleMoves;
  ArrayList<Cell> board;
  
  //PGraphics pg;
  int cell = 0;
  
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
    pg.sphere(10);
    pg.popMatrix();
 
  }
  
  public void select(InteractiveFrame f){
    int i = this.location.i;
    int j = this.location.j;
    
    this.posibleMoves = new ArrayList<Cell>();
    
    if(this.selected == false){
       this.selected = true;
      for(int k = 0; k < this.board.size(); k++){
         board.get(k).deactivate();
       }
       if(this.name.equals("peon")){
         if(this.id < 3){
           for(int c = 0; c < this.board.size(); c++){
             if(board.get(c).i == i + 1 && board.get(c).j == j){
               if(board.get(c).isEmpty()){
                 cell = c;
                 board.get(c).activate();
                 board.get(c).possiblePiece = this;
               }
             }
           }
           //this.posibleMoves.add();
         }
       }  
    }
    else{
      this.selected = false;
      board.get(cell).deactivate();
    }
  }

}