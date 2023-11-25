import processing.data.JSONObject;

public class Ajedrez {
  //Variables de instancia
  private Partida partida; //Representa la partida de ajedrez actual
  private boolean turn; //Verdadero si es el turno de las blancas, falso si es el turno de las negras
  private int turnNum = 1; //Contador de turnos
  private String jug1 = "blancas"; //Nombre de la persona jugadora con piezas blancas
  private String jug2 = "negras";  //Nombre de la persona jugadora con piezas negras
  
  //Constructor de la clase
  public Ajedrez() {
    partida = new Partida(); //Inicializa una nueva partida
    turn = true;  //Comienza con el turno de las blancas
  }
  
  //Inicia el tablero de ajedrez
  public void iniciarTablero() {
    partida.inicializarTablero();
  }
  
  //Obtiene una pieza en una posición específica del tablero
  private Pieza getPieza(int x, int y) {
    return partida.getTablero()[y][x];
  }
  
  //Verifica si un movimiento es válido
  public boolean movValido(int x, int y, int newX, int newY) {
    Pieza pieza = getPieza(x,y);
    if(pieza == null || pieza.isBlanco() != turn) return false;
    return partida.movValido(pieza,newX,newY);
  }
  
  //Mueve una pieza en el tablero
  public String mover(int x, int y, int newX, int newY) {
    Pieza piezaActual = getPieza(x,y);
    if(!partida.movValido(piezaActual,newX,newY)) return "";
    if(piezaActual != null && piezaActual.isBlanco() == turn) {
      turn = !turn;
      if(turn) turnNum++;
      String res = partida.mover(piezaActual,newX,newY);
        return res;
    }
    else
      return "";
  }
  
  //Obtiene una representación gráfica del tablero
  public PImage[][] getTablero() {
    PImage[][] tableroImg = new PImage[8][8];
    for(int i = 0;i<8;i++) {
      for(int j = 0;j<8;j++) {
        Pieza pieza = partida.getTablero()[i][j];
        if(pieza != null) tableroImg[i][j] = pieza.getImage();
      }
    }
    return tableroImg;
  }
  
  //Comprueba si hay jaque mate
  public boolean jaqueMate(boolean turn) {
    if(turn) {
      //Comprueba si el rey del turno actual está en jaque mate
      Pieza wKing = partida.getwKing();
      return partida.jaqueMate(wKing.getX(),wKing.getY(),true);
    } else {
      Pieza bKing = partida.getbKing();
      return partida.jaqueMate(bKing.getX(),bKing.getY(),false);
    }
  }
  
  //Comprueba si hay jaque
  public boolean jaque(boolean turn) {
    if(turn) {
      //Comprueba si el rey del turno actual está en jaque
      Pieza wKing = partida.getwKing();
      return partida.jaque(wKing.getX(),wKing.getY(),true);
    } else {
      Pieza bKing = partida.getbKing();
      return partida.jaque(bKing.getX(),bKing.getY(),false);
    }
  }
  
  //Verifica si una pieza puede ser promovida
  public boolean canPromote(int x, int y) {
    Pieza piezaActual = getPieza(x,y);
    if(piezaActual == null) return false;
    if (!(piezaActual instanceof Pawn)) return false;
    if(y != 0 && y != 7) return false;
    return true;
  }
  
  //Promueve una pieza
  public void promote(int x, int y, Type type) {
    if(canPromote(x,y)) {
      Pawn pawn = (Pawn) getPieza(x,y);
      partida.promote(pawn, type);
    }
  }
  
  //Métodos para configurar y obtener los nombres de las personas jugadoras
  public void setJug1(String nombre) {
    jug1 = nombre;
  }
  public void setJug2(String nombre) {
    jug2 = nombre;
  }
  public String getJug1() {
    return jug1;
  }
  public String getJug2() {
    return jug2;
  }
  
  //Devuelve de quién es el turno actual
  public String turnoDe() {
    if(turn) return jug1;
    else return jug2;
  }
  
  //Devuelve el número actual del turno
  public int turnNum() {
    return turnNum;
  }
  
  //Devuelve el estado del turno
  public boolean getTurn() {
    return turn;
  }
  
  //Métodos para obtener las imágenes de las piezas capturadas
  public ArrayList<PImage> capturadasBlancas() {
    ArrayList<PImage> imagenes = new ArrayList<PImage>();
    for(Pieza p:partida.getCapturadas()) {
      if(p.isBlanco()) imagenes.add(p.getImage());
    }
    return imagenes;
  }
  
  public ArrayList<PImage> capturadasNegras() {
    ArrayList<PImage> imagenes = new ArrayList<PImage>();
    for(Pieza p:partida.getCapturadas()) {
      if(!p.isBlanco()) imagenes.add(p.getImage());
    }
    return imagenes;
  }
  
