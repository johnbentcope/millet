public class ArcSegment extends Segment {
  private PVector center;
  private PVector size;
  private float startAngle, endAngle;

  public ArcSegment(JSONObject json) {
    center = new PVector(json.getJSONObject("center").getFloat("x"), json.getJSONObject("center").getFloat("y"));
    size = new PVector(json.getJSONObject("size").getFloat("x"), json.getJSONObject("size").getFloat("y"));
    startAngle = json.getJSONObject("angles").getFloat("start");
    endAngle = json.getJSONObject("angles").getFloat("end");
  }
  public ArcSegment(PVector center, PVector size, float startAngle, float endAngle) {
    this.center     = center.copy();
    this.size       = size.copy();
    this.startAngle = startAngle;
    this.endAngle   = endAngle;
  }

  @Override
    public void draw() {
    noFill();
    arc(center.x, center.y, size.x, size.y, startAngle, endAngle);
  }

  @Override
    public ArcSegment offset(float offset) {
    return new ArcSegment(center, PVector.mult( size, (size.x + offset*2) / (size.x)), startAngle, endAngle);
  }
}
