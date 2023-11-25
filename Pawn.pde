public class Pawn extends Pieza {
  //Variable para llevar el registro de si el peón ha movido
  private boolean movido = false;
  
  //Constructor de la clase Pawn
  public Pawn(boolean blanco, Partida juego, int x, int y, PImage sprite,String type) {
    super(blanco,juego,x,y,sprite,type); //Llama al constructor de la clase pieza
  }
  
  //Método para validar si un movimiento es válido para el peón
  public boolean movValido(int newX, int newY) {
    //Verifica si las coordenadas del nuevo movimiento están dentro de los límites del tablero
    if(newX < 0 || newX > 7 || newY < 0 || newY > 7)
      return false;
      
    //Obtiene el tablero actual de la partida
    Pieza[][] tablero = juego.getTablero();
    Pieza piezaActual = tablero[newY][newX];
    
    //Lógica de movimiento para peones blancos
    if(blanco) {
      //Movimiento hacia adelante una casilla
      if((newX == x) && newY == y-1 && piezaActual == null) return true; 
      //Movimiento inicial de dos casillas
      else if(!movido && newX == x && newY == y-2 && tablero[y-1][x] == null && piezaActual == null) return true;
    
      //Captura diagonal hacia la derecha
      if(x != 7) {
        if(newX == x+1 && newY == y-1 && piezaActual != null && piezaActual.isBlanco() != blanco) return true;
        
      }
      
      //Captura diagonal hacia la izquierda
      if(x != 0) {
        if(newX == x-1 && newY == y-1 && piezaActual != null && piezaActual.isBlanco() != blanco) return true;
      }
   } else {
      //Lógica de movimiento para peones negros, similar a la de los blancos pero en dirección opuesta
      if((newX == x) && newY == y+1 && piezaActual == null) return true; 
      else if(!movido && newX == x && newY == y+2 && tablero[y+1][x] == null && piezaActual == null) return true;
    
      if(x != 7) {
        if(newX == x+1 && newY == y+1 && piezaActual != null && piezaActual.isBlanco() != blanco) return true;
      }
      if(x != 0) {
        if(newX == x-1 && newY == y+1 && piezaActual != null && piezaActual.isBlanco() != blanco) return true;
      }
   }
    return false; //Si no se cumplen las condiciones, el movimiento no es válido
  }
  
  //Método para marcar que el peón ha movido
  public void setMovido(boolean movido) {
    this.movido = movido;
  }
  
  public boolean hasMoved() {
    return movido;
  }
}
