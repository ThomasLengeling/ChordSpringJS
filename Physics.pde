class Physics {
  ParticleManager particles;
  SpringManager   springs;

  Physics() {
    this.particles = new ParticleManager();
    this.springs   = new SpringManager();
  }

  void update() {
    particles.update();
    springs.update();
  }

  void drawPhysics() {
    particles.drawParticles();
    springs.drawSprings();
  }

  void addParticle(Particle p) {
    particles.add(p);
  }

  void addSpring(Spring s) {
    springs.add(s);
  }

  Particle makeParticle(Particle p) {
    particles.add(p);
    return p;
  }

  Spring makeSpring(Spring s) {
    springs.add(s); 
    return s;
  }
}

