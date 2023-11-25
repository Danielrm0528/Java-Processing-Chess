public class King extends Pieza {
  //Variable para llevar el registro si el rey se ha movido
  private boolean movido = false;
  
  //Constructor de la clase King
  public King(boolean blanco, Partida juego, int x, int y, PImage sprite,String type) {
    super(blanco,juego,x,y,sprite,type); //Llama al constructor de la clase base (Pieza)
  }
  
  //Método para validar si un movimiento es válido para el rey
  public boolean movValido(int newX, int newY) {
    //Verifica si las coordenadas del nuevo movimiento están dentro de los límites del tablero
    if(newX < 0 || newX > 7 || newY < 0 || newY > 7)
      return false;
      
    //Obtiene el tablero actual de la partida
    Pieza[][] tablero = juego.getTablero();
    
    //Comprueba si el movimiento es válido para el rey
    Pieza piezaActual = tablero[newY][newX];
    if(abs(x - newX) <= 1 && abs(y - newY) <= 1 && (piezaActual == null || piezaActual.isBlanco() != blanco)) {
      return true;
    }
    return false; //Si no se cumplen las condiciones, el movimiento no es válido
  }
  
  //Método para marcar que el rey se ha movido
  public void setMovido(boolean movido) {
    this.movido = movido;
  }
  
  //Método para verificar si el rey se ha movido
  public boolean hasMoved() {
    return movido;
  }
}
