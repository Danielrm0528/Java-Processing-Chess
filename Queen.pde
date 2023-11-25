public class Queen extends Pieza {
  //Constructor de la clase Queen
  public Queen(boolean blanco, Partida juego, int x, int y, PImage sprite,String type) {
    super(blanco,juego,x,y,sprite,type); //Llama al constructor de la clase pieza
  }
  
  //Método para validar si un movimiento es válido para la reina
  public boolean movValido(int newX, int newY) {
    //Verifica si las coordenadas del nuevo movimiento están dentro de los límites del tablero
    if(newX < 0 || newX > 7 || newY < 0 || newY > 7)
      return false;
    
    //Obtiene el tablero actual de la partida
    Pieza[][] tablero = juego.getTablero();
    Pieza piezaActual = tablero[newY][newX];
    
    //La reina se puede mover tanto en líneas rectas como en diagonales
    //Verifica si hay un camino continuo en cada una de las direcciones posibles
    if(caminoContinuo(newX,newY,1,1)) return true; //Diagonal hacia arriba y a la derecha
    if(caminoContinuo(newX,newY,1,-1)) return true; //Diagonal hacia abajo y a la derecha
    if(caminoContinuo(newX,newY,-1,1)) return true; //Diagonal hacia arriba y a la izquierda
    if(caminoContinuo(newX,newY,-1,-1)) return true; //Diagonal hacia abajo y a la izquierda
    if(caminoContinuo(newX,newY,-1,0)) return true; //Vertical hacia arriba
    if(caminoContinuo(newX,newY,1,0)) return true; //Vertical hacia abajo
    if(caminoContinuo(newX,newY,0,-1)) return true; //Horizontal hacia la izquierda
    if(caminoContinuo(newX,newY,0,1)) return true; //Horizontal hacia la derecha
    return false; //Si no se cumplen las condiciones, el movimiento no es válido
  } 
}
