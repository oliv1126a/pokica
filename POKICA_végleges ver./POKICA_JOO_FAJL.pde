PImage photo; // a test
PImage fejphoto; // a fej
PImage konyokBalphoto; // Az alsó bal könyök képe
PImage konyokJobbphoto; // az alsó jobb könyök képe
PImage pokica_13photo; // a konyokBal és a toll közötti kar képe 
PImage pokica_14photo; // a konyokJobb és a toll közötti kar képe
PImage papirBackgroundphoto; // a hatter papir
PImage ceruzaphoto; // a ceruza képe

class Point {
  float x;
  float y;

  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void RajzolKor(int r, int g, int b, int size) {
    fill(r, g, b);
    noStroke();    
    ellipse(x, y, size, size);
  }
}

int cols;
int rows;
float szog = 0;
float tollTavolsag = 200; // A kiindulási távolság az A ponttól, milyen messzirol kezdi el rajzolni
float tollSebesseg; // Sebesség változó, amelyet minden egyes frame-ben véletlenszerűen frissítünk
boolean emelkedik = true; // A mozgás iránya
Point kozeppont = new Point(0, 0); // A
Point toll = new Point(0, 0); // B
Point konyokBal = new Point(0, 0); // C
Point konyokJobb = new Point(0, 0); // D
Point fej = new Point(0, 0); // E
ArrayList<Point> points = new ArrayList<Point>();

void setup() {
  size(800, 600); // Vászon mérete
  papirBackgroundphoto = loadImage("papirBackground.png"); // Háttérkép betöltése
  photo = loadImage("pokica_test_3.png"); // a test képe
  fejphoto = loadImage("pokica_fej_3.png");  // a fej képe
  konyokBalphoto = loadImage("konyokBal.png"); // a bal konyok képe
  konyokJobbphoto = loadImage("konyokJobb.png"); // a jobb konyok képe
  pokica_13photo = loadImage("pokica_13.png"); // a konyokBal és a toll közötti kar képe
  pokica_14photo = loadImage("pokica_14.png"); // a konyokJobb és a toll közötti kar képe
  ceruzaphoto = loadImage("ceruza.png"); // a ceruza képe
  
  //background(255); // Fehér háttér
  cols = width;
  rows = height;

  // A és B pontok kezdeti beállítása
  kozeppont = new Point(0, 0);
  fej = new Point(0, -75); 
  toll = new Point(0, tollTavolsag);

  // C és D pontok kiszámítása
  frissitKonyokok();

  // Kezdeti sebesség - egyszer véletlenszerűen beállítva
  tollSebesseg = 3; // Véletlenszerű sebesség 1 és 5 között, 3 az eredeti érték
  //A toll sebessége, milyen gyorsan megy milyen suru lesz a virag
}

void rajzolTeglalap(Point start, Point end, float width) {
  pushMatrix();
  translate((start.x + end.x) / 2, (start.y + end.y) / 2); // A téglalap középpontja
  float angle = atan2(end.y - start.y, end.x - start.x);  // A vonal szöge
  rotate(angle);                                         // Forgatás a szög alapján
  float length = dist(start.x, start.y, end.x, end.y);   // A vonal hossza
  fill(0, 0, 255);                                       // Szín
  noStroke();
  rect(-length / 2, -width / 2, length, width);          // Téglalap rajzolása
  popMatrix();
}

