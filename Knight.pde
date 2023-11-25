public class Knight extends Pieza {
  //Constructor de la clase Knight
  public Knight(boolean blanco, Partida juego, int x, int y, PImage sprite,String type) {
    super(blanco,juego,x,y,sprite,type); //Llama al constructor de la clase base (Pieza)
  }
  
  //Método para validar si un movimiento es válido para el caballo
  public boolean movValido(int newX, int newY) {
    //Verifica si las coordenadas del nuevo movimiento están dentro de los límites del tablero
    if(newX < 0 || newX > 7 || newY < 0 || newY > 7)
      return false;
      
    //Obtiene el tablero actual de la partida
    Pieza[][] tablero = juego.getTablero();
    
    //Comprueba si el movimiento se ajusta al movimiento del caballo
    Pieza piezaActual = tablero[newY][newX];
    if(((abs(newY-y) == 2 && abs(newX-x) == 1) || (abs(newY-y) == 1 && abs(newX-x) == 2)) && (piezaActual == null || piezaActual.isBlanco() != blanco)) return true;
    return false;
  }
}
