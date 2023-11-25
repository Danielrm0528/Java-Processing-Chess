  abstract class Pieza {
    
  //Variables de instancia
  protected boolean blanco; //Verdadero si la pieza es blanca, falso si es negra
  protected int x; //Coordenada actual x de la pieza en el tablero
  protected int y; //Coordenada actual y de la pieza en el tablero
  protected PImage sprite; //Imagen que representa la pieza
  protected Partida juego; //Referencia al juego al que pertenece la pieza
  protected String type;
 
  //Constructor de la clase Pieza
  public Pieza(boolean blanco, Partida juego, int x, int y, PImage sprite,String type) {
    this.blanco = blanco;
    this.juego = juego;
    this.x = x;
    this.y = y;
    this.sprite = sprite;
    this.type = type;
  }
  
  //Mueve la pieza a una nueva posición en el tablero
  public void mover(int newX, int newY) {
            Pieza[][] tablero = juego.getTablero();
            //Verifica si el movimiento es hacia una casilla vacía o para capturar una pieza del color opuesto
            if (tablero[newY][newX] == null || tablero[newY][newX].blanco == !blanco) {
                tablero[y][x] = null; //Elimina la pieza de su posición anterior
                tablero[newY][newX] = this; //Coloca la pieza en la nueva posición
                x = newX; //Actualiza la posición x de la pieza
                y = newY; //Actualiza la posición y de la pieza
            }
  }
  
  //Métodos para las propiedades de la pieza
  public boolean isBlanco() {
    return blanco;
  }
  public PImage getImage() {
    return sprite;
  }
  public int getX() {
    return x;
  }
  public int getY() {
    return y;
  }
  public void setX(int x) {
    this.x = x;
  }
  public void setY(int y) {
    this.y = y;
  }
  
  public String getType() {
    return type;
  }
  
  public void setBlanco(boolean blanco) {
    this.blanco = blanco;
  }
  
  //Método abstracto que cada pieza específica debe implementar para validar sus movimientos
  public abstract boolean movValido(int newX, int newY);
  
  //Método para verificar si hay un camino continuo sin obstrucciones hasta un destino
  protected boolean caminoContinuo(int newX, int newY, int xMov, int yMov) {
    Pieza[][] tablero = juego.getTablero();
    
    //Itera a través del tablero en la dirección especificada
    for(int i = x + xMov,j = y + yMov;i<8 && i>=0 && j<8 && j>=0;i+=xMov,j+=yMov) {
      //Si encuentra una pieza del mismo color, no hay un camino continuo
      //Si encuentra una pieza del color opuesto, solo hay camino si es el destino
      if(tablero[j][i] != null && tablero[j][i].isBlanco() == blanco) return false;
      if(tablero[j][i] != null && tablero[j][i].isBlanco() != blanco) {
        return (i == newX && j == newY);
      }
      //Si ha llegado al destino sin obstrucciones, hay camino
      if(i == newX && j == newY)return true;
    }
    return false;
  }
}
