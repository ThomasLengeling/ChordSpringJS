class SpringManager {
  ArrayList mSpring;

  SpringManager() {
    mSpring = new ArrayList<Spring>();
  }

  void add(Spring s ) {
    mSpring.add(s);
  }

  void update() {
    for (int i = 0; i < mSpring.size(); i++) {
      Spring s =  (Spring)mSpring.get(i);
      s.update();
    }
  }

  void drawSprings() {
    for (int i = 0; i < mSpring.size(); i++) {
      Spring s =  (Spring)mSpring.get(i);
      s.drawSpring();
    }
  }
}

