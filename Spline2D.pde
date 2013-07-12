
/*
 * Copyright (c) 2007 Karsten Schmidt
 * 
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
 */

class Spline2D {

  PVector[] vpoints;

  ArrayList<PVector> pointList = new ArrayList<PVector>();

  ArrayList<PVector> vertices;

  BernsteinPolynomial bernstein;

  PVector[] delta;

  PVector[] coeffA;

  float[] bi;

  float tightness;

  float invTightness;

  int numP;

  /**
   * @param rawPoints
   *            list of control point vectors
   */
  public Spline2D(ArrayList<PVector> rawPoints) {
    this( rawPoints, null, 0.25);
  }

  /**
   * @param rawPoints
   *            list of control point vectors
   * @param b
   *            predefined Bernstein polynomial (good for reusing)
   * @param tightness
   *            default curve tightness used for the interpolated vertices
   *            {@linkplain #setTightness(float)}
   */
  public Spline2D(ArrayList<PVector> rawPoints, BernsteinPolynomial b, 
  float tightness) {
    pointList.addAll(rawPoints);
    bernstein = b;
    setTightness(tightness);
  }

  public Spline2D add(float px, float py) {
    return add(new PVector(px, py));
  }

  /**
   * Adds the given point to the list of control points.
   * 
   * @param p
   * @return itself
   */
  public Spline2D add(PVector p) {
    pointList.add(p);
    return this;
  }

  /**
   * <p>
   * Computes all curve vertices based on the resolution/number of
   * subdivisions requested. The higher, the more vertices are computed:
   * </p>
   * <p>
   * <strong>(number of control points - 1) * resolution + 1</strong>
   * </p>
   * <p>
   * Since version 0014 the automatic placement of the curve handles can also
   * be manipulated via the {@linkplain #setTightness(float)} method.
   * </p>
   * 
   * @param res
   *            the number of vertices to be computed per segment between
   *            original control points (incl. control point always at the
   *            start of each segment)
   * @return list of Vec2D vertices along the curve
   */
  public ArrayList<PVector> computeVertices(int res) {
    updateCoefficients();

    res++;
    if (bernstein == null || bernstein.resolution != res) {
      bernstein = new BernsteinPolynomial(res);
    }
    if (vertices == null) {
      vertices = new ArrayList<PVector>();
    } 
    else {
      vertices.clear();
    }
    findCPoints();
    PVector deltaP = new PVector();
    PVector deltaQ = new PVector();
    res--;
    for (int i = 0; i < numP - 1; i++) {
      PVector p = vpoints[i];
      PVector q = vpoints[i + 1];
      deltaP.set(delta[i]);
      deltaP.add(p);
      deltaQ.set(q);
      deltaQ.sub(delta[i + 1]);
      for (int k = 0; k < res; k++) {
        float px =
          p.x * bernstein.b0[k] + deltaP.x * bernstein.b1[k]
          + deltaQ.x * bernstein.b2[k] + q.x
          * bernstein.b3[k];
        float py =
          p.y * bernstein.b0[k] + deltaP.y * bernstein.b1[k]
          + deltaQ.y * bernstein.b2[k] + q.y
          * bernstein.b3[k];
        vertices.add(new PVector(px, py));
      }
    }
    vertices.add(vpoints[vpoints.length - 1]);
    return vertices;
  }

  protected void findCPoints() {
    bi[1] = -tightness;
    coeffA[1].set( (vpoints[2].x - vpoints[0].x - delta[0].x) * tightness,
                    (vpoints[2].y - vpoints[0].y - delta[0].y) * tightness);

    for (int i = 2; i < numP - 1; i++) {
      bi[i] = -1 / (invTightness + bi[i - 1]);
      coeffA[i].set(-(vpoints[i + 1].x - vpoints[i - 1].x - coeffA[i - 1].x)* bi[i], 
          -1*(vpoints[i + 1].y - vpoints[i - 1].y - coeffA[i - 1].y)* bi[i]);
    }
    for (int i = numP - 2; i > 0; i--) {
      delta[i].set(coeffA[i].x + delta[i + 1].x * bi[i], 
          coeffA[i].y + delta[i + 1].y * bi[i]);
    }

  }

  /**
   * Sets the tightness for future curve interpolation calls. Default value is
   * 0.25. A value of 0.0 equals linear interpolation between the given curve
   * input points. Curve behaviour for values outside the 0.0 .. 0.5 interval
   * is unspecified and becomes increasingly less intuitive. Negative values
   * are possible too and create interesting results (in some cases).
   * 
   * @param tightness
   *            the tightness value used for the next call to
   *            {@link #computeVertices(int)}
   * @since 0014 (rev. 216)
   */
  void setTightness(float tightness) {
    this.tightness = tightness;
    this.invTightness = 1f / tightness;
    // return this;
  }

  public void updateCoefficients() {
    numP = pointList.size();
    if (vpoints == null || (vpoints != null && vpoints.length != numP)) {
      coeffA = new PVector[numP];
      delta = new PVector[numP];
      bi = new float[numP];
      for (int i = 0; i < numP; i++) {
        coeffA[i] = new PVector();
        delta[i] = new PVector();
      }
      setTightness(tightness);
    }
    vpoints =  ((ArrayList<PVector>)pointList).toArray(new PVector[0]);
  }
}

//BernsteinPolynomial
class BernsteinPolynomial {
  public float[] b0, b1, b2, b3;
  public int resolution;

  public BernsteinPolynomial(int res) {
    resolution = res;
    b0 = new float[res];
    b1 = new float[res];
    b2 = new float[res];
    b3 = new float[res];
    float t = 0;
    float dt = 1.0f / (resolution - 1);
    for (int i = 0; i < resolution; i++) {
      float t1  =  1 - t;
      float t12 = t1 * t1;
      float t2  =  t * t;
      b0[i] = t1 * t12;
      b1[i] = 3 * t * t12;
      b2[i] = 3 * t2 * t1;
      b3[i] = t * t2;
      t += dt;
    }
  }
}

