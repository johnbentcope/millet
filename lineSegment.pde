public class LineSegment extends Segment {
  PVector start, end;

  public LineSegment(JSONObject json) {
    start = new PVector(json.getJSONObject("start").getFloat("x"), json.getJSONObject("start").getFloat("y"));
    end = new PVector(json.getJSONObject("end").getFloat("x"), json.getJSONObject("end").getFloat("y"));
  }

  public LineSegment(PVector start, PVector end) {
    this.start = start;
    this.end   = end;
  }

  @Override
    public void draw() {
    line(start.x, start.y, end.x, end.y);
  }

  @Override
    public LineSegment offset(float offset) {
    PVector normal = PVector.sub(start, end).rotate(-HALF_PI).normalize().mult(offset);
    PVector newStart = start.copy().add(normal);
    PVector newEnd = end.copy().add(normal);
    return new LineSegment(newStart, newEnd);
  }
}
