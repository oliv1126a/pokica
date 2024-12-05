class Point {
  float x;
  float y;

  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

int cols;
int rows;

ArrayList<Point> points = new ArrayList<Point>();

float tollTavolsag = 200; // A kiindulási távolság az A ponttól
float tollSebesseg; // Sebesség változó, amelyet minden egyes frame-ben véletlenszerűen frissítünk
boolean emelkedik = true; // A mozgás iránya

Point kozeppont = new Point(0, 0); // A
Point toll = new Point(0, 0); // B
Point konyokBal = new Point(0, 0); // C
Point konyokJobb = new Point(0, 0); // D

float szog = 0; // A pók forgatási szöge

void setup() {
  size(800, 600); // Vászon mérete
  background(255); // Fehér háttér
  cols = width;
  rows = height;

  // A és B pontok kezdeti beállítása
  kozeppont = new Point(width / 2, height / 2);
  toll = new Point(kozeppont.x, kozeppont.y - tollTavolsag);

  // C és D pontok kiszámítása
  frissitKonyokok();

  // Kezdeti sebesség - egyszer véletlenszerűen beállítva
  tollSebesseg = random(1, 5); // Véletlenszerű sebesség 1 és 5 között
}

void draw() {
  background(255); // Háttér újrarajzolása minden frame-ben

  // A koordinátarendszer eltolása a középpontba
  translate(kozeppont.x, kozeppont.y);

  // Pontok hozzáadása és kirajzolása
  for (Point p : points) {
    stroke(120);
    strokeWeight(5);
    point(p.x, p.y);
    println(p.x);
    println(p.y);
  }

  
  

  // A pók forgatása
  rotate(szog);

  // Rózsaszín kör középen
  fill(255, 105, 180);
  noStroke();
  ellipse(0, 0, 150, 150);

  // Narancssárga kör (toll - B pont)
  fill(255, 165, 0);
  Point temp = new Point(toll.x, toll.y);
  points.add(temp);
  ellipse(toll.x - kozeppont.x, toll.y - kozeppont.y, 20, 20);

  // Zöld kör a rózsaszín kör szélén
  float greenCircleX = 0;
  float greenCircleY = -75;
  fill(0, 255, 0);
  ellipse(greenCircleX, greenCircleY, 50, 50);

  // Téglalapok kirajzolása
  fill(0, 0, 255);
  drawRectangle(0, 0, konyokJobb.x - kozeppont.x, konyokJobb.y - kozeppont.y, 10);  // A-D
  drawRectangle(0, 0, konyokBal.x - kozeppont.x, konyokBal.y - kozeppont.y, 10);  // A-C
  drawRectangle(konyokBal.x - kozeppont.x, konyokBal.y - kozeppont.y, toll.x - kozeppont.x, toll.y - kozeppont.y, 10); // C-B
  drawRectangle(konyokJobb.x - kozeppont.x, konyokJobb.y - kozeppont.y, toll.x - kozeppont.x, toll.y - kozeppont.y, 10); // D-B

  // Mozgás frissítése
  mozgasTollPont();
  frissitKonyokok();

  // Átlátszó vonalak (rajzold meg utoljára, hogy legalul legyenek)
  stroke(200, 200, 200, 100);  // Halvány szürke szín
  strokeWeight(1);
  line(0, 0, toll.x - kozeppont.x, toll.y - kozeppont.y); // A-B
  line(konyokBal.x - kozeppont.x, konyokBal.y - kozeppont.y, konyokJobb.x - kozeppont.x, konyokJobb.y - kozeppont.y); // C-D

  // A pók forgatásának frissítése
  szog += random(0.005, 0.05);
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
