class Panel extends PApplet {
  private ArrayList<Edge> edges;

  float seam_allowance;
  float stitch_pitch;

  public Panel(float seam_allowance, float stitch_pitch) {
    this.seam_allowance = seam_allowance;
    this.stitch_pitch   = stitch_pitch;
    edges = new ArrayList<>();
  }

  public void draw() {
    // Draw the panel's edges
    for (Edge edge : edges) {
      edge.draw();
    }
  }

  public void parseJSON(JSONObject json) {
    JSONArray jsonArray = json.getJSONArray("edges");
    for (int i = 0; i < jsonArray.size(); i++) {
      JSONObject edgeJson = jsonArray.getJSONObject(i);
      Edge edge = new Edge(stitch_pitch); // Pass PApplet instance to Edge constructor
      edge.parseJSON(edgeJson);
      edges.add(edge);
    }
  }

  void offset() {
    for (Edge edge : edges) {
      edge.offset(seam_allowance);
    }
  }

  public ArrayList<Edge> getEdges() {
    return edges;
  }
}
