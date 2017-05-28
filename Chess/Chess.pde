import remixlab.proscene.*;

Scene scene, secondScene;
PGraphics canvas, secondCanvas;  
InteractiveFrame[] piecesFrames;
InteractiveFrame[] auxPiecesFrames;
InteractiveFrame[] board;
InteractiveFrame[] auxBoard;


ArrayList<Cell> cells;
ArrayList<Piece> pieces;

void settings() {
  size(1200, 600, P3D);
}

void setup() {
  board = new InteractiveFrame[64];
  auxBoard = new InteractiveFrame[64];
  piecesFrames = new InteractiveFrame[32];
  auxPiecesFrames = new InteractiveFrame[32];
  
  //Board
  cells = new ArrayList<Cell>();
  
  int y = -80;
  int z = 0;
  
  for(int i = 0; i < 8; i++){
    int x = -80;
    for(int j = 0; j < 8; j++){
      cells.add(new Cell(i, j, x, y, z));
      x += 20;
    }
    y += 20;
  }
  
  pieces = new ArrayList<Piece>();
  
  //black pieces
  pieces.add( new Piece("rook", cells.get(0), 1, cells) );
  cells.get(0).addPiece(pieces.get(0));
  pieces.add( new Piece("horse", cells.get(1), 2, cells) );
  cells.get(1).addPiece(pieces.get(1));
  pieces.add( new Piece("bishop", cells.get(2), 3, cells) );
  cells.get(2).addPiece(pieces.get(2));
  pieces.add( new Piece("queen", cells.get(3), 4, cells) );
  cells.get(3).addPiece(pieces.get(3));
  pieces.add( new Piece("king", cells.get(4), 5, cells) );
  cells.get(4).addPiece(pieces.get(4));
  pieces.add( new Piece("bishop", cells.get(5), 6, cells) );
  cells.get(5).addPiece(pieces.get(5));
  pieces.add( new Piece("horse", cells.get(6), 7, cells) );
  cells.get(6).addPiece(pieces.get(6));
  pieces.add( new Piece("rook", cells.get(7), 8, cells) );
  cells.get(7).addPiece(pieces.get(7));
  pieces.add( new Piece("pawn", cells.get(8), 9, cells) );
  cells.get(8).addPiece(pieces.get(8));
  pieces.add( new Piece("pawn", cells.get(9), 10, cells) );
  cells.get(9).addPiece(pieces.get(9));
  pieces.add( new Piece("pawn", cells.get(10), 11, cells) );
  cells.get(10).addPiece(pieces.get(10));
  pieces.add( new Piece("pawn", cells.get(11), 12, cells) );
  cells.get(11).addPiece(pieces.get(11));
  pieces.add( new Piece("pawn", cells.get(12), 13, cells) );
  cells.get(12).addPiece(pieces.get(12));
  pieces.add( new Piece("pawn", cells.get(13), 14, cells) );
  cells.get(13).addPiece(pieces.get(13));
  pieces.add( new Piece("pawn", cells.get(14), 15, cells) );
  cells.get(14).addPiece(pieces.get(14));
  pieces.add( new Piece("pawn", cells.get(15), 16, cells) );
  cells.get(15).addPiece(pieces.get(15));
  
  //white pieces
  pieces.add( new Piece("rook", cells.get(63), 17, cells) );
  cells.get(63).addPiece(pieces.get(16));
  pieces.add( new Piece("horse", cells.get(62), 18, cells) );
  cells.get(62).addPiece(pieces.get(17));
  pieces.add( new Piece("bishop", cells.get(61), 19, cells) );
  cells.get(61).addPiece(pieces.get(18));
  pieces.add( new Piece("king", cells.get(60), 20, cells) );
  cells.get(60).addPiece(pieces.get(19));
  pieces.add( new Piece("queen", cells.get(59), 21, cells) );
  cells.get(59).addPiece(pieces.get(20));
  pieces.add( new Piece("bishop", cells.get(58), 22, cells) );
  cells.get(58).addPiece(pieces.get(21));
  pieces.add( new Piece("horse", cells.get(57), 23, cells) );
  cells.get(57).addPiece(pieces.get(22));
  pieces.add( new Piece("rook", cells.get(56), 24, cells) );
  cells.get(56).addPiece(pieces.get(23));
  pieces.add( new Piece("pawn", cells.get(55), 25, cells) );
  cells.get(55).addPiece(pieces.get(24));
  pieces.add( new Piece("pawn", cells.get(54), 26, cells) );
  cells.get(54).addPiece(pieces.get(25));
  pieces.add( new Piece("pawn", cells.get(53), 27, cells) );
  cells.get(53).addPiece(pieces.get(26));
  pieces.add( new Piece("pawn", cells.get(52), 28, cells) );
  cells.get(52).addPiece(pieces.get(27));
  pieces.add( new Piece("pawn", cells.get(51), 29, cells) );
  cells.get(51).addPiece(pieces.get(28));
  pieces.add( new Piece("pawn", cells.get(50), 30, cells) );
  cells.get(50).addPiece(pieces.get(29));
  pieces.add( new Piece("pawn", cells.get(49), 31, cells) );
  cells.get(49).addPiece(pieces.get(30));
  pieces.add( new Piece("pawn", cells.get(48), 32, cells) );
  cells.get(48).addPiece(pieces.get(31));



  canvas = createGraphics(width/2, height, P3D);
  scene = new Scene(this, canvas);
   
  for (int i = 0; i < pieces.size(); i++){
    piecesFrames[i] = new InteractiveFrame(scene, pieces.get(i),"piecesDrawing");
    piecesFrames[i].removeBindings();
    piecesFrames[i].setHighlightingMode(InteractiveFrame.HighlightingMode.NONE);
    piecesFrames[i].setClickBinding(pieces.get(i), LEFT,1, "select");
  }
  
    for (int i = 0; i < board.length; i++) {
    board[i] = new InteractiveFrame(scene, cells.get(i), "drawCell");
    board[i].setHighlightingMode(InteractiveFrame.HighlightingMode.NONE);
    board[i].removeBindings();
    board[i].setClickBinding(cells.get(i), LEFT,1, "moveHere");
  }




  secondCanvas = createGraphics(width/2, height, P3D);
  secondScene = new Scene(this, secondCanvas, width/2, 0);
  secondScene.setVisualHints(0);
  secondScene.setRadius(150);
  secondScene.showAll();

  
  for (int i = 0; i < board.length; i++) {
    auxBoard[i] = new InteractiveFrame(secondScene);
    auxBoard[i].set(board[i]);
    auxBoard[i].setHighlightingMode(InteractiveFrame.HighlightingMode.NONE);
  }
  
  for (int i = 0; i < pieces.size(); i++){
    auxPiecesFrames[i] =  new InteractiveFrame(secondScene);
    auxPiecesFrames[i].set(piecesFrames[i]);
  }

 
  /*
  iFrame = new InteractiveFrame(secondScene);
  //to not scale the iFrame on mouse hover uncomment:
  iFrame.setHighlightingMode(InteractiveFrame.HighlightingMode.NONE);
  iFrame.setWorldMatrix(scene.eyeFrame());
  iFrame.setShape(scene.eyeFrame());
   */
  
}

void draw() {
  //InteractiveFrame.sync(scene.eyeFrame(), iFrame);
  for (int i = 0; i < board.length; i++) {
    InteractiveFrame.sync(board[i], auxBoard[i]);
  }
  for (int i = 0; i < pieces.size(); i++){
    InteractiveFrame.sync(piecesFrames[i], auxPiecesFrames[i]);
  }

  scene.beginDraw();
  canvas.background(0);
  scene.drawFrames();
  scene.endDraw();
  scene.display();
  //second screen
  secondScene.beginDraw();
  secondCanvas.background(29, 153, 243);
  secondScene.pg().fill(255, 0, 255, 125);
  secondScene.drawFrames();
  secondScene.endDraw();
  secondScene.display();

}

void frameDrawing(PGraphics pg) {
  pg.fill(random(0, 255), random(0, 255), random(0, 255));
  pg.box(40, 10, 5);
}

void eyeDrawing(PGraphics pg) {
  pg.pushStyle();
  pg.rectMode(CENTER);
  pg.rect(0, 0, 200, 200);
  pg.popStyle();
}