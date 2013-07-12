Physics physics;
Chords chords;

void setup(){
  size(600, 600);
  smooth();
  
  physics = new Physics();
  chords = new Chords(physics);
}

void draw(){
  background(255);
  
  physics.update();
  physics.drawPhysics();
  
  chords.display();
  chords.update();
  
  if(chords.moveMouseEnd){
   chords.setEndPos(mouseX, mouseY); 
  }
}


void keyPressed(){
 if(key == 'a'){
  
 }
 if(key == 's'){
  chords.moveEnd();
 } 
 
  
}
