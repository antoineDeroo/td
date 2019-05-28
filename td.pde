int tempsAttendu,intervalleLancers,ancienneDate;
float largTer,hautTer,vMin,vMax,minXIni,distanceMin,coteCase;
ArrayList<Monstre> monstres;
Case[][] grille;
Point dest;
int valeurCurseur,nbCasesX,nbCasesY,posXCurseur,posYCurseur;

void setup(){
  
  textSize(30);
  background(255);
  size(900, 900); 
  smooth();
  frameRate(50);
  noStroke();
  largTer=900;
  hautTer=900;
  
  distanceMin= 5;
  monstres = new ArrayList<Monstre>();
  dest = new Point(largTer,hautTer);
  monstres.add(new Monstre(0,0,1,dest,20,40));
  valeurCurseur = 1;
  nbCasesX = 15;
  nbCasesY = 15;
  coteCase = largTer/nbCasesX;
  grille = new Case[nbCasesX*2][nbCasesY*2];
  for(int i=0;i<nbCasesX*2;i++){
    for(int j=0;j<nbCasesY*2;j++){
      grille[i][j]=new Case();
    }
  }
}

void draw(){
  clear();
  int date = millis();
  int dt = date-ancienneDate;
  ancienneDate=date;
  
  update(dt);
  render();
}

void update(int dt){
  posXCurseur = int((mouseX-(coteCase/4))/(coteCase/2));
  posYCurseur = int((mouseY-(coteCase/4))/(coteCase/2));
  for(Monstre m:monstres){
    m.update(dt);
  }
}
void render(){
  rect(posXCurseur*coteCase/2,posYCurseur*coteCase/2,coteCase,coteCase);
  for(Monstre m:monstres){
    m.render();
  }
  for(int i=0;i<nbCasesX*2;i++){
    for(int j=0;j<nbCasesY*2;j++){
      if(grille[i][j].tourPosee){
        rect(i*coteCase/2,j*coteCase/2,coteCase,coteCase);
      }
    }
  }
}

void trouverPlusCourtChemin(Monstre m){
  ArrayList<Point> casesATraiter = new ArrayList<Point>();
  casesATraiter.add(new Point(m.x/coteCase*2,m.y/coteCase*2));
  while(casesATraiter.size()!=0){
    //on trouve le meilleur heuristique
    float min=-999;
    int indPointATraiter = 0;
    for(int i=0;i<casesATraiter.size();i++){
      Point p = casesATraiter.get(i);
      float distance = sqrt(pow(p.x-m.dest.x,2)+pow(p.y-m.dest.y,2));
      if(distance < min){
        min = distance;
        indPointATraiter=i;
      }  
    }
    
  }
}


class Monstre{
  float x,y,vitesse,l,h;
  ArrayList<Point> dest;
  Monstre(float x,float y,float vitesse,Point dest,float l,float h){
    this.x=x;
    this.y=y;
    this.vitesse=vitesse;
    this.dest = new ArrayList<Point>();
    this.dest.add(dest);
    this.l=l;
    this.h=h;
  }
  void update(int dt){
    float dX = dest.x-x;
    float dY = dest.y-y;
    float distance = sqrt(pow(dX,2)+pow(dY,2));
    if(distance<=distanceMin){
      println("arrivey!");
    }
    else{
      float cosinus = dX/distance;
      float sinus = dY/distance;
      x=x+vitesse*dt*cosinus;
      y=y+vitesse*dt*sinus;
    }  
  }
  void render(){
    ellipse(x,y,l,h);
  }
    
}

class Point{
  float x,y;
  Point(float x,float y){
    this.x=x;
    this.y=y;
  }   
}

class Case{
  int x,y;
  float heuristique,coutDepuisDep;
  boolean occupee,tourPosee;
  Case pred;
  Case(int x,int y,int xDest,int yDest){
    this.x=x;
    this.y=y;
    heuristique=sqrt(pow(x-xDest,2)+pow(y-yDest,2));
    coutDepuisDep=999;
    occupee=false;
    pred=null;
  }
  Case(Case c){
    x=c.x;
    y=c.y;
    pred=c.pred;
    heuristique=c.heuristique;
    coutDepuisDep=c.coutDepuisDep;
    occupee=c.occupee;
  }
  Case(){}
  String toString(){
    return x+" "+y;
  }
  @Override
  boolean equals(Object c){
    return ((Case)c).x==x && ((Case)c).y==y;
  }
  float coutT(){
    return heuristique+coutDepuisDep;
  }
  
}

void mouseClicked(){
  grille[posXCurseur][posYCurseur].occupee=true;
  grille[posXCurseur][posYCurseur].tourPosee=true;
  grille[posXCurseur+1][posYCurseur].occupee=true;
  grille[posXCurseur][posYCurseur+1].occupee=true;
  grille[posXCurseur+1][posYCurseur+1].occupee=true;
}
