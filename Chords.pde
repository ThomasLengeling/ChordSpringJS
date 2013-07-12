class Chords {
  Particle end;
  Particle start;

  int mSteps;
  float t;
  float amp;

  Physics physics;

  ArrayList p; //Particles
  ArrayList s; //Springs

  boolean moveMouseEnd;

  Chords(Physics physics) {
    this.physics = physics;

    mSteps = 10;
    t    = 0.0;
    amp  = 10.0;
    moveMouseEnd = false;

    float x1 = 0;
    float y1 = height/2.0;
    float x2 = width;
    float y2 = height/2.0;

    start = new Particle(x1, y1);
    end   = new Particle(x2, y2);

    start.makeLocked();
    end.makeLocked();

    p  =  new ArrayList();
    s  =  new ArrayList();

    p.add(physics.makeParticle(start));
    for (int i = 1; i < (mSteps - 1); i++) {
      float px =  lerp(x1, x2, i/(float)(mSteps-1));
      float py =  lerp(y1, y2, i/(float)(mSteps - 1));
      p.add(physics.makeParticle( new Particle(px, py) ));
    }
    p.add(physics.makeParticle(end));

    float d= dist(x1, y1, x2, y2)/(float)(mSteps-1);

    for (int i = 0; i < (mSteps - 1); i++) {
      Particle p1 = (Particle)p.get(i);
      Particle p2 = (Particle)p.get(i+1);

      s.add( physics.makeSpring( new Spring(p1, p2, d)));
    }
  }


  void display() {

    strokeWeight(1);
    stroke(150);
    beginShape();
    vertex(start.getX(), start.getY());
    vertex(end.getX(), end.getY());
    endShape();


    ArrayList handles = new ArrayList();
    beginShape();
    for (int i = 0; i < mSteps; i++) {
      Particle pa = (Particle)p.get(i);
      //vertex(pa.getX(), pa.getY());
      //pa.update();
      handles.add( new PVector(pa.getX(), pa.getY()));
    }
    endShape();

    Spline2D spline=new Spline2D(handles);
    ArrayList vertices=spline.computeVertices(8);

    stroke(255, 0, 0);
    noFill();
    beginShape();
    for (int i=0; i < vertices.size();i++ ) {
      PVector v = (PVector)vertices.get(i);
      vertex(v.x, v.y);
    }
    endShape();
  }

  void update() {

    float x1=start.getX();
    float x2=end.getX();
    float y1=start.getY();
    float y2=end.getY();

    t+=1/24.0;
    float angle=PI+atan2(y2-y1, x2-x1 );

    for (int i = 1 ; i < (mSteps - 1); i++) {
      Particle p1 = (Particle)p.get(i);
      float x = amp*cos(i*0.5+t)*sin(angle);
      float y = amp*sin(i*0.5+t)*cos(angle);
      p1.position().add(x, y, 0.0);
    }

    float d = dist(x1, y1, x2, y2)/(float)(mSteps-1);
    for (int i = 1; i < (mSteps-1); i++) {
      Spring ss = (Spring)s.get(i);
      float rest = d;
      ss.setRestLength(rest);
    }
  }

  void setEndPos(float x, float y) {
    end.setPos(x, y);
  }

  void moveEnd() {
    moveMouseEnd = !moveMouseEnd;
    if(!moveMouseEnd){
      end.setPos(width, height/2.0);
    }
  }
}

