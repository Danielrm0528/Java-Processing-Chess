class Partida {
   private Pieza[][] tablero;
   
   //Listas para mantener el seguimiento de las piezas blancas y negras y las capturadas
   private ArrayList<Pieza> blancas;
   private ArrayList<Pieza> negras;
   private ArrayList<Pieza> capturadas;
   
   //Factory para crear piezas
   private PiezaFactory factory;
   
   //Referencia a los reyes blanco y negro
   private Pieza bKing;
   private Pieza wKing;
   
   //Variables para mantener el seguimiento de los últimos movimientos
   private int x1;
   private int y1;
   private int x2;
   private int y2;
   
   //Constructor de la clase Partida
   public Partida() {
     //Inicialización del tablero y las listas de piezas
     tablero = new Pieza[8][8];
     blancas =  new ArrayList();
     negras =  new ArrayList();
     capturadas =  new ArrayList();
     factory = new PiezaFactory();
   }
   
   //Retorna el estado actual del tablero
   public Pieza[][] getTablero() {
     return tablero;
   }
   
   //Inicializa el tablero con piezas en sus posiciones iniciales
   public void inicializarTablero() {
     for(int i = 0; i<8;i++) {
       Pieza piezaCreada = factory.crearPieza(Type.Pawn,true,this,i,6,loadImage("whitePawn.png"));
       tablero[6][i] = piezaCreada;
       blancas.add(piezaCreada);
     }
     for(int i = 0; i<8;i++) {
       Pieza piezaCreada = factory.crearPieza(Type.Pawn,false,this,i,1,loadImage("blackPawn.png"));
       tablero[1][i] = piezaCreada;
       negras.add(piezaCreada);
     }
     tablero[7][0] = factory.crearPieza(Type.Rook,true,this,0,7,loadImage("whiteRook.png"));
     blancas.add(tablero[7][0]);
     tablero[7][7] = factory.crearPieza(Type.Rook,true,this,7,7,loadImage("whiteRook.png"));
     blancas.add(tablero[7][7]);
     tablero[7][1] = factory.crearPieza(Type.Knight,true,this,1,7,loadImage("whiteKnight.png"));
     blancas.add(tablero[7][1]);
     tablero[7][6] = factory.crearPieza(Type.Knight,true,this,6,7,loadImage("whiteKnight.png"));
     blancas.add(tablero[7][6]);
     tablero[7][2] = factory.crearPieza(Type.Bishop,true,this,2,7,loadImage("whiteBishop.png"));
     blancas.add(tablero[7][2]);
     tablero[7][5] = factory.crearPieza(Type.Bishop,true,this,5,7,loadImage("whiteBishop.png"));
     blancas.add(tablero[7][5]);
     tablero[7][3] = factory.crearPieza(Type.Queen,true,this,3,7,loadImage("whiteQueen.png"));
     blancas.add(tablero[7][3]);
     tablero[7][4] = factory.crearPieza(Type.King,true,this,4,7,loadImage("whiteKing.png"));
     blancas.add(tablero[7][4]);
     wKing = tablero[7][4];
     
     tablero[0][0] = factory.crearPieza(Type.Rook,false,this,0,0,loadImage("blackRook.png"));
     negras.add(tablero[0][0]);
     tablero[0][7] = factory.crearPieza(Type.Rook,false,this,7,0,loadImage("blackRook.png"));
     negras.add(tablero[0][7]);
     tablero[0][1] = factory.crearPieza(Type.Knight,false,this,1,0,loadImage("blackKnight.png"));
     negras.add(tablero[0][1]);
     tablero[0][6] = factory.crearPieza(Type.Knight,false,this,6,0,loadImage("blackKnight.png"));
     negras.add(tablero[0][6]);
     tablero[0][2] = factory.crearPieza(Type.Bishop,false,this,2,0,loadImage("blackBishop.png"));
     negras.add(tablero[0][2]);
     tablero[0][5] = factory.crearPieza(Type.Bishop,false,this,5,0,loadImage("blackBishop.png"));
     negras.add(tablero[0][5]);
     tablero[0][3] = factory.crearPieza(Type.Queen,false,this,3,0,loadImage("blackQueen.png"));
     negras.add(tablero[0][3]);
     tablero[0][4] = factory.crearPieza(Type.King,false,this,4,0,loadImage("blackKing.png"));
     negras.add(tablero[0][4]);
     bKing = tablero[0][4];
   }
   
   //Verifica si un movimiento es válido para una pieza específica
   public boolean piezaMovValido(Pieza pieza, int x, int y) {
     if(pieza instanceof Pawn) {
       if(checkEnPassant(pieza,x,y)) return true;
     } else if (pieza instanceof King) {
         if(pieza.isBlanco() && (x == 2 && y == 7)) {
           if(checkCastleLeft(pieza,tablero[7][0])) return true;
         } else if(pieza.isBlanco() == false && (x == 2 && y == 0)) {
           if(checkCastleLeft(pieza,tablero[0][0])) return true;
           }
         if(pieza.isBlanco() && (x == 6 && y == 7)) {
           if(checkCastleRight(pieza,tablero[7][7])) return true;
         } else if (pieza.isBlanco() == false && (x == 6 && y == 0)) {
           if(checkCastleRight(pieza,tablero[0][7])) return true;
           }
       }
     return pieza.movValido(x,y);
   }
   
   //Verifica si una pieza puede realizar captura al paso
   public boolean checkEnPassant(Pieza pieza, int x, int y) {
     if(!(pieza instanceof Pawn)) return false;
     int pieceX = pieza.getX();
     int pieceY = pieza.getY();
     if (pieza.isBlanco()) {
           if(tablero[y2][x2] != null && tablero[y2][x2] instanceof Pawn && tablero[y2][x2].isBlanco() != pieza.isBlanco()) {
             if(pieceY == 3 && y2 == y1 + 2 && x1 == pieceX + 1) {
               if(y == pieceY-1 && x == pieceX + 1) return true;
             } else if(pieceY == 3 && y2 == y1 + 2 && x1 == pieceX - 1) {
               if(y == pieceY-1 && x == pieceX - 1) return true;
             }
           }
         } else {
           if(tablero[y2][x2] != null && tablero[y2][x2] instanceof Pawn && tablero[y2][x2].isBlanco() != pieza.isBlanco()) {
             if(pieceY == 4 && y2 == y1 - 2 && x1 == pieceX + 1) {
               if(y == pieceY+1 && x == pieceX + 1) return true;
             } else if(pieceY == 4 && y2 == y1 - 2 && x1 == pieceX - 1) {
               if(y == pieceY+1 && x == pieceX - 1) return true;
             }
           }
         }
         return false;
   }
   
   //Verifica la posibilidad de enroque a la izquierda
   public boolean checkCastleLeft(Pieza pieza1, Pieza pieza2) {
     if(!(pieza1 instanceof King)) return false;
     if(!(pieza2 instanceof Rook)) return false;
     if(pieza1.isBlanco() != pieza2.isBlanco()) return false;
     if(jaque(pieza1.getX(),pieza1.getY(),pieza1.isBlanco())) return false;
     King king = (King) pieza1;
     Rook rook = (Rook) pieza2;
     if(king.hasMoved() || rook.hasMoved()) return false;
     if(pieza1.isBlanco()) {
       if(tablero[7][3] == null && tablero[7][2] == null && tablero[7][1] == null && tablero[7][0] == pieza2) {
         if(jaque(3,7,true) || jaque(2,7,true) || jaque(1,7,true)) return false;
         return true;
       }
     } else {
       if(tablero[0][3] == null && tablero[0][2] == null && tablero[0][1] == null && tablero[0][0] == pieza2) {
         if(jaque(3,0,false) || jaque(2,0,false) || jaque(1,0,false)) return false;
         return true;
       }
     }
     return false;
   }
   
   //Verifica la posibilidad de enroque a la derecha
   public boolean checkCastleRight(Pieza pieza1, Pieza pieza2) {
     if(!(pieza1 instanceof King)) return false;
     if(!(pieza2 instanceof Rook)) return false;
     if(pieza1.isBlanco() != pieza2.isBlanco()) return false;
     if(jaque(pieza1.getX(),pieza1.getY(),pieza1.isBlanco())) return false;
     King king = (King) pieza1;
     Rook rook = (Rook) pieza2;
     if(king.hasMoved() || rook.hasMoved()) return false;
     if(pieza1.isBlanco()) {
       if(tablero[7][5] == null && tablero[7][6] == null && tablero[7][7] == pieza2) {
         if(jaque(5,7,true) || jaque(6,7,true)) return false;
         return true;
       }
     } else {
       if(tablero[0][5] == null && tablero[0][6] == null && tablero[0][7] == pieza2) {
         if(jaque(5,0,false) || jaque(6,0,false)) return false;
         return true;
       }
     }
     return false;
   }
   
   //Verifica si un movimiento es válido considerando todas las reglas
   public boolean movValido(Pieza pieza,int x, int y) {
     if(pieza == null) return false;
     if(!piezaMovValido(pieza,x,y)) return false;
     if(movAJaque(pieza.getX(), pieza.getY(), x,y,pieza.isBlanco())) return false;
     return true;
   }
   
   //Mueve una pieza y realiza acciones adicionales como capturas o enroques
   public String mover(Pieza pieza, int newX, int newY) {
     int x = pieza.getX();
     int y = pieza.getY();
     boolean captura = false;
     boolean enPassant = false;
     boolean castleRight = false;
     boolean castleLeft = false;
     
     if(checkEnPassant(pieza,newX,newY)) {
       enPassant = true;
       if(pieza.isBlanco()) {
         negras.remove(tablero[newY + 1][newX]);
         capturadas.add(tablero[newY + 1][newX]);
         tablero[newY + 1][newX] = null;
       } else {
         blancas.remove(tablero[newY - 1][newX]);
         capturadas.add(tablero[newY - 1][newX]);
         tablero[newY - 1][newX] = null;
       }
     }
     
     if(pieza.isBlanco() && (newX == 2 && newY == 7)) {
       if(checkCastleLeft(pieza,tablero[7][0])) {
         tablero[7][3] = tablero[7][0];
         tablero[7][3].setX(3);
         tablero[7][3].setY(7);
         tablero[7][0] = null;
         castleLeft = true;
       }
     } else if(pieza.isBlanco() == false && (newX == 2 && newY == 0)) {
         if(checkCastleLeft(pieza,tablero[0][0])) {
           tablero[0][3] = tablero[0][0];
           tablero[0][3].setX(3);
           tablero[0][3].setY(0);
           tablero[0][0] = null;
           castleLeft = true;
         }
     } else if (pieza.isBlanco() && (newX == 6 && newY == 7)) {
         if(checkCastleRight(pieza,tablero[7][7])) {
           tablero[7][5] = tablero[7][7];
           tablero[7][5].setX(5);
           tablero[7][5].setY(7);
           tablero[7][7] = null;
           castleRight = true;
         }
     } else if (pieza.isBlanco() == false && (newX == 6 && newY == 0)) {
         if(checkCastleRight(pieza,tablero[0][7])) {
             tablero[0][5] = tablero[0][7];
             tablero[0][5].setX(5);
             tablero[0][5].setY(0);
             tablero[0][7] = null;
             castleRight = true;
           }
     }
     
     if(tablero[newY][newX] != null && tablero[newY][newX].isBlanco() != pieza.isBlanco()) {
     captura = true;
     capturadas.add(tablero[newY][newX]);
     if(pieza.isBlanco()) negras.remove(tablero[newY][newX]);
     else blancas.remove(tablero[newY][newX]);
     }
     
     pieza.mover(newX,newY);
     if(pieza instanceof Pawn) {
       Pawn peon = (Pawn) pieza;
       peon.setMovido(true);
     }
     if(pieza instanceof King) {
       King king = (King) pieza;
       king.setMovido(true);
     }
     if(pieza instanceof Rook) {
       Rook rook = (Rook) pieza;
       rook.setMovido(true);
     }
     
     String tile = tileNotation(newX,newY);
     String piece = pieceNotation(pieza);
     String resultado;
     if(captura) {
       if(pieza instanceof Pawn) resultado = char(x+97) + piece + "x" + tile;
       else resultado = piece + "x" + tile;
     } else if(enPassant) {
       resultado = char(x+97) + piece + "x" + tile + " e.p";
     } else if(castleLeft) {
       resultado = "0-0-0";
     } else if(castleRight) {
       resultado = "0-0";
     } else {
       resultado = (piece + tile);
     }
     
     
     if(jaqueMate(wKing.getX(),wKing.getY(),true) || jaqueMate(bKing.getX(),bKing.getY(),false)) resultado = resultado + "#";
     else if(jaque(wKing.getX(),wKing.getY(),true) || jaque(bKing.getX(),bKing.getY(),false)) resultado = resultado + "+";
     
     x1 = x;
     x2 = newX;
     y1 = y;
     y2 = newY;
     
     return resultado;
   }
   
   //Verifica si el rey de un color está en jaque
   public boolean jaque(int x, int y, boolean blanco) {
     for(int i = 0;i<8;i++) {
       for(int j = 0;j<8;j++) {
         if(tablero[i][j] != null && tablero[i][j].isBlanco() != blanco && tablero[i][j].movValido(x,y)) return true;
       }
     }
     return false;
  }
  
  //Verifica si un movimiento pone en jaque al rey
  public boolean movAJaque(int x, int y, int xMov, int yMov, boolean blanco) {
   Pieza piezaOrigen = tablero[y][x];
   Pieza piezaDestino = tablero[yMov][xMov];
   piezaOrigen.mover(xMov,yMov);
   if(blanco) {
     if(jaque(wKing.getX(),wKing.getY(),blanco)) {
       tablero[y][x] = piezaOrigen;
       tablero[yMov][xMov] = piezaDestino;
       piezaOrigen.setX(x);
       piezaOrigen.setY(y);
       return true;
     }
   }
   else {
     if(jaque(bKing.getX(),bKing.getY(),blanco)) {
       tablero[y][x] = piezaOrigen;
       tablero[yMov][xMov] = piezaDestino;
       piezaOrigen.setX(x);
       piezaOrigen.setY(y);
       return true;
     }
   }
   tablero[y][x] = piezaOrigen;
   tablero[yMov][xMov] = piezaDestino;
   piezaOrigen.setX(x);
   piezaOrigen.setY(y);
   return false;
  }
  
  //Verifica si un color está en jaque mate
  public boolean jaqueMate(int x, int y, boolean blanco) {
    if (!jaque(x,y,blanco)) return false;
    for (int k = 0; k<8; k++) {
      for (int l = 0; l<8; l++) {
        Pieza piezaActual = tablero[l][k];
        if (piezaActual == null || piezaActual.isBlanco() != blanco)
          continue;
        for (int i = 0; i<8; i++) {
          for (int j = 0; j<8; j++) {
            if (piezaMovValido(piezaActual,i,j) && !movAJaque(k,l,i,j,blanco))  {
              return false;
            }
          }
        }
      }
    }
  return true;
  }
  
  //Promueve un peón a otra pieza
  public void promote(Pawn pawn, Type type) {
    boolean blanco = pawn.isBlanco();
    int x = pawn.getX();
    int y = pawn.getY();
    if(blanco) {
      if(type == Type.Rook) {
       tablero[y][x] = factory.crearPieza(Type.Rook,blanco,this,x,y,loadImage("whiteRook.png"));
      } else if (type == Type.Knight) {
       tablero[y][x] = factory.crearPieza(Type.Knight,blanco,this,x,y,loadImage("whiteKnight.png"));
      } else if (type == Type.Bishop) {
       tablero[y][x] = factory.crearPieza(Type.Bishop,blanco,this,x,y,loadImage("whiteBishop.png"));
      } else if (type == Type.Queen) {
        tablero[y][x] = factory.crearPieza(Type.Queen,blanco,this,x,y,loadImage("whiteQueen.png"));
      }
      blancas.add(tablero[y][x]);
      blancas.remove(pawn);
    } else {
      if(type == Type.Rook) {
       tablero[y][x] = factory.crearPieza(Type.Rook,blanco,this,x,y,loadImage("blackRook.png"));
      } else if (type == Type.Knight) {
       tablero[y][x] = factory.crearPieza(Type.Knight,blanco,this,x,y,loadImage("blackKnight.png"));
      } else if (type == Type.Bishop) {
       tablero[y][x] = factory.crearPieza(Type.Bishop,blanco,this,x,y,loadImage("blackBishop.png"));
      } else if (type == Type.Queen) {
        tablero[y][x] = factory.crearPieza(Type.Queen,blanco,this,x,y,loadImage("blackQueen.png"));
      }
      negras.add(tablero[y][x]);
      negras.remove(pawn);
    }
  }
  
  //Convierte coordenadas a notación de ajedrez
  public String tileNotation(int x, int y) {
    String yTexto = String.valueOf(java.lang.Math.abs(y-8));
    return char(x + 97) + yTexto;
  }
  
  //Obtiene la notación de una pieza
  public String pieceNotation(Pieza pieza) {
    String piezaTexto = "";
    if(pieza instanceof Pawn) {
      piezaTexto = "";
    } else if(pieza instanceof Rook) {
      piezaTexto = "R";
    } else if(pieza instanceof Knight) {
      piezaTexto = "N";
    } else if (pieza instanceof Bishop) {
      piezaTexto = "B";
    } else if (pieza instanceof Queen) {
      piezaTexto = "Q";
    } else if (pieza instanceof King) {
      piezaTexto = "K";
    }
    return piezaTexto;
  }
  
  //Retorna los reyes blanco y negro
  public Pieza getbKing() {
    return bKing;
  }
  public Pieza getwKing() {
    return wKing;
  }
  
  public void setwKing(Pieza king) {
    wKing = king;
  }
  
  public void setbKing(Pieza king) {
    bKing = king;
  }
  
  public ArrayList<Pieza> getBlancas() {
    return blancas;
  }
  
  public void setBlancas(ArrayList<Pieza> lista) {
    blancas.clear();
    blancas = lista;
  }
  
  public void setNegras(ArrayList<Pieza> lista) {
    negras.clear();
    negras = lista;
  }
  
  public void setCapturadas(ArrayList<Pieza> lista) {
    capturadas.clear();
    capturadas = lista;
  }
  
  public ArrayList<Pieza> getNegras() {
    return negras;
  }
  
  //Retorna las piezas capturadas
  public ArrayList<Pieza> getCapturadas() {
    return capturadas;
  } 
  
  public int getX1() {
    return x1;
  }
  
  public void setX1(int x1) {
    this.x1 = x1;
  }
  
  
  public int getX2() {
    return x2;
  }
  
  public void setX2(int x2) {
    this.x2 = x2;
  }
  
  public int getY1() {
    return y1;
  }
  
  public void setY1(int y1) {
    this.y1 = y1;
  }
  
  public int getY2() {
    return y2;
  }
  
  public void setY2(int y2) {
    this.y2 = y2;
  }
}
