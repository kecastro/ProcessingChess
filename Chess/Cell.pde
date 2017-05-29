/**
 * @license
 * MIT License
 *
 * Copyright (c) 2017 Kevin Castro

 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/**
 * @author Kevin Castro <keacastropo@unal.edu.co>
 * @author Edgar Morán  <ehmoranb@unal.edu.co> 
 */

public class Cell{
  public int i;
  public int j;
  public int x;
  public int y;
  public int z;
  int id;
  public Piece myPiece;
  public Piece possiblePiece;
  public Piece possibleCapture;
  
  boolean empty;
  boolean activated;
  boolean pCapture;
  
  public Cell(int i, int j, int x, int y, int z, int id){
    this.empty = true;
    this.activated = false;
    this.pCapture = false;
    this.myPiece = null;
    this.possiblePiece = null;
    this.possibleCapture = null;
    this.x = x;
    this.y = y;
    this.z = z;
    this.i = i;
    this.j = j;
    this.id = id;
  }
  
  public void activate(){
    this.activated = true;
  }
  
  public void deactivate(){
    this.activated = false;
  }
  public void pCapture(){
    this.pCapture = true;
  }
  public void depCapture(){
    this.pCapture = false;
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
      if (this.pCapture==true)
        pg.fill(0,255,0);
      else
        pg.fill(255,0,255);
    }
    else{
      if(this.id % 2 == 0){
        pg.fill(50);
      }
      else{
        pg.fill(200);
      }
    }
    pg.box(20, 20, 5);
    pg.popMatrix();
 }
 
 public void moveHere(InteractiveFrame f){
   if(this.activated == true){
      if(this.empty == false){
        this.myPiece.alive = false;
      }
      this.possiblePiece.location.empty = true;
      this.possibleCapture = null;
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