public class CurveSegment extends Segment {
  private PVector[] controlPoints;
  private int len = 100;
  private float arcLengths[] = new float[len+1];
  private float curveLength = 0;


  public CurveSegment(JSONObject json) {
    JSONArray controlPointsArray = json.getJSONArray("controlPoints");
    if (controlPointsArray.size() != 4) {
      println("Wrong number of control points");
      exit();
    }
    controlPoints = new PVector[4];
    for (int i = 0; i < controlPointsArray.size(); i++) {
      JSONObject controlPointJson = controlPointsArray.getJSONObject(i);
      controlPoints[i] = new PVector(controlPointJson.getFloat("x"), controlPointJson.getFloat("y"));
    }
    init();
  }

  public CurveSegment(PVector A, PVector B, PVector C, PVector D) {
    controlPoints = new PVector[4];
    controlPoints[0] = A.copy();
    controlPoints[1] = B.copy();
    controlPoints[2] = C.copy();
    controlPoints[3] = D.copy();
    init();
  }

  // Approximate the length of the curve
  private void init() {
    float cumulativeLength = 0;
    arcLengths[0] = cumulativeLength;
    PVector prev = bezPoint(0);
    for (int i = 1; i <= len; i++) {
      PVector next = bezPoint(i / (float) len);
      PVector delta = PVector.sub(next, prev);
      cumulativeLength += delta.mag();
      arcLengths[i] = cumulativeLength;
      prev = next.copy();
    }
    curveLength = cumulativeLength;
  }

  @Override
    public PVector get_stitch(float distance) {

    int low = 0;
    int high = len - 1;
    int index = 0;
    print("cdistance ");
    println(distance);

    while (low <= high) {
      index = low + (high - low) / 2;

      if (arcLengths[index+1] < distance) {
        low = index + 1;
      } else if (arcLengths[index] > distance) {
        high = index - 1;
      } else {
        break;
      }
    }

    float lengthBefore = arcLengths[index];

    if (lengthBefore == distance) {
      return bezPoint(index / (float) len);
    } else {
      float lengthAfter = arcLengths[index+1];
      print("clengthBefore ");
      println(lengthBefore);
      print("clengthAfter ");
      println(lengthAfter);
      float window = lengthAfter - lengthBefore;
      print("cwindow ");
      println(window);
      float t = (distance - lengthBefore) / window;
      print("ct ");
      println(t);
      return PVector.lerp(bezPoint(lengthBefore), bezPoint(lengthAfter), t );
    }
  }

  // Return a point on a bezier, not arc-length parameterized
  private PVector bezPoint(float t) {
    return new PVector(
      bezierPoint(controlPoints[0].x, controlPoints[1].x, controlPoints[2].x, controlPoints[3].x, t),
      bezierPoint(controlPoints[0].y, controlPoints[1].y, controlPoints[2].y, controlPoints[3].y, t)
      );
  }

  // Render the curve path to the screen or output file
  @Override
    public void draw() {
    noFill();
    bezier(controlPoints[0].x, controlPoints[0].y,
      controlPoints[1].x, controlPoints[1].y,
      controlPoints[2].x, controlPoints[2].y,
      controlPoints[3].x, controlPoints[3].y);
  }

  // Return an offset curve path for seam allowance
  // BUG: IF ABC or BCD are colinear, this returns a null PVector for a control point
  @Override
    public CurveSegment offset(float offset) {
    PVector new_curve[] = new PVector[4];

    // Tiller-Hanson algorithm just offsets the line segments between control points
    // It has close enough results for "simple" beziers to work for calculating a seam allowance
    LineSegment AB = new LineSegment(controlPoints[0], controlPoints[1]);
    LineSegment BC = new LineSegment(controlPoints[1], controlPoints[2]);
    LineSegment CD = new LineSegment(controlPoints[2], controlPoints[3]);

    AB = AB.offset(offset);
    BC = BC.offset(offset);
    CD = CD.offset(offset);

    // To calculate first and last endpoints, we can use AB[0] and CD[1] directly
    // To calculate the middle endpoints, we need to calculate a new intersection point
    // between the middle segment, and the first/last segment
    new_curve[0] = AB.start;
    new_curve[1] = intersectionPoint(AB.start, AB.end, BC.start, BC.end); // TODO? check for null
    new_curve[2] = intersectionPoint(BC.start, BC.end, CD.start, CD.end); // TODO? check for null
    new_curve[3] = CD.end;

    return new CurveSegment(new_curve[0], new_curve[1], new_curve[2], new_curve[3]);
  }

  // Return curve length
  @Override
    public float getLength() {
    return curveLength;
  }
}
