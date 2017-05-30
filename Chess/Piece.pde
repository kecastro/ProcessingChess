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

public class Piece{
  int id; //from 1 to 64
  String name;
  boolean selected;
  PShape s;
  Cell location;
  ArrayList<Cell> posibleMoves;
  ArrayList<Cell> board;
  boolean alive;
  int originX, originY;
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
    this.selected = false;
    this.alive = true;
    this.name = name;
    this.location = cell;
    this.board = board;
    this.originX = cell.x;
    this.originY = cell.y;
    
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
  
  public void piecesDrawing(PGraphics pg) {  
    pg.pushMatrix();
    
    if(this.alive == true){
       if(this.id <= 16){
         pg.translate(this.location.x -1, this.location.y - 1, this.location.z + 2);
       }
       else{
         pg.translate(this.location.x + 1, this.location.y - 1, this.location.z + 2);
       }
       
       pg.scale(6);
    }
    else{
      if(this.id <= 8){
        pg.translate(this.originX, this.originY - 130, this.location.z + 2);
        pg.scale(4);
      }
      else if(this.id <= 16){
        pg.translate(this.originX, this.originY - 100, this.location.z + 2);
        pg.scale(4);
      }
      else if(this.id <= 24){
        pg.translate(this.originX , this.originY + 50 , this.location.z + 2);
        pg.scale(3);
      }
      else{
        pg.translate(this.originX , this.originY + 60 , this.location.z + 2);
        pg.scale(3);
      }
    }
    
    pg.noStroke(); 
    
    pg.rotateX(radians(90));
    if(this.id <= 16){
      pg.rotateY(radians(-85));
    }
    else{
      pg.rotateY(radians(95));
    }   
    
    
    
    this.s.setStroke(true);
    this.s.setStrokeWeight(0.3);
    
    if(this.id <= 16){
      if(this.selected == true){
       this.s.setFill(color(180,0,0));
       this.s.setStroke(color(0));
      }
      else{
        this.s.setFill(color(50));
        this.s.setStroke(color(255));
      }
    }
    else{
      if(this.selected == true){
       this.s.setFill(color(180,0,0));
       this.s.setStroke(color(0));
      }
      else{
        this.s.setFill(color(230));
        this.s.setStroke(color(0));
      }     
    }
   
    pg.shape(this.s);
  
    pg.popMatrix();
    
  }
  
public void select(InteractiveFrame f){
  
    if(this.alive == true){
      //TODO: delete the next two lines
      int i = this.location.i;
      int j = this.location.j;
      
      int pos = board.indexOf(this.location);
      int row = (pos/8) + 1;
      
      //this.posibleMoves = new ArrayList<Cell>();
      
      
      
      if(this.selected == false){
        for(int k = 0; k < this.board.size(); k++){
           board.get(k).deactivate();
           board.get(k).depCapture();
           if(board.get(k).myPiece != null){
             board.get(k).myPiece.selected = false;
           }
         }
         this.selected = true;
         if(this.name.equals("pawn")){
           this.pawnMovement();
         } 
         
         else if(this.name.equals("rook")){
           this.rookMovement();
           
         }
         else if(this.name.equals("horse")){
           this.horseMovement();
         }
         else if(this.name.equals("bishop")){
           this.bishopMovement();
         }
         else if(this.name.equals("king")){
           this.kingMovement();
            
         }
         else if(this.name.equals("queen")){
           this.queenMovement();
         }
      }
      else{
        this.selected = false;
        for(int c = 0; c < this.board.size(); c++){
          if(board.get(c).activated == true){
            board.get(c).deactivate();
          }
          if(board.get(c).pCapture == true){
            board.get(c).depCapture();
          }
        }
      }
    }
    
  }
  public void pawnMovement(){
    //TODO: reduce and optimize algoritm 
    this.posibleMoves = new ArrayList<Cell>();
    int pos = board.indexOf(this.location);

    
   //To move fordward one cell black piece      
   if(this.id <= 16 && (pos + 8) < 64){
  
     if(board.get(pos + 8).isEmpty()){
       this.posibleMoves.add(board.get(pos + 8));
       board.get(pos + 8).activate();
       board.get(pos + 8).possiblePiece = this;
     }                 
     //Capture left
     if(!board.get(pos + 9).isEmpty()){ 
       if((board.get(pos + 9).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 9).myPiece.id > 16 && this.id <= 16)){
         //this.posibleMoves.add(board.get(pos + 9));
         //board.get(pos + 9).possibleCapture = this;
         board.get(pos + 9).pCapture();
         board.get(pos + 9).activate();
         board.get(pos + 9).possiblePiece = this;
        
       }
     }
     //Capture right
     if(!board.get(pos + 7).isEmpty()){
       if((board.get(pos + 7).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 7).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos + 7).possibleCapture = this;
         board.get(pos + 7).pCapture();
         board.get(pos + 7).activate();
         board.get(pos + 7).possiblePiece = this;
       }
     }
   }
   //To move fordward two cells black piece  
   if(this.id <= 16 && (pos + 16) < 64 && (pos >=8 && pos <=16 )){
     if(board.get(pos + 16).isEmpty() && board.get(pos + 8).isEmpty()){
       board.get(pos + 16).activate();
       board.get(pos + 16).possiblePiece = this;
     }
     //Capture left
     if(!board.get(pos + 9).isEmpty()){
       if((board.get(pos + 9).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 9).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos + 9).possibleCapture = this;
         board.get(pos + 9).pCapture();
         board.get(pos + 9).activate();
         board.get(pos + 9).possiblePiece = this;
       }
     }
     //Capture right
     if(!board.get(pos + 7).isEmpty()){
       if((board.get(pos + 7).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 7).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos + 7).possibleCapture = this;
         board.get(pos + 7).pCapture();
         board.get(pos + 7).activate();
         board.get(pos + 7).possiblePiece = this;
       }
     }
   }
   //To move fordward one cell white piece 
   if(this.id > 16 && pos - 8 >= 0){
     if(board.get(pos - 8).isEmpty()){
       board.get(pos - 8).activate();
       board.get(pos - 8).possiblePiece = this;
     }
     //Capture left
     if(!board.get(pos - 9).isEmpty()){
       if((board.get(pos - 9).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 9).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 9).possibleCapture = this;
         board.get(pos - 9).pCapture();
         board.get(pos - 9).activate();
         board.get(pos - 9).possiblePiece = this;
       }
     }
     //Capture right
     if(!board.get(pos - 7).isEmpty()){
       if((board.get(pos - 7).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 7).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 7).possibleCapture = this;
         board.get(pos - 7).pCapture();
         board.get(pos - 7).activate();
         board.get(pos - 7).possiblePiece = this;
       }
     }
   }
   //To move fordward two cells white piece 
   if(this.id > 16 && pos - 16 > 0 && (pos >= 48 && pos <= 55 )){
     if(board.get(pos - 16).isEmpty() && board.get(pos - 8).isEmpty() ){
       board.get(pos - 16).activate();
       board.get(pos - 16).possiblePiece = this;
     } 
     //Capture left
     if(!board.get(pos - 9).isEmpty()){
       if((board.get(pos - 9).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 9).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 9).possibleCapture = this;
         board.get(pos - 9).pCapture();
         board.get(pos - 9).activate();
         board.get(pos - 9).possiblePiece = this;
       }
     }
     //Capture right
     if(!board.get(pos - 7).isEmpty()){
       if((board.get(pos - 7).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 7).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 7).possibleCapture = this;
         board.get(pos - 7).pCapture();
         board.get(pos - 7).activate();
         board.get(pos - 7).possiblePiece = this;
       }
     }
   }
         
         
  }
  public void rookMovement(){
    this.posibleMoves = new ArrayList<Cell>();
    int pos = board.indexOf(this.location);
    int row = (pos/8) + 1;
    
    for(int c = pos + 8; c < 64; c += 8){ //Movement foward
      if(board.get(c).isEmpty()){
         board.get(c).activate();
         board.get(c).possiblePiece = this;
      }
      else{
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
          ////board.get(c).possibleCapture = this;
          board.get(c).pCapture();
          board.get(c).activate();
          board.get(c).possiblePiece = this;
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
          ////board.get(c).possibleCapture = this;
          board.get(c).pCapture();
          board.get(c).activate();
          board.get(c).possiblePiece = this;
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
          ////board.get(c).possibleCapture = this;
          board.get(c).pCapture();
          board.get(c).activate();
          board.get(c).possiblePiece = this;
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
          ////board.get(c).possibleCapture = this;
          board.get(c).pCapture();
          board.get(c).activate();
          board.get(c).possiblePiece = this;
          
        }
        break;
      }
   }
  }
  public void horseMovement(){
    this.posibleMoves = new ArrayList<Cell>();
    int pos = board.indexOf(this.location);
    int row = (pos/8) + 1;
    
    if(pos+10 < 64 && pos < row*8 - 2 && row < 8){
      if(board.get(pos + 10).isEmpty()){
        board.get(pos + 10).activate();
        board.get(pos + 10).possiblePiece = this;
      } 
      else{
        if((board.get(pos + 10).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 10).myPiece.id > 16 && this.id <= 16)){
          //board.get(pos + 10).possibleCapture = this;
          board.get(pos + 10).pCapture();
          board.get(pos + 10).activate();
          board.get(pos + 10).possiblePiece = this;
        }
      }
   }
   if(pos+17 < 64 && pos < row*8 - 1 && row < 7){
     if(board.get(pos + 17).isEmpty()){
      board.get(pos + 17).activate();
      board.get(pos + 17).possiblePiece = this;
     }
     else{
       if((board.get(pos + 17).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 17).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos + 17).possibleCapture = this;
         board.get(pos + 17).pCapture();
         board.get(pos + 17).activate();
         board.get(pos + 17).possiblePiece = this;
       }
     }
   }
   if(pos+15 < 64 && pos > (row - 1) * 8 && row < 7){
     if(board.get(pos + 15).isEmpty()){
      board.get(pos + 15).activate();
      board.get(pos + 15).possiblePiece = this;
     }
     else{
       if((board.get(pos + 15).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 15).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos + 15).possibleCapture = this;
         board.get(pos + 15).pCapture();
         board.get(pos + 15).activate();
         board.get(pos + 15).possiblePiece = this;
       }
     }
   }
   if(pos+6 < 64 && pos > ((row - 1) * 8) + 1 && row < 8){
     if(board.get(pos + 6).isEmpty()){
      board.get(pos + 6).activate();
      board.get(pos + 6).possiblePiece = this;
     }
     else{
       if((board.get(pos + 6).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 6).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos + 6).possibleCapture = this;
         board.get(pos + 6).pCapture();
         board.get(pos + 6).activate();
         board.get(pos + 6).possiblePiece = this;
       }
     }
   }
   if(pos-6 >= 0 && pos < row*8 - 2 && row > 1){
     if(board.get(pos - 6).isEmpty()){
      board.get(pos - 6).activate();
      board.get(pos - 6).possiblePiece = this;
     }
     else{
       if((board.get(pos - 6).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 6).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 6).possibleCapture = this;
         board.get(pos - 6).pCapture();
         board.get(pos - 6).activate();
         board.get(pos - 6).possiblePiece = this;
       }
     }
   }
   if(pos-15 >= 0 && pos < row*8 - 1 && row > 2){
     if(board.get(pos - 15).isEmpty()){
      board.get(pos - 15).activate();
      board.get(pos - 15).possiblePiece = this;
     }
     else{
       if((board.get(pos - 15).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 15).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 15).possibleCapture = this;
         board.get(pos - 15).pCapture();
         board.get(pos - 15).activate();
         board.get(pos - 15).possiblePiece = this;
       }
     }
   }
   if(pos-17 >= 0 && pos > (row - 1) * 8 && row > 2){
     if(board.get(pos - 17).isEmpty()){
      board.get(pos - 17).activate();
      board.get(pos - 17).possiblePiece = this;
     }
     else{
       if((board.get(pos - 17).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 17).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 17).possibleCapture = this;
         board.get(pos - 17).pCapture();
         board.get(pos - 17).activate();
         board.get(pos - 17).possiblePiece = this;
       }
     }
   }
   if(pos-10 >= 0 && pos > (row - 1) * 8 + 1 && row > 1){
     if(board.get(pos - 10).isEmpty()){
      board.get(pos - 10).activate();
      board.get(pos - 10).possiblePiece = this;
     }
     else{
       if((board.get(pos - 10).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 10).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 10).possibleCapture = this;
         board.get(pos - 10).pCapture();
         board.get(pos - 10).activate();
         board.get(pos - 10).possiblePiece = this;
       }
     }
   }
  }
  
  public void bishopMovement(){
    this.posibleMoves = new ArrayList<Cell>();
    int pos = board.indexOf(this.location);
    
    for (int c = pos - 7; c >= 0 && (pos+1)%8!=0 ; c -= 7){//left  backwards diagonal movement
      if(board.get(c).isEmpty()){
         board.get(c).activate();
         board.get(c).possiblePiece = this;
         if ((c+1)%8==0){
           break;
         }
      }
      else{
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
         ////board.get(c).possibleCapture = this;
         board.get(c).pCapture();
         board.get(c).activate();
         board.get(c).possiblePiece = this;
         if ((c+1)%8==0){
           break;
         }
        }
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
        
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
         ////board.get(c).possibleCapture = this;
         
         board.get(c).pCapture();
         
         board.get(c).activate();
         board.get(c).possiblePiece = this;
         if ((c)%8==0){
           break;
         }
        }
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
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
         ////board.get(c).possibleCapture = this;
         board.get(c).pCapture();
         board.get(c).activate();
         board.get(c).possiblePiece = this;
         if ((c+1)%8==0){
           break;
         }
        }
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
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
         //board.get(c).possibleCapture = this;
         board.get(c).pCapture();
         board.get(c).activate();
         board.get(c).possiblePiece = this;
         if ((c)%8==0){
           break;
         }
        }
        break;
      }
   }
  
  } 
  public void kingMovement(){
    this.posibleMoves = new ArrayList<Cell>();
    int pos = board.indexOf(this.location);
    if ((pos + 8) < 64 ){//fowards movement 
      if(board.get(pos + 8).isEmpty()){ 
          board.get(pos + 8).activate();
          board.get(pos + 8).possiblePiece = this;
      }
      else{
        if((board.get(pos + 8).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 8).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos + 8).possibleCapture = this;
         board.get(pos + 8).pCapture();
         board.get(pos + 8).activate();
         board.get(pos + 8).possiblePiece = this;
        }
      }
    } 
    if ((pos - 8) >= 0){//backward movement 
      if(board.get(pos - 8).isEmpty()){
        board.get(pos - 8).activate();
        board.get(pos - 8).possiblePiece = this;
      }
      else{
        if((board.get(pos - 8).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 8).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 8).possibleCapture = this;
         board.get(pos - 8).pCapture();
         board.get(pos - 8).activate();
         board.get(pos - 8).possiblePiece = this;
        }
      }
      
    }  
    if (pos < 64 && (pos+1)%8!=0){//left movement  
      if(board.get(pos + 1).isEmpty()){
        board.get(pos + 1).activate();
        board.get(pos + 1).possiblePiece = this;
      }
      else{
        if((board.get(pos + 1).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 1).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos + 1).possibleCapture = this;
         board.get(pos + 1).pCapture();
         board.get(pos + 1).activate();
         board.get(pos + 1).possiblePiece = this;
        }
      }
    }
    if ((pos) > 0 && pos%8!=0 ){// right movement
      if(board.get(pos - 1).isEmpty()){
          board.get(pos - 1).activate();
          board.get(pos - 1).possiblePiece = this;
      }
      else{
        if((board.get(pos - 1).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 1).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 1).possibleCapture = this;
         board.get(pos - 1).pCapture();
         board.get(pos - 1).activate();
         board.get(pos - 1).possiblePiece = this;
        }
      }
    }
    if ((pos - 7) > 0 && (pos+1)%8!=0){
      if(board.get(pos - 7).isEmpty()){ //left  backwards diagonal movement
          board.get(pos - 7).activate();
          board.get(pos - 7).possiblePiece = this;
      }
      else{
        if((board.get(pos - 7).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 7).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 7).possibleCapture = this;
         board.get(pos - 7).pCapture();
         board.get(pos - 7).activate();
         board.get(pos - 7).possiblePiece = this;
        }
      }
    } 
    if ((pos - 9) >= 0 && (pos)%8!=0){
      if(board.get(pos - 9).isEmpty()){ //right backwards diagonal movement
        board.get(pos - 9).activate();
        board.get(pos - 9).possiblePiece = this;
      }
      else{
        if((board.get(pos - 9).myPiece.id <= 16 && this.id > 16) || (board.get(pos - 9).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos - 9).possibleCapture = this;
         board.get(pos - 9).pCapture();
         board.get(pos - 9).activate();
         board.get(pos - 9).possiblePiece = this;
        }
      }
      
    } 
    if ((pos + 9) < 64 && (pos+1)%8!=0){//left forward diagonal movement
      if(board.get(pos + 9).isEmpty()){
        board.get(pos +9).activate();
        board.get(pos +9).possiblePiece = this;
      }
      else{
        if((board.get(pos + 9).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 9).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos + 9).possibleCapture = this;
         board.get(pos + 9).pCapture();
         board.get(pos + 9).activate();
         board.get(pos + 9).possiblePiece = this;
        }
      }
    } 
    if ((pos + 7) < 64 && (pos)%8!=0){ //right  forwards diagonal Movement
      if(board.get(pos + 7).isEmpty()){
          board.get(pos + 7).activate();
          board.get(pos + 7).possiblePiece = this;
      }
      else{
        if((board.get(pos + 7).myPiece.id <= 16 && this.id > 16) || (board.get(pos + 7).myPiece.id > 16 && this.id <= 16)){
         //board.get(pos + 7).possibleCapture = this;
         board.get(pos + 7).pCapture();
         board.get(pos + 7).activate();
         board.get(pos + 7).possiblePiece = this;
        }
      }
    } 

  }
  public void queenMovement(){
    this.posibleMoves = new ArrayList<Cell>();
    int pos = board.indexOf(this.location);
    int row = (pos/8) + 1;
    for (int c = pos - 7; c >= 0 && (pos+1)%8!=0 ; c -= 7){//left  backwards diagonal movement
      if(board.get(c).isEmpty()){
         board.get(c).activate();
         board.get(c).possiblePiece = this;
         if ((c+1)%8==0){
           break;
         }
         
      }
      else{
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
           //board.get(c).possibleCapture = this;
           board.get(c).pCapture();
           board.get(c).activate();
           board.get(c).possiblePiece = this;
           if ((c+1)%8==0){
             break;
           }
        }
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
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
           //board.get(c).possibleCapture = this;
           board.get(c).pCapture();
           board.get(c).activate();
           board.get(c).possiblePiece = this;
           if ((c)%8==0){
             break;
           }
        }
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
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
           //board.get(c).possibleCapture = this;
           board.get(c).pCapture();
           board.get(c).activate();
           board.get(c).possiblePiece = this;
           if ((c+1)%8==0){
             break;
           }
        }
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
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
           //board.get(c).possibleCapture = this;
           board.get(c).pCapture();
           board.get(c).activate();
           board.get(c).possiblePiece = this;
           if ((c)%8==0){
             break;
           }
        }
        break;
      }
   }
   for(int c = pos + 8; c < 64; c += 8){ //fowards movement 
      if(board.get(c).isEmpty()){
         board.get(c).activate();
         board.get(c).possiblePiece = this;
      }
      else{
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
           //board.get(c).possibleCapture = this;
           board.get(c).pCapture();
           board.get(c).activate();
           board.get(c).possiblePiece = this;
        }
        break;
      }
   }
   for(int c = pos - 8; c >= 0; c -= 8){ //backward movement 
      if(board.get(c).isEmpty()){
         board.get(c).activate();
         board.get(c).possiblePiece = this;
      }
      else{
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
           //board.get(c).possibleCapture = this;
           board.get(c).pCapture();
           board.get(c).activate();
           board.get(c).possiblePiece = this;
        }
        break;
      }
   }
   for(int c = pos + 1; c < row * 8 ; c++){ //rigth movement 
      if(board.get(c).isEmpty()){
         board.get(c).activate();
         board.get(c).possiblePiece = this;
      }
      else{
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
           //board.get(c).possibleCapture = this;
           board.get(c).pCapture();
           board.get(c).activate();
           board.get(c).possiblePiece = this;
        }
        break;
      }
   }
   for(int c = pos - 1; c >= (row - 1) * 8 ; c--){ // left movement
      if(board.get(c).isEmpty()){
         board.get(c).activate();
         board.get(c).possiblePiece = this;
      }
      else{
        if((board.get(c).myPiece.id <= 16 && this.id > 16) || (board.get(c).myPiece.id > 16 && this.id <= 16)){
           //board.get(c).possibleCapture = this;
           board.get(c).pCapture();
           board.get(c).activate();
           board.get(c).possiblePiece = this;
        }
        break;
      }
   }
  }
}
