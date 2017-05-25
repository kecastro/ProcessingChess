import remixlab.proscene.*;

Scene scene, secondScene;
PGraphics canvas, secondCanvas;  
InteractiveFrame frame1, frame2, frame3, frame4, frame5, frame6, frame7, auxFrame1, auxFrame2, auxFrame3;
InteractiveFrame iFrame;
InteractiveFrame[] board;

ArrayList<Cell> cells;
ArrayList<Piece> pieces;

Piece p1w;
Piece p2w;
Piece p3w;

Piece p1b;
Piece p2b;
Piece p3b;

void settings() {
  size(1200, 600, P3D);
}

void setup() {
  
  board = new InteractiveFrame[64];
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
  //Pieces
  pieces.add( new Piece("peon", cells.get(8), 1, cells) ) ;
  cells.get(8).addPiece(pieces.get(0)); //Revisar cuando se agreguen todas las fichas
  pieces.add( new Piece("peon", cells.get(9), 2, cells) );
  cells.get(9).addPiece(pieces.get(1));
  pieces.add( new Piece("peon", cells.get(10), 3, cells) );
  cells.get(10).addPiece(pieces.get(2));
  
  pieces.add( new Piece("peon", cells.get(55), 22, cells) );
  cells.get(55).addPiece(pieces.get(3));
  pieces.add( new Piece("peon", cells.get(54), 23, cells) );
  cells.get(54).addPiece(pieces.get(4));
  pieces.add( new Piece("peon", cells.get(53), 24, cells) );
  cells.get(53).addPiece(pieces.get(5));
  
  canvas = createGraphics(width/2, height, P3D);
  scene = new Scene(this, canvas);
  
  for (int i = 0; i < board.length; i++) {
    board[i] = new InteractiveFrame(scene, frame1, cells.get(i), "drawCell");
    board[i].setHighlightingMode(InteractiveFrame.HighlightingMode.NONE);
    board[i].removeBindings();
    board[i].setClickBinding(cells.get(i), LEFT,1, "moveHere");
  }
  
  frame1 = new InteractiveFrame(scene, pieces.get(0),"piecesDrawing");
  frame1.removeBindings();
  frame1.setClickBinding(pieces.get(0), LEFT,1, "select");
  frame2 = new InteractiveFrame(scene, pieces.get(1), "piecesDrawing");
  frame3 = new InteractiveFrame(scene, pieces.get(2), "piecesDrawing");
  frame4 = new InteractiveFrame(scene, pieces.get(3), "piecesDrawing");
  frame5 = new InteractiveFrame(scene, pieces.get(4), "piecesDrawing");
  frame6 = new InteractiveFrame(scene, pieces.get(5), "piecesDrawing");
  


  secondCanvas = createGraphics(width/2, height, P2D);
  secondScene = new Scene(this, secondCanvas, width/2, 0);
  secondScene.setVisualHints(0);
  secondScene.setRadius(200);
  secondScene.showAll();

  /*
  auxFrame1 = new InteractiveFrame(secondScene);
  auxFrame1.set(frame1);
  auxFrame2 = new InteractiveFrame(secondScene, auxFrame1);
  auxFrame2.set(frame2);
  auxFrame3 = new InteractiveFrame(secondScene, auxFrame2);
  auxFrame3.set(frame3);
 
  
  iFrame = new InteractiveFrame(secondScene);
  //to not scale the iFrame on mouse hover uncomment:
  iFrame.setHighlightingMode(InteractiveFrame.HighlightingMode.NONE);
  iFrame.setWorldMatrix(scene.eyeFrame());
  iFrame.setShape(scene.eyeFrame());
   */
  
}

void draw() {
  //InteractiveFrame.sync(scene.eyeFrame(), iFrame);
  InteractiveFrame.sync(frame1, auxFrame1);
  InteractiveFrame.sync(frame2, auxFrame2);
  InteractiveFrame.sync(frame3, auxFrame3);
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