//Instituto Tecnológico de Costa Rica, Campus Tecnológico Local San José
//Escuela de Ingeniería en Computación, Bachillerato en Ingeniería en Computación
//IC-2101 Programación Orientada a Objetos}

//Proyecto 1 - Ajedrez
//Profesor Mauricio Avilés Cisneros
//Jose Daniel Romero Murillo y Christian David Torres Álvarez

Ajedrez partida = new Ajedrez(); //Crea la instancia del juego ajedrez
import controlP5.*; //Importa la librería ControlP5 para interfaces gráficas
ControlP5 cp5; //Declara un objeto de ControlP5

//Variables para controlar la interacción con el tablero
boolean click;
int piezaX;
int piezaY;
boolean iniciado = false;

//Elementos de la interfaz gráfica (campos de texto y botones)
Textfield texto1;
Textfield texto2;
Button inicio;
Button rendirse1;
int presR1 = 0;
Button rendirse2;
int presR2 = 0;
Button tablas1;
int presT1 = 0;
Button tablas2;
int presT2 = 0;

//Colores y otros estados del juego
CColor verde = new CColor();
int presionado = 0;
String movAnterior = "";
boolean promotion = false;
int peonX;
int peonY;
boolean print = false;
boolean jug1Ren = false;
boolean jug2Ren = false;
boolean jug1Tablas = false;
boolean jug2Tablas = false;

//Inicialización de componentes de ControlP5 y configuración de la ventana
void setup() {
  cp5 = new ControlP5(this);
  
  // Creación de fuentes para los elementos de texto
  PFont font = createFont("arial",20);
  PFont font2 = createFont("arial",10);
  
  //Configuración del color para los botones
  verde.setBackground(color(116,185,38));
  
  //Configuración del campo de texto para la persona jugadora con piezas blancas
  texto1 = cp5.addTextfield("blancas")
     .setPosition(400,200)
     .setSize(200,40)
     .setFont(font)
     .setFocus(false)
     .setColor(color(255,255,255))
     ;
     
  //Configuración del campo de texto para la persona jugadora con piezas negras
  texto2 = cp5.addTextfield("negras")
     .setPosition(400,400)
     .setSize(200,40)
     .setFont(font)
     .setFocus(false)
     .setColor(color(255,255,255))
     ;
  //Configuración del botón de inicio
  inicio = cp5.addButton("Iniciar")
     .setValue(0)
     .setPosition(425,525)
     .setSize(150,50)
     .setColor(verde)
     .setFont(font)
     ;
     
  //Configuración de los botones de rendición para ambas personas jugadoras
  rendirse1 = cp5.addButton("Rendirse1")
     .setValue(0)
     .setPosition(2000,2000)
     .setSize(75,30)
     .setFont(font2)
     .setCaptionLabel("Rendirse")
     ;
  rendirse2 = cp5.addButton("Rendirse2")
     .setValue(0)
     .setPosition(2000,2000)
     .setSize(75,30)
     .setFont(font2)
     .setCaptionLabel("Rendirse")
     ;
     
  //Configuración de los botones de "tablas" para ambas personas jugadoras
  tablas1 = cp5.addButton("Tablas1")
     .setValue(0)
     .setPosition(2000,2000)
     .setSize(60,30)
     .setFont(font2)
     .setCaptionLabel("Tablas")
     ;
  tablas2 = cp5.addButton("Tablas2")
     .setValue(0)
     .setPosition(2000,2000)
     .setSize(60,30)
     .setFont(font2)
     .setCaptionLabel("Tablas")
     ;
  
  //Configuración de la ventana de visualización
  size(1000, 640); //Establece el tamaño de la ventana
  noStroke(); //Desactiva el dibujo de bordes para formas
  
  //Inicialización del tablero de ajedrez
  partida.iniciarTablero();
}

//Lógica para dibujar el tablero, muestra mensajes, y maneja la promoción de peones
void draw() {
    rendirse1.setPosition(2000,2000);
    rendirse2.setPosition(2000,2000);
    tablas1.setPosition(2000,2000);
    tablas2.setPosition(2000,2000);
    if(!iniciado) {
      setNombres();
    } else if(promotion) {
      //Si hay una promoción de peón en curso, muestra las opciones de promoción
      if(!print) {
        fill(255,255,255);
        textSize(20);
        text("Promoción de peón: ",650,380);
        text("Reina (q), Alfil (b), Torre (r), Caballo (k)",650,410);
        print = true;
      }
    } else {
      print = false;
      texto1.setPosition(2000,2000);
      texto2.setPosition(2000,2000);
      inicio.setPosition(2000,2000);
      background(117,117,117);
      drawBoard();
    }
}

