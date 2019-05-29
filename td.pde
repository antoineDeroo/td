int tempsAttendu,intervalleLancers,ancienneDate,nbDeCasesParCoteDeTour,nbToursX,nbToursY;
float largTer,hautTer,vMin,vMax,minXIni,distanceMin,coteCase,coteTour;
ArrayList<Monstre> monstres;
Case[][] grille;
Case dest;
int valeurCurseur,nbCasesX,nbCasesY,posXCurseur,posYCurseur;
int i=-1;

void setup(){
  
  textSize(30);
  background(255);
  size(600, 600); 
  smooth();
  frameRate(60);
  stroke(1);
  largTer=600;
  hautTer=600;
  
  nbDeCasesParCoteDeTour = 4;
  distanceMin= 1;
  
  valeurCurseur = 1;
  nbToursX = 8;
  nbToursY = 8;
  nbCasesX =nbToursX*nbDeCasesParCoteDeTour;
  nbCasesY = nbToursY*nbDeCasesParCoteDeTour;
  coteCase = largTer/nbCasesX;
  coteTour = coteCase*nbDeCasesParCoteDeTour;

  grille = new Case[nbCasesX][nbCasesY];
  for(int i=0;i<nbCasesX;i++){
    for(int j=0;j<nbCasesY;j++){
      grille[i][j]=new Case(i,j,nbCasesX-1,0);
    }
  }
  
  monstres = new ArrayList<Monstre>();
  dest = grille[nbCasesX-1][0];
  monstres.add(new Monstre(0,hautTer-4,0.05,20,40));
  
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
  //println(posXCurseur);
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
        rect(i*coteCase,j*coteCase,coteTour,coteTour);
      }
    }
  }
}

