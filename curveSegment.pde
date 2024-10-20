public class CurveSegment extends Segment {
  private PVector[] controlPoints;

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
  }
  public CurveSegment(PVector A, PVector B, PVector C, PVector D) {
    controlPoints = new PVector[4];
    controlPoints[0] = A.copy();
    controlPoints[1] = B.copy();
    controlPoints[2] = C.copy();
    controlPoints[3] = D.copy();
  }

  @Override
    public void draw() {
    noFill();
    bezier(controlPoints[0].x, controlPoints[0].y,
      controlPoints[1].x, controlPoints[1].y,
      controlPoints[2].x, controlPoints[2].y,
      controlPoints[3].x, controlPoints[3].y);
  }

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
}