//Dibujar el tablero, las piezas, y maneja la lógica de renderizado
public void drawBoard() {
  //Muestra mensajes si algún jugador se ha rendido o si se ha llegado a un empate
  fill(255,0,0);
  if(jug1Ren) {
    text((partida.getJug1() + " se ha rendido"),650,230);
  } else if (jug2Ren) {
    text((partida.getJug2() + " se ha rendido"),650,230);
  } else if (jug1Tablas && jug2Tablas) {
    text(("Se ha hecho tablas (empate)"),650,230);
  }
  
  //Muestra información sobre el turno, número de turno y movimiento anterior
  fill(255,255,255);
  rendirse1.setPosition(840,600);
  rendirse2.setPosition(840,10);
  tablas1.setPosition(925,600);
  tablas2.setPosition(925,10);
  textSize(25);
  textAlign(BASELINE);
  text(partida.getJug1(),650,625); //Muestra el nombre de la persona jugadora 1
  text(partida.getJug2(),650,30); //Muestra el nombre de la persona jugadora 2
  text(("Turno de " + partida.turnoDe()),650,290);
  text("Turno número " + partida.turnNum(),650,260);
  text(("Movimiento anterior: " + movAnterior),650,320);
  fill(255,0,0);
  if(partida.getTurn() && partida.jaqueMate(true)) text(("Rey blanco en jaque mate (0-1)"),650,350);
  else if(partida.getTurn() && partida.jaque(true)) text(("Rey blanco en jaque"),650,350);
  else if(!partida.getTurn() && partida.jaqueMate(false)) text(("Rey negro en jaque mate (1-0)"),650,350);
  else if(!partida.getTurn() && partida.jaque(false)) text(("Rey negro en jaque"),650,350);
  int fotoX = 650;
  int fotoY = 40;
  for(PImage img:partida.capturadasBlancas()) {
    img.resize(25,25);
    image(img,fotoX,fotoY);
    fotoX += 15;
  }
  fotoX = 650;
  fotoY = 575;
  for(PImage img:partida.capturadasNegras()) {
    img.resize(25,25);
    image(img,fotoX,fotoY);
    fotoX += 15;
  }
  
  //Dibuja el tablero y las piezas en él
  for (int i = 0; i<8; i++)
    for (int j = 0; j<8; j++) { 
      if ((i+j)%2 == 0) fill(238,238,210); //Color para las casillas claras
      else fill(58,104,141); //Color para las casillas oscuras
      rect(i*640/8, j*640/8, 640/8, 640/8); //Dibuja cada casilla
      
      //Dibuja la pieza en la casilla correspondiente
      if (partida.getTablero()[j][i] != null) { 
      partida.getTablero()[j][i].resize(640/8, 640/8);
      image(partida.getTablero()[j][i], i*640/8, j*640/8); 
    }
    
      // Si se ha hecho click en una pieza, resalta los movimientos válidos
      if (click && (piezaY < 8 && piezaY >= 0 && piezaX < 8 && piezaX >= 0)) {
         //System.out.println("desde " + piezaX +", " + piezaY + " hasta " + i + ", " + j + " es " + partida.movValido(partida.getTablero()[piezaY][piezaX],i,j));
         if(partida.movValido(piezaX,piezaY,i,j)) {
              fill(255,216,0,100);
              rect(i*640/8, j*640/8, 640/8, 640/8);
         }
      }
    }
}

//Lógica para mover las piezas en el tablero
void mousePressed() {
  if(!iniciado) return;
  if(jug1Ren || jug2Ren || (jug1Tablas == true && jug2Tablas == true)) return;
  
  //Si ya se ha seleccionado una pieza (click == true) y se clickea en otra casilla
  if (click && (piezaY < 8 && piezaY >= 0 && piezaX < 8 && piezaX >= 0)) {
    int nuevoX = round(mouseX / (640/8)-0.5); //Calcula la nueva posición X basada en el clic
    int nuevoY = round(mouseY / (640/8)-0.5); // Calcula la nueva posición Y basada en el clic
    
    //Si el movimiento es válido, mueve la pieza y actualiza el estado del juego
    if(partida.movValido(piezaX,piezaY,nuevoX,nuevoY)){
      movAnterior = partida.mover(piezaX,piezaY,nuevoX,nuevoY); //Realiza el movimiento
      jug1Tablas = false; //Resetea el estado de petición de tablas
      jug2Tablas = false; //Resetea el estado de petición de tablas
      
      //Si el movimiento implica la promoción de un peón
      if(partida.canPromote(nuevoX,nuevoY)) {
        peonX = nuevoX; //Guarda la posición X del peón
        peonY = nuevoY; //Guarda la posición Y del peón
        promotion = true; //Establece el estado de promoción a verdadero
      }
      click = false;
    } else {
      //Si el movimiento no es válido, actualiza la posición seleccionada
      piezaX = round(mouseX / (640/8)-0.5);
      piezaY = round(mouseY / (640/8)-0.5);
      click = true;
    }
  } else {
    //Si no se ha seleccionado una pieza, establece la posición seleccionada basada en el clic
    piezaY = round(mouseY / (640/8)-0.5);
    piezaX = round(mouseX / (640/8)-0.5);
    click = true;
  }
}

