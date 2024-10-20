// points always count clockwise winding
// beziers have low curvature, never self-intersect (Tiller-Hanson bezier offsetting applies)
// edges are made of lines (lines), circular arcs (arcs), and bezier curves (curves)

// Program external requirements:
// Inputs
// Config file of edges, a stitch spacing, a seam allowance
// Outputs
// generate a new SVG ready for lasering, with stitch punches in one color and cut lines in another

ArrayList<Panel> panels;
float offset = 20;

void setup() {
  size(400, 400);
  panels = new ArrayList<Panel>(); // Pass PApplet instance to Panel constructor
  String jsonFilePath = "data/augh.json"; // Replace with your actual file path
  JSONObject json = loadJSONObject(jsonFilePath);
  //JSONObject json = parseJSONObject(my_conf);
  JSONArray panelsArray = json.getJSONArray("panels");
  panels = new ArrayList<>();
  for (int i = 0; i < panelsArray.size(); i++) {
    JSONObject panelJson = panelsArray.getJSONObject(i);
    Panel panel = new Panel();
    panel.parseJSON(panelJson);
    panels.add(panel);
  }

  // Offset panels
  for (Panel panel : panels) {
    panel.offset(offset);
  }
}

void draw() {
  background(200);

  // Draw panel
  panels.get(0).draw();
  
}