  public void loadGame(File path) {
    if(path == null) {
      return;
    }
    
    String nombre = path.getName();
    int index = nombre.lastIndexOf('.');
    if(index > 0) {
      String extension = nombre.substring(index+1);
      if(!extension.equals("json")) return;
    }
    
    
    PiezaFactory factory = new PiezaFactory();
    JSONObject main = loadJSONObject(path);
    ArrayList<Pieza> blancas = new ArrayList();
    JSONArray piezasBlancas = main.getJSONArray("piezasBlancas");
    for(int i = 0; i < piezasBlancas.size();i++) {
      JSONObject pieza = piezasBlancas.getJSONObject(i);
      String type = pieza.getString("tipo");
      if(type.equals("p")) {
        Pieza piezaObj = factory.crearPieza(Type.Pawn,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/whitePawn.png"));
        println(piezaObj);
        Pawn pawn = (Pawn) piezaObj;
        pawn.setMovido(pieza.getBoolean("movido"));
        blancas.add(piezaObj);
      } else if(type.equals("r")) {
        Pieza piezaObj = factory.crearPieza(Type.Rook,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/whiteRook.png"));
        Rook rook = (Rook) piezaObj;
        rook.setMovido(pieza.getBoolean("movido"));
        blancas.add(piezaObj);
      } else if(type.equals("k")) {
        Pieza piezaObj = factory.crearPieza(Type.King,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/whiteKing.png"));
        King king = (King) piezaObj;
        king.setMovido(pieza.getBoolean("movido")); 
        partida.setwKing(piezaObj);
        blancas.add(piezaObj);
      } else if(type.equals("n")) {
        Pieza piezaObj = factory.crearPieza(Type.Knight,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/whiteKnight.png"));
        blancas.add(piezaObj);
      } else if(type.equals("b")) {
        Pieza piezaObj = factory.crearPieza(Type.Bishop,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/whiteBishop.png"));
        blancas.add(piezaObj);
      } else if (type.equals("q")) {
        Pieza piezaObj = factory.crearPieza(Type.Queen,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/whiteQueen.png"));
        blancas.add(piezaObj);
      }
    }
    partida.setBlancas(blancas);
    
    
    ArrayList<Pieza> negras = new ArrayList();
    JSONArray piezasNegras = main.getJSONArray("piezasNegras");
    for(int i = 0; i < piezasNegras.size();i++) {
      JSONObject pieza = piezasNegras.getJSONObject(i);
      String type = pieza.getString("tipo");
      if(type.equals("p")) {
        Pieza piezaObj = factory.crearPieza(Type.Pawn,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/blackPawn.png"));
        Pawn pawn = (Pawn) piezaObj;
        pawn.setMovido(pieza.getBoolean("movido"));
        negras.add(piezaObj);
      } else if(type.equals("r")) {
        Pieza piezaObj = factory.crearPieza(Type.Rook,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/blackRook.png"));
        Rook rook = (Rook) piezaObj;
        rook.setMovido(pieza.getBoolean("movido"));
        negras.add(piezaObj);
      } else if(type.equals("k")) {
        Pieza piezaObj = factory.crearPieza(Type.King,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/blackKing.png"));
        King king = (King) piezaObj;
        king.setMovido(pieza.getBoolean("movido")); 
        partida.setbKing(piezaObj);
        negras.add(piezaObj);
      } else if(type.equals("n")) {
        Pieza piezaObj = factory.crearPieza(Type.Knight,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/blackKnight.png"));
        negras.add(piezaObj);
      } else if(type.equals("b")) {
        Pieza piezaObj = factory.crearPieza(Type.Bishop,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/blackBishop.png"));
        negras.add(piezaObj);
      } else if (type.equals("q")) {
        Pieza piezaObj = factory.crearPieza(Type.Queen,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),loadImage("Pieces/blackQueen.png"));
        negras.add(piezaObj);
      }
    }
    partida.setNegras(negras);
    
    ArrayList<Pieza> capturadas = new ArrayList();
    JSONArray piezasCapturadas = main.getJSONArray("piezasCapturadas");
    for(int i = 0; i < piezasCapturadas.size();i++) {
      JSONObject pieza = piezasCapturadas.getJSONObject(i);
      String type = pieza.getString("tipo");
      PImage img = null;
      if(type.equals("p")) {
        if(pieza.getBoolean("blanco")) img = loadImage("Pieces/whitePawn.png");
        else img = loadImage("blackPawn.png");
        Pieza piezaObj = factory.crearPieza(Type.Pawn,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),img);
        capturadas.add(piezaObj);
      } else if(type.equals("r")) {
        if(pieza.getBoolean("blanco")) img = loadImage("Pieces/whiteRook.png");
        else img = loadImage("blackRook.png");
        Pieza piezaObj = factory.crearPieza(Type.Rook,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),img);
        capturadas.add(piezaObj);
      } else if(type.equals("k")) {
        if(pieza.getBoolean("blanco")) img = loadImage("Pieces/whiteKing.png");
        else img = loadImage("blackKing.png");
        Pieza piezaObj = factory.crearPieza(Type.King,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),img);
        capturadas.add(piezaObj);
      } else if(type.equals("n")) {
        if(pieza.getBoolean("blanco")) img = loadImage("Pieces/whiteKnight.png");
        else img = loadImage("blackKnight.png");
        Pieza piezaObj = factory.crearPieza(Type.Knight,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),img);
        capturadas.add(piezaObj);
      } else if(type.equals("b")) {
        if(pieza.getBoolean("blanco")) img = loadImage("Pieces/whiteBishop.png");
        else img = loadImage("blackBishop.png");
        Pieza piezaObj = factory.crearPieza(Type.Bishop,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),img);
        capturadas.add(piezaObj);
      } else if (type.equals("q")) {
        if(pieza.getBoolean("blanco")) img = loadImage("Pieces/whiteQueen.png");
        else img = loadImage("blackQueen.png");
        Pieza piezaObj = factory.crearPieza(Type.Queen,pieza.getBoolean("blanco"),partida,pieza.getInt("x"),pieza.getInt("y"),img);
        capturadas.add(piezaObj);
      }
    }
    partida.setCapturadas(capturadas);
    
    JSONObject movAnteriores = main.getJSONObject("movAnteriores");
    partida.setX1(movAnteriores.getInt("x1"));
    partida.setX2(movAnteriores.getInt("x2"));
    partida.setY1(movAnteriores.getInt("y1"));
    partida.setY2(movAnteriores.getInt("y2"));
    
    JSONObject partidaAtributos = main.getJSONObject("partidaAtributos");
    turn = partidaAtributos.getBoolean("turn");
    turnNum = partidaAtributos.getInt("turnNum");
    jug1 = partidaAtributos.getString("jug1");
    jug2 = partidaAtributos.getString("jug2");
    
    Pieza[][] tablero = partida.getTablero();
    
    
    for (int i = 0; i<8; i++) {
      for (int j = 0; j<8; j++) {
        tablero[j][i] = null;
      }
    }
    
    for(Pieza p:partida.getBlancas()) {
      int x = p.getX();
      int y = p.getY();
      tablero[y][x] = p;
    }
    
    for(Pieza p:partida.getNegras()) {
      int x = p.getX();
      int y = p.getY();
      tablero[y][x] = p;
    }
    
  }
  
  public void saveGame(File path) {
    if(path == null) return;
    
    JSONObject main = new JSONObject();
    
    JSONArray piezasBlancas = new JSONArray();
    int i = 0;
    for(Pieza p: partida.getBlancas()) {
      JSONObject pieza = new JSONObject();
      pieza.setString("tipo", p.getType());
      pieza.setInt("x", p.getX());
      pieza.setInt("y", p.getY());
      pieza.setBoolean("blanco", p.isBlanco());
      if(p instanceof King) {
        King k = (King) p;
        pieza.setBoolean("movido", k.hasMoved());
      }
      if(p instanceof Rook) {
        Rook r = (Rook) p;
        pieza.setBoolean("movido", r.hasMoved());
      }
      if(p instanceof Pawn) {
        Pawn pawn = (Pawn) p;
        pieza.setBoolean("movido", pawn.hasMoved());
      }
      piezasBlancas.setJSONObject(i,pieza);
      i++;
    }
    main.setJSONArray("piezasBlancas",piezasBlancas);
    
    JSONArray piezasNegras = new JSONArray();
    i = 0;
    for(Pieza p: partida.getNegras()) {
      JSONObject pieza = new JSONObject();
      pieza.setString("tipo", p.getType());
      pieza.setInt("x", p.getX());
      pieza.setInt("y", p.getY());
      pieza.setBoolean("blanco", p.isBlanco());
      if(p instanceof King) {
        King k = (King) p;
        pieza.setBoolean("movido", k.hasMoved());
      }
      if(p instanceof Rook) {
        Rook r = (Rook) p;
        pieza.setBoolean("movido", r.hasMoved());
      }
      if(p instanceof Pawn) {
        Pawn pawn = (Pawn) p;
        pieza.setBoolean("movido", pawn.hasMoved());
      }
      piezasNegras.setJSONObject(i,pieza);
      i++;
    }
    main.setJSONArray("piezasNegras",piezasNegras);
    
    JSONArray piezasCapturadas = new JSONArray();
    i = 0;
    for(Pieza p: partida.getCapturadas()) {
      JSONObject pieza = new JSONObject();
      pieza.setString("tipo", p.getType());
      pieza.setInt("x", p.getX());
      pieza.setInt("y", p.getY());
      pieza.setBoolean("blanco", p.isBlanco());
      piezasCapturadas.setJSONObject(i,pieza);
      i++;
    }
    main.setJSONArray("piezasCapturadas",piezasCapturadas);
    
    JSONObject movAnteriores = new JSONObject();
    movAnteriores.setInt("x1",partida.getX1());
    movAnteriores.setInt("x2",partida.getX2());
    movAnteriores.setInt("y1",partida.getY1());
    movAnteriores.setInt("y2",partida.getY2());
    main.setJSONObject("movAnteriores",movAnteriores);
    
    JSONObject partidaAtributos = new JSONObject();
    partidaAtributos.setBoolean("turn", turn);
    partidaAtributos.setInt("turnNum",turnNum);
    partidaAtributos.setString("jug1", jug1);
    partidaAtributos.setString("jug2", jug2);
    main.setJSONObject("partidaAtributos",partidaAtributos);
    
    saveJSONObject(main,path.getAbsolutePath() + ".json"); 
  }
  
  
}