void trouverPlusCourtChemin(Monstre m){
  ArrayList<Case> resteAVisiter = new ArrayList<Case>();
  ArrayList<Case> dejaVus = new ArrayList<Case>();
  Case ori = grille[m.getCase().x][m.getCase().y];
  ori.coutDepuisDep=0;
  resteAVisiter.add(ori);
  //println("la case qu'on ajoute est "+ori);
  ori.dirPred="depa";
  dest.dirPred="arri";
  while(resteAVisiter.size()!=0 && !resteAVisiter.contains(dest)){
    i++;
    //println(i+ "ème itération");
    //on trouve le meilleur heuristique
    float min=99999;
    Case elu = new Case();
    //println(resteAVisiter);
    if(resteAVisiter.size()==1){
      elu = resteAVisiter.get(0);
    }
    else{
      for(Case c:resteAVisiter){
      //println("caca coutT="+c.coutT()+" et min="+min);
        if(c.coutT()<min){
          
          min=c.coutT();
          elu=c;
        }
      }
    }
    
    ///////////////////////////////
    //println("elu.x="+elu.x);
    //println("elu.y="+elu.y);
    dejaVus.add(elu);
    resteAVisiter.remove(elu);
    //println("elu.x="+elu.x);
    //println("elu.y="+elu.y);
    if(elu.x>0){
      if(elu.y>0){
        if(!grille[elu.x-1][elu.y-1].occupee && !dejaVus.contains(grille[elu.x-1][elu.y-1])){  //haut à gauche
          if(grille[elu.x-1][elu.y-1].coutDepuisDep > elu.coutDepuisDep + sqrt(2)*coteCase){
            grille[elu.x-1][elu.y-1].coutDepuisDep = elu.coutDepuisDep + sqrt(2)*coteCase;
            resteAVisiter.add(grille[elu.x-1][elu.y-1]);
            grille[elu.x-1][elu.y-1].pred=elu;
            //println("hg");
            grille[elu.x-1][elu.y-1].dirPred = "bd";
          }
        }
        if(!grille[elu.x][elu.y-1].occupee && !dejaVus.contains(grille[elu.x][elu.y-1])){ //haut
          if(grille[elu.x][elu.y-1].coutDepuisDep > elu.coutDepuisDep + coteCase){
            grille[elu.x][elu.y-1].coutDepuisDep = elu.coutDepuisDep + coteCase;
            resteAVisiter.add(grille[elu.x][elu.y-1]);
            grille[elu.x][elu.y-1].pred=elu;
            //println("h");
            grille[elu.x][elu.y-1].dirPred = "b";
          }
        }
        if(!grille[elu.x-1][elu.y].occupee && !dejaVus.contains(grille[elu.x-1][elu.y])){ //gauche
          if(grille[elu.x-1][elu.y].coutDepuisDep > elu.coutDepuisDep + coteCase){
            grille[elu.x-1][elu.y].coutDepuisDep = elu.coutDepuisDep + coteCase;
            resteAVisiter.add(grille[elu.x-1][elu.y]);
            grille[elu.x-1][elu.y].pred=elu;
            //println("g");
            grille[elu.x-1][elu.y].dirPred = "d";
          }
        }
      }
      if(elu.y<nbCasesY-1){
        if(!grille[elu.x][elu.y+1].occupee && !dejaVus.contains(grille[elu.x][elu.y+1])){ //bas
          if(grille[elu.x][elu.y+1].coutDepuisDep > elu.coutDepuisDep + coteCase){
            grille[elu.x][elu.y+1].coutDepuisDep = elu.coutDepuisDep + coteCase;
            resteAVisiter.add(grille[elu.x][elu.y+1]);
            grille[elu.x][elu.y+1].pred=elu;
            //println("b");
            grille[elu.x][elu.y+1].dirPred = "h";
          }
        }
        if(!grille[elu.x-1][elu.y+1].occupee && !dejaVus.contains(grille[elu.x-1][elu.y+1])){  //bas à gauche
          if(grille[elu.x-1][elu.y+1].coutDepuisDep > elu.coutDepuisDep + sqrt(2)*coteCase){
            grille[elu.x-1][elu.y+1].coutDepuisDep = elu.coutDepuisDep + sqrt(2)*coteCase;
            resteAVisiter.add(grille[elu.x-1][elu.y+1]);
            grille[elu.x-1][elu.y+1].pred=elu;
            //println("bg");
            grille[elu.x-1][elu.y+1].dirPred = "hd";
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
            //println("hd");
            if(grille[elu.x+1][elu.y-1].equals(dest)){
              //println("on a trouve dest!");
              //println("le pred de dest="+dest.pred);
            }
            grille[elu.x+1][elu.y-1].dirPred = "bg";
          }
        }
        if(!grille[elu.x+1][elu.y].occupee && !dejaVus.contains(grille[elu.x+1][elu.y])){ //droite
          if(grille[elu.x+1][elu.y].coutDepuisDep > elu.coutDepuisDep + coteCase){
            grille[elu.x+1][elu.y].coutDepuisDep = elu.coutDepuisDep + coteCase;
            resteAVisiter.add(grille[elu.x+1][elu.y]);
            grille[elu.x+1][elu.y].pred=elu;
            //println("d");
            grille[elu.x+1][elu.y].dirPred = "g";
          }
        }
      }
      if(elu.y<nbCasesY-1){
        if(!grille[elu.x+1][elu.y+1].occupee && !dejaVus.contains(grille[elu.x+1][elu.y+1])){  //bas à droite
          if(grille[elu.x+1][elu.y+1].coutDepuisDep > elu.coutDepuisDep + sqrt(2)*coteCase){
            grille[elu.x+1][elu.y+1].coutDepuisDep = elu.coutDepuisDep + sqrt(2)*coteCase;
            resteAVisiter.add(grille[elu.x+1][elu.y+1]);
            grille[elu.x+1][elu.y+1].pred=elu;
            //println("bd");
            grille[elu.x+1][elu.y+1].dirPred = "hg";
          }
        }
      }
    }
    
  }
  if(!resteAVisiter.contains(dest)){  //erreur fatale
    //rien
    println("hahahah");
  }
  else{
    for(int i=0;i<nbDeCasesParCoteDeTour;i++){
      for(int j=0;j<nbDeCasesParCoteDeTour;j++){
        grille[posXCurseur*2+i][posYCurseur*2+j].occupee=true;
      }
    }
    grille[posXCurseur*2][posYCurseur*2].tourPosee=true;
    
    //println("on est sorti de la boucle! resteAVisiter.size()="+resteAVisiter.size()+" et resteAVisiter.contains(dest)="+resteAVisiter.contains(dest));
    ArrayList<Case> destinations = new ArrayList<Case>();
    Case c = new Case(dest);
    
    
    //affichage de la grille
    /*for(int j=0;j<nbCasesY;j++){
      String s = "";
      for(int i=0;i<nbCasesX;i++){
        s+=String.format( "[%4s]",grille[i][j].dirPred  )+" ";
      }
      println(s);
    }
    String s = "";
    for(int i=0;i<nbCasesX;i++){
      s+="=======";
    }
    println(s);*/
    
    //creation de la suite des destinations
    while(!c.equals(m.getCase())){
      //println("c="+c);
      //println("c.pred="+c.pred);
      destinations.add(c);
      c=c.pred;
    }
    
    //copiage des destinations
    m.dests=new ArrayList<Case>();
    for(int i=destinations.size()-1;i>=0;i--){
      m.dests.add(destinations.get(i));
    }
    
    //reinit des cases
    for(int j=0;j<nbCasesY;j++){
      for(int i=0;i<nbCasesX;i++){
        grille[i][j].coutDepuisDep=99999999;
        grille[i][j].dirPred=null;
        grille[i][j].pred=null;
      }
    }
  }
}


class Monstre{
  float x,y,vitesse,l,h;
  ArrayList<Case> dests;
  Monstre(float x,float y,float vitesse,float l,float h){
    this.x=x;
    this.y=y;
    this.vitesse=vitesse;
    this.dests = new ArrayList<Case>();
    this.dests.add(dest);
    this.l=l;
    this.h=h;
    trouverPlusCourtChemin(this);
  }
  void update(int dt){
    //println("destinations="+dests);
    float dX = dests.get(0).x-x/coteCase;
    float dY = dests.get(0).y-y/coteCase;
    float distance = sqrt(pow(dX,2)+pow(dY,2));
    if(distance<=distanceMin){
      if(dests.size()==1){
        //println("arrivey!");
      }
      else{
        dests.remove(0);
      }
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
  String dirPred;
  Case(int x,int y,int xDest,int yDest){
    this.x=x;
    this.y=y;
    heuristique=sqrt(pow(x-xDest,2)+pow(y-yDest,2))*coteCase;
    coutDepuisDep=99999999;
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
  
  for(Monstre m:monstres){
    trouverPlusCourtChemin(m);
  }
}
