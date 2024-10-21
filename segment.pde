public abstract class Segment {

  // Probably need to put start and end PVectors in here, since I need them between segment types
  
  public Segment() {
  }

  public abstract void draw();
  public abstract Segment offset(float offset);
  public abstract float getLength();
  public abstract PVector get_stitch(float distance);

  PVector intersectionPoint(PVector A, PVector B, PVector C, PVector D) {
    // Calculate direction vectors of the lines
    PVector AB = PVector.sub(B, A);
    PVector CD = PVector.sub(D, C);

    // Check for vertical lines
    boolean isABVertical = Math.abs(AB.x) < EPSILON;
    boolean isCDVertical = Math.abs(CD.x) < EPSILON;

    // Handle vertical lines separately
    if (isABVertical && isCDVertical) {
      // Both lines are vertical, no intersection
      return null;
    } else if (isABVertical) {
      // Only AB is vertical, calculate intersection point using CD's equation
      float slopeCD = CD.y / CD.x;
      float interceptCD = C.y - slopeCD * C.x;
      float x = A.x;
      float y = slopeCD * x + interceptCD;
      return new PVector(x, y);
    } else if (isCDVertical) {
      // Only CD is vertical, calculate intersection point using AB's equation
      float slopeAB = AB.y / AB.x;
      float interceptAB = A.y - slopeAB * A.x;
      float x = C.x;
      float y = slopeAB * x + interceptAB;
      return new PVector(x, y);
    }

    // Both lines are not vertical, calculate slopes and y-intercepts
    float slopeAB = AB.y / AB.x;
    float slopeCD = CD.y / CD.x;

    // Check if lines are parallel (slopeAB == slopeCD)
    // Note: this may cause bugs later if the lines aren't parallel, but reeeeally close
    // I'm avoiding a direct comparison because floating point precision
    if (Math.abs(slopeAB - slopeCD) < EPSILON) {
      // Lines are parallel, no intersection
      return null;
    }

    // Calculate y-intercepts of the lines
    float interceptAB = A.y - slopeAB * A.x;
    float interceptCD = C.y - slopeCD * C.x;

    // Calculate x-coordinate of the intersection point
    float x = (interceptCD - interceptAB) / (slopeAB - slopeCD);

    // Calculate y-coordinate of the intersection point
    float y = slopeAB * x + interceptAB;

    return new PVector(x, y);
  }
}
