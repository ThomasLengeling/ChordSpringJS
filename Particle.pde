class Particle {
  PVector pos;
  PVector velocity;
  PVector acceleration;
  float  mass;

  float damping;
  
  boolean free;

  Particle(float x, float y) {
    this.pos = new PVector(x, y);
    this.velocity = new PVector();
    this.acceleration = new PVector(0, 0.0);
    this.free = true;
    this.damping = 0.93;
    this.mass = 10;
  }

  void update() {
    if(free){
      velocity.add(acceleration);
      velocity.mult(damping);
      pos.add(velocity);
      acceleration.mult(0);
    }
  }
  
  void makeFree(){
    free = true;
  }
  
  void makeLocked(){
    free = false;
  }

  void applyForce(PVector force) {
    PVector f = force.get();
    f.div(mass);
    acceleration.add(f);
  }
  
  void drawParticle(){
    stroke(0);
    fill(100);
    ellipse(pos.x, pos.y, 10, 10);
  }
  
  float getX(){
    return pos.x;
  }
  
  float getY(){
    return pos.y;
  }
  
  PVector position(){
    return pos;
  }
  
  void setPos(float x, float y){
    pos.set(x, y);
  }
  
}

