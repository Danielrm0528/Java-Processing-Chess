enum Type {
  //Enumeración de los tipos de piezas de ajedrez (en inglés)
  Pawn, Knight, Bishop, Rook, Queen, King
}

class PiezaFactory {
  //Constructor de la clase PiezaFactory
  public PiezaFactory() {}
  
  //Método para crear una instancia de una pieza de ajedrez
  public Pieza crearPieza(Type type, boolean blanco, Partida juego, int x, int y, PImage sprite) {
    Pieza pieza = null;
    
    //Crea una instancia de una pieza de ajedrez específica basada en el tipo
    if(type == Type.Pawn) {
      pieza = new Pawn(blanco, juego, x, y, sprite,"p");
    } else if (type == Type.King) {
      pieza = new King(blanco, juego, x, y, sprite,"k");
    } else if (type == Type.Knight) {
      pieza = new Knight(blanco, juego, x, y, sprite,"n");
    } else if (type == Type.Rook) {
      pieza = new Rook(blanco, juego, x, y, sprite,"r");
    } else if (type == Type.Bishop) {
      pieza = new Bishop(blanco, juego, x, y, sprite,"b");
    } else if (type == Type.Queen) {
      pieza = new Queen(blanco, juego, x, y, sprite,"q");
    }
    return pieza; //Retorna la pieza creada
  }
}
