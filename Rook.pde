public class Rook extends Pieza {
  //Variable para llevar el registro de si la torre ha sido movida
  private boolean movido = false;
  
  //Constructor de la clase Rook
  public Rook(boolean blanco, Partida juego, int x, int y, PImage sprite,String type) {
    super(blanco,juego,x,y,sprite,type); //Llama al constructor de la clase pieza
  }
  
  //Método para validar si un movimiento es válido para la torre
  public boolean movValido(int newX, int newY) {
    //Verifica si las coordenadas del nuevo movimiento están dentro de los límites del tablero
    if(newX < 0 || newX > 7 || newY < 0 || newY > 7)
      return false;
    Pieza[][] tablero = juego.getTablero();
    Pieza piezaActual = tablero[newY][newX];
    
    // La torre se mueve en líneas rectas a lo largo de filas y columnas
    // Verifica si hay un camino continuo en cada una de las direcciones posibles
    if(caminoContinuo(newX,newY,-1,0)) return true; //Vertical hacia arriba
    if(caminoContinuo(newX,newY,1,0)) return true; //Vertical hacia abajo
    if(caminoContinuo(newX,newY,0,-1)) return true; //Horizontal hacia la izquierda
    if(caminoContinuo(newX,newY,0,1)) return true; //Horizontal hacia la derecha
    return false; //Si no se cumplen las condiciones, el movimiento no es válido
  }
  
  //Métodos para marcar y verificar si la torre ha sido movida
  public void setMovido(boolean movido) {
    this.movido = movido;
  } 
  public boolean hasMoved() {
    return movido;
  }
  
}
