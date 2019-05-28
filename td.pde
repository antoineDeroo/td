int tempsAttendu,intervalleLancers,ancienneDate,nbDeCasesParCoteDeTour;
float largTer,hautTer,vMin,vMax,minXIni,distanceMin,coteCase,coteTour;
ArrayList<Monstre> monstres;
Case[][] grille;
Case dest;
int valeurCurseur,nbCasesX,nbCasesY,posXCurseur,posYCurseur;
int i=-1;

void setup(){
  
  textSize(30);
  background(255);
  size(900, 900); 
  smooth();
  frameRate(50);
  noStroke();
  largTer=900;
  hautTer=900;
  
  nbDeCasesParCoteDeTour = 8;
  distanceMin= 5;
  
  valeurCurseur = 1;
  nbCasesX = 15*nbDeCasesParCoteDeTour;
  nbCasesY = 15*nbDeCasesParCoteDeTour;
  coteCase = largTer/nbCasesX;
  coteTour = coteCase*nbDeCasesParCoteDeTour;

  grille = new Case[nbCasesX][nbCasesY];
  for(int i=0;i<nbCasesX;i++){
    for(int j=0;j<nbCasesY;j++){
      grille[i][j]=new Case(i,j,nbCasesX-1,0);
    }
  }
  
  monstres = new ArrayList<Monstre>();
  dest = grille[nbCasesY-1][0];
  monstres.add(new Monstre(0,hautTer-4,0.1,dest,20,40));
  
  //Monstre(float x,float y,float vitesse,Case dest,float l,float h){
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
  posXCurseur = int((mouseX-coteTour/4)/(coteTour/2));
  posYCurseur = int((mouseY-coteTour/4)/(coteTour/2));
  for(Monstre m:monstres){
    m.update(dt);
  }
}
void render(){
  rect(posXCurseur*coteTour/2,posYCurseur*coteTour/2,coteTour,coteTour);
  for(Monstre m:monstres){
    m.render();
  }
  for(int i=0;i<nbCasesX;i++){
    for(int j=0;j<nbCasesY;j++){
      if(grille[i][j].tourPosee){
        rect(i*coteTour/2,j*coteTour/2,coteTour,coteTour);
      }
    }
  }
}