//Permite al jugador seleccionar una pieza para la promoción del peón
void keyPressed() {
  if((key == 's' || key == 'S') && iniciado) {
    selectOutput("Seleccione la ruta donde desea guardar", "saveGame");
  }
  if((key == 'l' || key == 'L') && iniciado) {
    File selec = new File(sketchPath("")+"/*.json");
    selectInput("Seleccione el juego que desea cargar", "loadGame",selec);
  }
  
  if(!promotion) return;
  
  //Dependiendo de la tecla presionada, realiza la promoción a la pieza correspondiente
  if (key == 'q' || key == 'Q') {
    partida.promote(peonX,peonY,Type.Queen); //Promueve a reina
    movAnterior += "=Q"; //Actualiza el registro del movimiento
    promotion = false; //Resetea el estado de promoción
  } else if (key == 'r' || key == 'R') {
    partida.promote(peonX,peonY,Type.Rook); //Promueve a torre
    movAnterior += "=R";
    promotion = false;
  } else if (key == 'b' || key == 'B') {
    partida.promote(peonX,peonY,Type.Bishop); //Promueve a alfil
    movAnterior += "=B";
    promotion = false;
  } else if (key == 'k' || key == 'K') {
    partida.promote(peonX,peonY,Type.Knight); //Promueve a caballo
    movAnterior += "=K";
    promotion = false;
  }
}

//Configura los nombres de las personas jugadoras
public void setNombres() {
  background(32,86,151);
  fill(255,255,255);
  textSize(25);
  textAlign(CENTER,BOTTOM);
  text("Ingrese el nombre del jugador 1 (piezas blancas): ",width/2,175);
  text("Ingrese el nombre del jugador 2 (piezas negras): ",width/2,375);
  
}

//Inicia el juego
public void Iniciar(int theValue) {
  if(presionado == 0) {
    presionado = 1;
    return;
  }
  String jug1 = cp5.get(Textfield.class,"blancas").getText();
  String jug2 = cp5.get(Textfield.class,"negras").getText();
  if(!jug1.isBlank()) {
    partida.setJug1(jug1);
  }
  if(!jug2.isBlank()) {
    partida.setJug2(jug2);
  }
  iniciado = true;
}

//Rendición de la persona jugadora 1
public void Rendirse1(int theValue) {
  if(presR1 == 0) {
    presR1 = 1;
    return;
  }
  if(jug1Ren || jug2Ren || (jug1Tablas == true && jug2Tablas == true)) return;
  if((partida.getTurn() && partida.jaqueMate(true)) || (!partida.getTurn() && partida.jaqueMate(false))) return;
  jug1Ren = true;
}

//Rendición de la persona jugadora 2
public void Rendirse2(int theValue) {
  if(presR2 == 0) {
    presR2 = 1;
    return;
  }
  if(jug1Ren || jug2Ren || (jug1Tablas == true && jug2Tablas == true)) return;
  if((partida.getTurn() && partida.jaqueMate(true)) || (!partida.getTurn() && partida.jaqueMate(false))) return;
  jug2Ren = true;
}

//Jugador 1 pide tablas
public void Tablas1(int theValue) {
  if(presT1 == 0) {
    presT1 = 1;
    return;
  }
  if(jug1Ren || jug2Ren || (jug1Tablas == true && jug2Tablas == true)) return;
  if((partida.getTurn() && partida.jaqueMate(true)) || (!partida.getTurn() && partida.jaqueMate(false))) return;
  jug1Tablas = true;
}

//Jugador 2 pide tablas
public void Tablas2(int theValue) {
  if(presT2 == 0) {
    presT2 = 1;
    return;
  }
  if(jug1Ren || jug2Ren || (jug1Tablas == true && jug2Tablas == true)) return;
  if((partida.getTurn() && partida.jaqueMate(true)) || (!partida.getTurn() && partida.jaqueMate(false))) return;
  jug2Tablas = true;
}

public void saveGame(File path) {
  if(path == null) return;
  partida.saveGame(path);
}

public void loadGame(File path) {
  if(path == null) return;
  partida.loadGame(path);
}
