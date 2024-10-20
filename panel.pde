class Panel extends PApplet {
  private ArrayList<Edge> edges;

  public Panel() {
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
      Edge edge = new Edge(); // Pass PApplet instance to Edge constructor
      edge.parseJSON(edgeJson);
      edges.add(edge);
    }
  }

  void offset(float offset) {
    for (Edge edge : edges) {
      edge.offset(offset);
    }
  }

  public ArrayList<Edge> getEdges() {
    return edges;
  }

}
