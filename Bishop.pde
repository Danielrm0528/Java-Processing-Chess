public class Bishop extends Pieza {
  //Constructor de la clase Bishop
  public Bishop(boolean blanco, Partida juego, int x, int y, PImage sprite,String type) {
    super(blanco,juego,x,y,sprite,type); //Llama al constructor de la clase pieza
  }
  
  //Método para validar si un movimiento es válido para el alfil
  public boolean movValido(int newX, int newY) {
    //Verifica si las coordenadas del nuevo movimiento están dentro de los límites del tablero
    if(newX < 0 || newX > 7 || newY < 0 || newY > 7)
      return false;
    
    //Obtiene el tablero actual de la partida
    Pieza[][] tablero = juego.getTablero();
    Pieza piezaActual = tablero[newY][newX];
    
    //Comprueba si el camino al destino está libre y se mueve en diagonal
    if(caminoContinuo(newX,newY,1,1)) return true;
    if(caminoContinuo(newX,newY,1,-1)) return true;
    if(caminoContinuo(newX,newY,-1,1)) return true;
    if(caminoContinuo(newX,newY,-1,-1)) return true;
    return false; //Si ninguna condición se cumple, el movimiento no es válido
  }
  
}
