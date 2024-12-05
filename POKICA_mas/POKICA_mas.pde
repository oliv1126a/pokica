class Point {
  float x;
  float y;
}

int cols;
int rows;

ArrayList<Point> points;

float tollTavolsag = 200; // A kiindulási távolság az A ponttól
float tollSebesseg; // Sebesség változó, amelyet minden egyes frame-ben véletlenszerűen frissítünk
boolean emelkedik = true; // A mozgás iránya

Point kozeppont = new Point(); // A
Point toll = new Point(); // B
Point konyokBal = new Point(); // C
Point konyokJobb = new Point(); // D

float szog = 0; // A pók forgatási szöge
float translateSebessegX; // Véletlenszerű sebesség a vízszintes eltolásra
float translateSebessegY; // Véletlenszerű sebesség a függőleges eltolásra

void setup() {
  size(800, 600); // Vászon mérete
  background(255); // Fehér háttér
  cols = width;
  rows = height;
  
  ArrayList<PVector> points = new ArrayList<PVector>();
  
  // A és B pontok kezdeti beállítása
  kozeppont.x = width / 2;
  kozeppont.y = height / 2;
  toll.x = kozeppont.x;
  toll.y = kozeppont.y - tollTavolsag;

  // C és D pontok kiszámítása
  frissitKonyokok();
  
  // Kezdeti sebesség - egyszer véletlenszerűen beállítva
  tollSebesseg = random(1, 20); // Véletlenszerű sebesség 1 és 10 között
  
  // Véletlenszerű sebesség beállítása a toll mozgásához
  translateSebessegX = random(0.5, 3);  // Véletlenszerű vízszintes sebesség
  translateSebessegY = random(0.5, 3);  // Véletlenszerű függőleges sebesség
}

void draw() {
  background(255); // Háttér újrarajzolása minden frame-ben

  points.add(new PVector(toll.x - kozeppont.x, toll.y - kozeppont.y, 20, 20));
  
  stroke(0);
  strokeWeight(5);
  for (PVector p : points){
   point(p.x, p.y); 
  }

  //itt a points nev ArrayList-ben levő pontokat kell vissza rajzolni
  for(int i = 0 ; i < points.size(); i++){
    Point temp =  points.get(i);
    
    PVector temp = new PVector(20, 20);
    point(temp.x, temp.y);
    //tempnek a pontjait ki kell rajzolnim, x és y pontok, a stroke-os megoldás (?)
  }

  // A koordinátarendszer eltolása a középpontba
  translate(kozeppont.x, kozeppont.y); 

  // A pók forgatása
  rotate(szog); // Forgatás a középpont körül

  // Rózsaszín kör középen
  fill(255, 105, 180);
  noStroke();
  ellipse(0, 0, 150, 150);  // Középpontban rajzolt kör

  // Narancssárga kör (toll - B pont)
  fill(255, 165, 0);
  ellipse(toll.x - kozeppont.x, toll.y - kozeppont.y, 20, 20);  // Toll helyének kiszámítása
  Point p = new Point();
  p.x = toll.x;
  p.y = toll.y;
  points.add(p);

  // Zöld kör a rózsaszín kör szélén
  float greenCircleX = 0;
  float greenCircleY = -75;
  fill(0, 255, 0);
  noStroke();
  ellipse(greenCircleX, greenCircleY, 50, 50);

  // Téglalapok
  fill(0, 0, 255);
  drawRectangle(0, 0, konyokJobb.x - kozeppont.x, konyokJobb.y - kozeppont.y, 10);  // A-D
  drawRectangle(0, 0, konyokBal.x - kozeppont.x, konyokBal.y - kozeppont.y, 10);     // A-C
  drawRectangle(konyokBal.x - kozeppont.x, konyokBal.y - kozeppont.y, toll.x - kozeppont.x, toll.y - kozeppont.y, 10); // C-B
  drawRectangle(konyokJobb.x - kozeppont.x, konyokJobb.y - kozeppont.y, toll.x - kozeppont.x, toll.y - kozeppont.y, 10); // D-B

  // Mozgás frissítése
  mozgasTollPont();
  frissitKonyokok();

  // Átlátszó vonalak (rajzold meg utoljára, hogy legalul legyenek)
  stroke(255, 255, 255, 0);  // Fehér szín, teljesen átlátszó (alpha = 0)
  strokeWeight(5);
  line(0, 0, toll.x - kozeppont.x, toll.y - kozeppont.y); // A-B
  line(konyokBal.x - kozeppont.x, konyokBal.y - kozeppont.y, konyokJobb.x - kozeppont.x, konyokJobb.y - kozeppont.y); // C-D

  // A pók forgatásának frissítése
  szog += random(0.005, 0.05); // Kis mértékű növelés a forgás szögén, de véletlenszerű sebességgel
}

// Téglalap rajzolása két pont között adott szélességgel
void drawRectangle(float x1, float y1, float x2, float y2, float thickness) {
  float angle = atan2(y2 - y1, x2 - x1);
  float distance = dist(x1, y1, x2, y2);
  
  pushMatrix();
  translate(x1, y1);
  rotate(angle);
  rect(0, -thickness / 2, distance, thickness);
  popMatrix();
}

// A toll (B pont) mozgatása fel-le
void mozgasTollPont() {
  if (emelkedik) {
    tollTavolsag -= tollSebesseg;
    if (tollTavolsag <= 100) { // Minimális távolság
      emelkedik = false;
    }
  } else {
    tollTavolsag += tollSebesseg;
    if (tollTavolsag >= 200) { // Maximális távolság
      emelkedik = true;
    }
  }
  toll.y = kozeppont.y - tollTavolsag; // Toll új pozíciója
}

// Könyökpontok (C és D) pozíciójának frissítése
void frissitKonyokok() {
  float lineMidX = (kozeppont.x + toll.x) / 2;
  float lineMidY = (kozeppont.y + toll.y) / 2;

  float offsetX = 50; // Merőleges eltolás X irányban
  float offsetY = 0; // Merőleges vonal vízszintes

  konyokBal.x = lineMidX - offsetX;
  konyokBal.y = lineMidY - offsetY;
  konyokJobb.x = lineMidX + offsetX;
  konyokJobb.y = lineMidY + offsetY;
}
