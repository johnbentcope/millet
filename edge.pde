class Edge {
  ArrayList<Segment> segments;
  ArrayList<Segment> cutPaths;
  ArrayList<PVector> stitches;
  
  private int len = 0;
  private float seg_lengths[];
  float edge_length = 0;
  int stitch_count = 0;

  float stitch_pitch = 0;

  Edge(float stitch_pitch) {
    this.stitch_pitch = stitch_pitch;
    segments = new ArrayList<>();
    cutPaths = new ArrayList<>();
    stitches = new ArrayList<>();
  }

  public void parseJSON(JSONObject json) {
    JSONArray jsonArray = json.getJSONArray("segments");
    for (int i = 0; i < jsonArray.size(); i++) {
      JSONObject segmentJson = jsonArray.getJSONObject(i);
      String type = segmentJson.getString("type");
      println(type);
      switch (type) {
      case "line":
        segments.add(new LineSegment(segmentJson));
        break;
      case "arc":
        segments.add(new ArcSegment(segmentJson));
        break;
      case "curve":
        segments.add(new CurveSegment(segmentJson));
        break;
      default:
        throw new IllegalArgumentException("Invalid segment type: " + type);
      }
    }
    len = segments.size();
    seg_lengths = new float[len];
    println(len);
    for (int i = 0; i < len; i++) {
      edge_length += segments.get(i).getLength();
      seg_lengths[i] = edge_length;
    }
    stitch_count = Math.round(edge_length/stitch_pitch)+1; // Plus one for fencepost problem
    println(seg_lengths);
    println(edge_length);
    println(stitch_count);
    
  }
  
  void get_stitches(){
  }
  
  PVector get_stitch(float t){
    return new PVector(0,0);
  }

  void draw() {
    stroke(255,0,0);
    for (Segment segment : segments) {
      segment.draw();
    }
    stroke(0,0,255);
    for (Segment segment : cutPaths) {
      segment.draw();
    }
  }

  ArrayList<Segment> getSegments() {
    return segments;
  }

  void offset(float offset) {
    cutPaths.clear();
    for (Segment segment : segments) {
      Segment cutPath = segment.offset(offset);
      cutPaths.add(cutPath);
    }
  }

}
