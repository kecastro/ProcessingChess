import remixlab.proscene.*;

Scene scene, secondScene;
PGraphics canvas, secondCanvas;  
InteractiveFrame frame1, frame2, frame3, frame4, frame5, frame6, frame7, auxFrame1, auxFrame2, auxFrame3;
InteractiveFrame iFrame;
InteractiveFrame[] board;

ArrayList<Cell> cells;
ArrayList<Piece> pieces;

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
  pieces.add( new Piece("rook", cells.get(0), 1, cells) );
  cells.get(0).addPiece(pieces.get(0));
  pieces.add( new Piece("pawn", cells.get(8), 9, cells) ) ;
  cells.get(8).addPiece(pieces.get(1)); //Revisar cuando se agreguen todas las fichas
  pieces.add( new Piece("pawn", cells.get(9), 10, cells) );
  cells.get(9).addPiece(pieces.get(2));
  pieces.add( new Piece("pawn", cells.get(10), 11, cells) );
  cells.get(10).addPiece(pieces.get(3));
  
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
  frame2.removeBindings();
  frame2.setClickBinding(pieces.get(1), LEFT,1, "select");
  frame3 = new InteractiveFrame(scene, pieces.get(2), "piecesDrawing");
  frame3.removeBindings();
  frame3.setClickBinding(pieces.get(2), LEFT,1, "select");
  frame4 = new InteractiveFrame(scene, pieces.get(3), "piecesDrawing");
  frame4.removeBindings();
  frame4.setClickBinding(pieces.get(3), LEFT,1, "select");



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