void draw() {
  image(papirBackgroundphoto, 0, 0, width, height); // Háttérkép kirajzolása a teljes vászon méretére
  
  //background(255);
  
  //Pontok kirajzolása
  for (int i = 0; i < points.size() - 1; i++) {
    Point p0 = points.get(i);
    Point p1 = points.get(i + 1);
    stroke(120);
    strokeWeight(2);
    line(p0.x, p0.y, p1.x, p1.y);
  }
  
  translate(width / 2, height / 2);
  rotate(szog);
 
  //toll.RajzolKor(255, 165, 0, 20); // EZ A NARANCSSÁRGA KÖR
  points.add(new Point(tollTavolsag * cos(szog + 3 * PI / 2) + width / 2,
                       tollTavolsag * sin(szog + 3 * PI / 2) + height / 2));
                       
   float tollWidth = 30;  // Kép szélessége
   float tollHeight = 60; // Kép magassága
   image(ceruzaphoto, toll.x - tollWidth / 2, toll.y - tollHeight / 2 - 13, tollWidth, tollHeight); // Kép rajzolása
                      
                       // Kép kirajzolása a konyokJobb és toll közötti téglalap helyére
   float middleX2 = (toll.x + konyokJobb.x) / 2;  // Kiszámoljuk a középpont koordinátáit
   float middleY2 = (toll.y + konyokJobb.y) / 2;
      pushMatrix();  // Elmentjük az aktuális transformációt
   translate(middleX2, middleY2);  // Elmozdítjuk a koordináta-rendszert a középpontba
   rotate(-PI / 8);  // Forgatás 22,5 fokkal jobbra

   // A képet most a középpont körül forgatva rajzoljuk
   image(pokica_14photo, -10, -40, 30, 95);  // Kép kirajzolása a forgatás után

   popMatrix();  // Visszaállítjuk az eredeti transformációt
                       
                       // Kép kirajzolása a konyokBal és toll közötti téglalap helyére
  float middleX = (toll.x + konyokBal.x) / 2;  // Kiszámoljuk a középpont koordinátáit
  float middleY = (toll.y + konyokBal.y) / 2;
     pushMatrix();  // Elmentjük az aktuális transformációt
   translate(middleX, middleY);  // Elmozdítjuk a koordináta-rendszert a középpontba
   rotate(PI / 8);  // Forgatás 22,5 fokkal jobbra

   // A képet most a középpont körül forgatva rajzoljuk
   image(pokica_13photo, -22, -40, 30, 95);  // Kép kirajzolása a forgatás után

   popMatrix();  // Visszaállítjuk az eredeti transformációt
                       
  // Kép megjelenítése a konyokBal helyén
     pushMatrix();
   translate(konyokBal.x + 10, konyokBal.y + 30); // Mozgatás 20 pixellel jobbra és 30 pixellel lefelé
   rotate(-PI / 4); // Forgatás 45 fokkal balra
   float scaledWidth = 30;  
   float scaledHeight = 70; 
   image(konyokBalphoto, -scaledWidth / 2, -scaledHeight / 2, scaledWidth, scaledHeight); // Kép megjelenítése
   popMatrix();
   
  // Kép megjelenítése a konyokJobb helyén
      pushMatrix();
   translate(konyokJobb.x, konyokJobb.y); // A konyokJobb pozíciója
   rotate(radians(45));                // Kép középpontjának használata
   image(konyokJobbphoto, 0, 0, 30, 70); // Kép kirajzolása (50x50 méretben)
   popMatrix();

  //rajzolTeglalap(kozeppont, konyokBal, 10);
  //rajzolTeglalap(toll, konyokBal, 10);
  //rajzolTeglalap(kozeppont, konyokJobb, 10);
  //rajzolTeglalap(toll, konyokJobb, 10);

  image(photo, kozeppont.x - 150, kozeppont.y - 150, 300, 300); // Kép megjelenítése a kör helyén
  image(fejphoto, kozeppont.x - 150, kozeppont.y - 150, 300, 300);
  
  szog += 0.01; // mennyire gyorsan forogjon, 0.01 az eredeti ertek
  mozgasTollPont();
  frissitKonyokok();
}

// A toll (B pont) mozgatása fel-le
void mozgasTollPont() {
  if (emelkedik) {
    tollTavolsag -= tollSebesseg;
    if (tollTavolsag <= 100) {
      emelkedik = false;
    }
  } else {
    tollTavolsag += tollSebesseg;
    if (tollTavolsag >= 200) {
      emelkedik = true;
    }
  }
  toll.y = kozeppont.y - tollTavolsag;
}

// Könyökpontok (C és D) pozíciójának frissítése
void frissitKonyokok() {
  float lineMidX = (kozeppont.x + toll.x) / 2;
  float lineMidY = (kozeppont.y + toll.y) / 2;
  float offsetX = 50; // Merőleges eltolás X irányban
  float offsetY = 0;  // Merőleges vonal Y eltolása (itt nincs eltolás)

  konyokBal = new Point(lineMidX - offsetX, lineMidY - offsetY);
  konyokJobb = new Point(lineMidX + offsetX, lineMidY - offsetY);
}
