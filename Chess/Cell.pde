public class Cell{
  public int i;
  public int j;
  public int x;
  public int y;
  public int z;
  public Piece myPiece;
  public Piece possiblePiece;
  public Piece possibleCapture;
  
  boolean empty;
  boolean activated;
  
  public Cell(int i, int j, int x, int y, int z){
    this.empty = true;
    this.activated = false;
    this.myPiece = null;
    this.possiblePiece = null;
    this.possibleCapture = null;
    this.x = x;
    this.y = y;
    this.z = z;
    this.i = i;
    this.j = j;
  }
  
  public void activate(){
    this.activated = true;
  }
  
  public void deactivate(){
    this.activated = false;
  }
  
  public void addPiece(Piece p){
    this.myPiece = p;
    this.empty = false;
  }
  
  public void move(){
    this.empty = true;
    this.myPiece = null;
  }
  
  public boolean isEmpty(){
    return empty;
  }
  
  public int getX(){
    return x;
  }
  
  public int getY(){
    return y;
  }
  
  public int getZ(){
    return z;
  }
  
 public void drawCell(PGraphics pg){
    pg.pushMatrix();
    pg.translate(this.getX(), this.getY(), this.getZ());
    if(this.activated == true){
      if (this.possibleCapture!=null)
        pg.fill(0,255,0);
      else
        pg.fill(255,0,255);
    }
    else{
      pg.fill(255);
    }
    pg.box(20, 20, 5);
    pg.popMatrix();
 }
 
 public void moveHere(InteractiveFrame f){
   if(this.activated == true){
      this.possiblePiece.location.empty = true;
      this.empty = false;
      this.myPiece = this.possiblePiece;
      this.myPiece.location = this;
      this.possiblePiece = null;
      this.myPiece.selected = false;
      
      for(int i = 0; i < this.myPiece.board.size(); i++){
        this.myPiece.board.get(i).activated = false;
      }
      
   }
 }
  
}