void trouverPlusCourtChemin(Monstre m){
  ArrayList<Case> resteAVisiter = new ArrayList<Case>();
  ArrayList<Case> dejaVus = new ArrayList<Case>();
  resteAVisiter.add(m.getCase());
  while(resteAVisiter.size()!=0 && !resteAVisiter.contains(dest)){
    i++;
    println(i+ "ème itération");
    //on trouve le meilleur heuristique
    float min=9999;
    Case elu = new Case();
    for(Case p:resteAVisiter){
      if(p.coutT()<min){
        min=p.coutT();
        elu=p;
      }
    }
    ///////////////////////////////
    dejaVus.add(elu);
    resteAVisiter.remove(elu);
    println("elu.x="+elu.x);
    println("elu.y="+elu.y);
    if(elu.x>0){
      if(elu.y>0){
        if(!grille[elu.x-1][elu.y-1].occupee && !dejaVus.contains(grille[elu.x-1][elu.y-1])){  //haut à gauche
          if(grille[elu.x-1][elu.y-1].coutDepuisDep > elu.coutDepuisDep + sqrt(2)*coteCase){
            grille[elu.x-1][elu.y-1].coutDepuisDep = elu.coutDepuisDep + sqrt(2)*coteCase;
            resteAVisiter.add(grille[elu.x-1][elu.y-1]);
            grille[elu.x-1][elu.y-1].pred=elu;
            println("hg");
          }
        }
        if(!grille[elu.x][elu.y-1].occupee && !dejaVus.contains(grille[elu.x][elu.y-1])){ //haut
          if(grille[elu.x][elu.y-1].coutDepuisDep > elu.coutDepuisDep + coteCase){
            grille[elu.x][elu.y-1].coutDepuisDep = elu.coutDepuisDep + coteCase;
            resteAVisiter.add(grille[elu.x][elu.y-1]);
            grille[elu.x][elu.y-1].pred=elu;
            println("h");
          }
        }
        if(!grille[elu.x-1][elu.y].occupee && !dejaVus.contains(grille[elu.x-1][elu.y])){ //gauche
          if(grille[elu.x-1][elu.y].coutDepuisDep > elu.coutDepuisDep + coteCase){
            grille[elu.x-1][elu.y].coutDepuisDep = elu.coutDepuisDep + coteCase;
            resteAVisiter.add(grille[elu.x-1][elu.y]);
            grille[elu.x-1][elu.y].pred=elu;
            println("g");
          }
        }
      }
      if(elu.y<nbCasesY-1){
        if(!grille[elu.x][elu.y+1].occupee && !dejaVus.contains(grille[elu.x][elu.y+1])){ //bas
          if(grille[elu.x][elu.y+1].coutDepuisDep > elu.coutDepuisDep + coteCase){
            grille[elu.x][elu.y+1].coutDepuisDep = elu.coutDepuisDep + coteCase;
            resteAVisiter.add(grille[elu.x][elu.y+1]);
            grille[elu.x][elu.y+1].pred=elu;
            println("b");
          }
        }
        if(!grille[elu.x-1][elu.y+1].occupee && !dejaVus.contains(grille[elu.x-1][elu.y+1])){  //bas à gauche
          if(grille[elu.x-1][elu.y+1].coutDepuisDep > elu.coutDepuisDep + sqrt(2)*coteCase){
            grille[elu.x-1][elu.y+1].coutDepuisDep = elu.coutDepuisDep + sqrt(2)*coteCase;
            resteAVisiter.add(grille[elu.x-1][elu.y+1]);
            grille[elu.x-1][elu.y+1].pred=elu;
            println("bg");
          }
        }
      }
    }
    if(elu.x<nbCasesX-1){
      if(elu.y>0){
        //println("a");
        if(!grille[elu.x+1][elu.y-1].occupee && !dejaVus.contains(grille[elu.x+1][elu.y-1])){  //haut à droite
          //println("b");
          //println("grille[elu.x+1][elu.y-1].coutDepuisDep=" + grille[elu.x+1][elu.y-1].coutDepuisDep);
          //println("elu.coutDepuisDep + sqrt(2)*coteCase=" + (elu.coutDepuisDep + sqrt(2)*coteCase));
          if(grille[elu.x+1][elu.y-1].coutDepuisDep > elu.coutDepuisDep + sqrt(2)*coteCase){
            //println("c");
            grille[elu.x+1][elu.y-1].coutDepuisDep = elu.coutDepuisDep + sqrt(2)*coteCase;
            resteAVisiter.add(grille[elu.x+1][elu.y-1]);
            grille[elu.x+1][elu.y-1].pred=elu;
            println("hd");
            if(grille[elu.x+1][elu.y-1].equals(dest)){
              println("on a trouve dest!");
              println("le pred de dest="+dest.pred);
            }
          }
        }
        if(!grille[elu.x+1][elu.y].occupee && !dejaVus.contains(grille[elu.x+1][elu.y])){ //droite
          if(grille[elu.x+1][elu.y].coutDepuisDep > elu.coutDepuisDep + coteCase){
            grille[elu.x+1][elu.y].coutDepuisDep = elu.coutDepuisDep + coteCase;
            resteAVisiter.add(grille[elu.x+1][elu.y]);
            grille[elu.x+1][elu.y].pred=elu;
            println("d");
          }
        }
      }
      if(elu.y<nbCasesY-1){
        if(!grille[elu.x+1][elu.y+1].occupee && !dejaVus.contains(grille[elu.x+1][elu.y+1])){  //bas à droite
          if(grille[elu.x+1][elu.y+1].coutDepuisDep > elu.coutDepuisDep + sqrt(2)*coteCase){
            grille[elu.x+1][elu.y+1].coutDepuisDep = elu.coutDepuisDep + sqrt(2)*coteCase;
            resteAVisiter.add(grille[elu.x+1][elu.y+1]);
            grille[elu.x+1][elu.y+1].pred=elu;
            println("bd");
          }
        }
      }
    }
    
  }

  println("on est sorti de la boucle! resteAVisiter.size()="+resteAVisiter.size()+" et resteAVisiter.contains(dest)="+resteAVisiter.contains(dest));
  ArrayList<Case> destinations = new ArrayList<Case>();
  Case c = new Case(dest);
  println("c="+c);
  println("m="+m);
  while(!c.equals(m.getCase())){
    println("c="+c);
    println("c.pred="+c.pred);
    destinations.add(c);
    c=c.pred;
  }
  m.dest = destinations;
}


class Monstre{
  float x,y,vitesse,l,h;
  ArrayList<Case> dest;
  Monstre(float x,float y,float vitesse,Case dest,float l,float h){
    this.x=x;
    this.y=y;
    this.vitesse=vitesse;
    this.dest = new ArrayList<Case>();
    this.dest.add(dest);
    this.l=l;
    this.h=h;
  }
  void update(int dt){
    float dX = dest.get(0).x-x/coteCase;
    float dY = dest.get(0).y-y/coteCase;
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
  Case getCase(){
    return new Case(int(x/coteCase),int(y/coteCase),-1,-1);
  }
  String toString(){
    return x+" "+y;
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
    heuristique=sqrt(pow(x-xDest,2)+pow(y-yDest,2))*coteCase;
    coutDepuisDep=999999;
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
  for(Monstre m:monstres){
    trouverPlusCourtChemin(m);
  }
}
