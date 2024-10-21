// In the case of stitching panels for a beanbag, an Edge refers to one "side" of a panel
// in which stitches are positioned uniformly. Edges can be made of multiple segments,
// such as lines, arc, or cubic bezier curves.

class Edge {
  ArrayList<Segment> segments;
  ArrayList<Segment> cutPaths;
  ArrayList<PVector> stitches;

  private int len = 0;
  private float seg_lengths[];
  float edge_length = 0;
  int stitch_count = 0;

  float stitch_pitch = 0;
  float stitch_pitch_ref = 0;

  Edge(float stitch_pitch_ref) {
    this.stitch_pitch_ref = stitch_pitch_ref;
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
    seg_lengths = new float[len+1];
    seg_lengths[0] = 0;
    println(len);
    for (int i = 1; i <= len; i++) {
      edge_length += segments.get(i-1).getLength();
      seg_lengths[i] = edge_length;
    }
    stitch_count = Math.round(edge_length/stitch_pitch_ref)+1; // Plus one for fencepost problem
    stitch_pitch = edge_length/stitch_count; // Actual stitch_pitch
    println(seg_lengths);
    println(edge_length);
    println(stitch_count);
    for (int i = 0; i < stitch_count; i++) {
      compute_stitches(stitch_pitch*i);
    }
  }

  public void compute_stitches(float targetLength) {

    int low = 0;
    int high = segments.size()-1;
    int index = 0;
    println();
    //print("targetLength ");
    //println(targetLength);

    while (low <= high) {
      index = low + (high - low) / 2;

      if (seg_lengths[index+1] < targetLength) {
        println("ping");
        low = index + 1;
      } else if (seg_lengths[index] > targetLength) {
        println("pong");
        high = index - 1;
      } else {
        println("pain");
        break;
      }
    }

    float lengthBefore = seg_lengths[index];

    //print("lengthBefore ");
    //println(lengthBefore);
    stitches.add(segments.get(index).get_stitch(targetLength-lengthBefore));
    //if (lengthBefore == targetLength) {
    //    return index / (float) len;
    //} else {
    //    return (index + (targetLength - lengthBefore) / (seg_lengths[index + 1] - lengthBefore)) / (float) len;
    //}
  }

  void draw() {
    stroke(255, 0, 0);
    for (Segment segment : segments) {
      segment.draw();
    }
    stroke(0, 0, 255);
    for (Segment segment : cutPaths) {
      segment.draw();
    }
    strokeWeight(5);
    stroke(0, 255, 0);
    for (PVector stitch : stitches) {
      point(stitch.x, stitch.y);
    }
    strokeWeight(1);
  }

  // Perform offsetting operation on all segments in edge
  void offset(float offset) {
    cutPaths.clear();
    for (Segment segment : segments) {
      Segment cutPath = segment.offset(offset);
      cutPaths.add(cutPath);
    }
  }
}
