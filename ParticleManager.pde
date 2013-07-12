class ParticleManager {
  ArrayList mParticles;

  ParticleManager() {
    this.mParticles = new ArrayList<Particle>();
  }

  void add(Particle p ) {
    mParticles.add(p);
  }

  void update() {
    for (int i = 0; i < mParticles.size(); i++) {
      Particle p =  (Particle)mParticles.get(i);
      p.update();
    }
  }

  void drawParticles() {
    for (int i = 0; i < mParticles.size(); i++) {
      Particle p =  (Particle)mParticles.get(i);
      p.drawParticle();
    }
  }
  
}

