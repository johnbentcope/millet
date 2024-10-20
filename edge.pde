class Edge {
  ArrayList<Segment> segments;
  ArrayList<Segment> cutPaths;

  Edge() {
    segments = new ArrayList<>();
    cutPaths = new ArrayList<>();
  }

  public void parseJSON(JSONObject json) {
    JSONArray jsonArray = json.getJSONArray("segments");
    for (int i = 0; i < jsonArray.size(); i++) {
      JSONObject segmentJson = jsonArray.getJSONObject(i);
      String type = segmentJson.getString("type");
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
