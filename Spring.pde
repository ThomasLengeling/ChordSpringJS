class Spring {
  PVector anchor;

  float len;
  float k;

  Particle p1;
  Particle p2;

  Spring(Particle p1, Particle p2, float len) {
    this.p1 = p1;
    this.p2 = p2;
    this.len = len;
    k = 0.8;
  }

  void update() {
    PVector force = PVector.sub(p1.pos, p2.pos);
    float d  = force.mag();
    float strech  = d - len;
    force.normalize();
    force.mult(-1 * k * strech);
    p1.applyForce(force);
    force.mult(-1);
    p2.applyForce(force);
  }
  
  void setRestLength(float len){
   this.len = len; 
  }
  
  
  void drawSpring() {
    strokeWeight(2);
    stroke(0);
    line(p1.getX(), p1.getY(), p2.getX(), p2.getY());
  }

}

