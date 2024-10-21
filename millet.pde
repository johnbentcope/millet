// points always count clockwise winding
// beziers have low curvature, never self-intersect (Tiller-Hanson bezier offsetting applies)
// edges are made of lines (lines), circular arcs (arcs), and bezier curves (curves)

// Program external requirements:
// Inputs
// Config file of edges, a stitch spacing, a seam allowance
// Outputs
// generate a new SVG ready for lasering, with stitch punches in one color and cut lines in another

ArrayList<Panel> panels;

void setup() {
  // Set up canvas
  size(400, 400);
  
  // Get ready to initialize panels
  panels = new ArrayList<Panel>();
  float seam_allowance = 20;
  float stitch_pitch = 10;

  // Load the panel description file and initialize all panels
  String jsonFilePath = "data/augh.json";
  JSONObject json = loadJSONObject(jsonFilePath);
  JSONArray panelsArray = json.getJSONArray("panels");
  for (int i = 0; i < panelsArray.size()-1; i++) {
    JSONObject panelJson = panelsArray.getJSONObject(i);
    Panel panel = new Panel(seam_allowance, stitch_pitch);
    panel.parseJSON(panelJson);
    panels.add(panel);
  }

  // Calculate seam allowances for all panels
  for (Panel panel : panels) {
    panel.offset();
  }
  panels.get(0).draw();
}

void draw() {
  background(200);

  // Draw first panel
  panels.get(0).draw();
}
