import java.util.ArrayList;

int vertexCount = 8;
float[][] positions = {
  {175, 213}, {382, 158}, {708, 211}, {225, 407},
  {474, 370}, {765, 424}, {315, 611}, {659, 610}
};
String[] names = {"A", "B", "C", "D", "E", "F", "G", "H"};

ArrayList<Edge> edges = new ArrayList<Edge>();
ArrayList<Decision> decisions = new ArrayList<Decision>();
int step = 0;
int totalCost = 0;
int chosenCount = 0;
int interval = 800;
int lastTick = 0;
boolean playing = false;
boolean randomGraph = false;
PFont uiFont;

int backgroundColor, panelColor, textColor, subtleColor;
int acceptedColor, rejectedColor, currentColor, idleColor;

class Edge {
  int u;
  int v;
  int weight;

  Edge(int a, int b, int w) {
    u = a;
    v = b;
    weight = w;
  }
}

class Decision {
  Edge edge;
  boolean accepted;
  int sum;
  int count;

  Decision(Edge e, boolean ok, int s, int c) {
    edge = e;
    accepted = ok;
    sum = s;
    count = c;
  }
}

void setup() {
  size(1280, 760);
  smooth(8);
  uiFont = createFont("SansSerif", 16);
  textFont(uiFont);
  backgroundColor = color(11, 20, 36);
  panelColor = color(20, 35, 57);
  textColor = color(235, 243, 252);
  subtleColor = color(138, 160, 184);
  acceptedColor = color(48, 210, 172);
  rejectedColor = color(240, 104, 123);
  currentColor = color(255, 196, 85);
  idleColor = color(74, 96, 120);
  makeGraph();
}

void draw() {
  if (playing && millis() - lastTick >= interval) {
    if (step < decisions.size()) {
      step++;
      lastTick = millis();
    }
    if (step >= decisions.size()) playing = false;
  }

  background(backgroundColor);
  showHeader();
  showGraph();
  showPanel();
  showFooter();
}

void addEdge(int a, int b, int w) {
  edges.add(new Edge(a, b, w));
}

void makeGraph() {
  edges.clear();
  addEdge(4, 6, 1);
  addEdge(1, 4, 2);
  addEdge(3, 4, 3);
  addEdge(0, 1, 4);
  addEdge(1, 3, 5);
  addEdge(2, 5, 6);
  addEdge(2, 4, 7);
  addEdge(4, 5, 8);
  addEdge(4, 7, 9);
  addEdge(0, 3, 10);
  addEdge(6, 7, 11);
  addEdge(1, 2, 12);
  addEdge(5, 7, 13);
  addEdge(0, 4, 14);
  addEdge(2, 7, 15);
  addEdge(3, 6, 16);
  randomGraph = false;
  prepare();
}

void randomWeights() {
  boolean[] used = new boolean[41];
  for (Edge e : edges) {
    int w = (int)random(1, 41);
    while (used[w]) w = (int)random(1, 41);
    used[w] = true;
    e.weight = w;
  }
  randomGraph = true;
  prepare();
}

void prepare() {
  for (int i = 1; i < edges.size(); i++) {
    Edge item = edges.get(i);
    int j = i - 1;
    while (j >= 0 && edges.get(j).weight > item.weight) {
      edges.set(j + 1, edges.get(j));
      j--;
    }
    edges.set(j + 1, item);
  }

  decisions.clear();
  int[] parent = new int[vertexCount];
  int[] rank = new int[vertexCount];
  for (int i = 0; i < vertexCount; i++) parent[i] = i;

  int sum = 0;
  int count = 0;
  for (Edge e : edges) {
    boolean ok = unite(parent, rank, e.u, e.v);
    if (ok) {
      sum += e.weight;
      count++;
    }
    decisions.add(new Decision(e, ok, sum, count));
    if (count == vertexCount - 1) break;
  }

  step = 0;
  playing = false;
  lastTick = millis();
}

int findRoot(int[] parent, int a) {
  if (parent[a] != a) parent[a] = findRoot(parent, parent[a]);
  return parent[a];
}

boolean unite(int[] parent, int[] rank, int a, int b) {
  int rootA = findRoot(parent, a);
  int rootB = findRoot(parent, b);
  if (rootA == rootB) return false;

  if (rank[rootA] < rank[rootB]) parent[rootA] = rootB;
  else if (rank[rootA] > rank[rootB]) parent[rootB] = rootA;
  else {
    parent[rootB] = rootA;
    rank[rootA]++;
  }
  return true;
}

int edgeStatus(int i) {
  if (i < step && i < decisions.size()) return decisions.get(i).accepted ? 1 : 2;
  if (i == step && step < decisions.size()) return 3;
  return 0;
}

void showHeader() {
  noStroke();
  fill(19, 34, 55);
  rect(0, 0, width, 91);
  fill(textColor);
  textAlign(LEFT, CENTER);
  textSize(28);
  text("KRUSKAL'S ALGORITHM", 34, 34);
  fill(subtleColor);
  textSize(13);
  text("MINIMUM SPANNING TREE  /  GREEDY + UNION-FIND", 36, 67);
  fill(183, 210, 226);
  textAlign(RIGHT, CENTER);
  textSize(13);
  text("SPACE Play/Pause   LEFT/RIGHT Step   F Finish   R Reset   N New Weights   1 Sample   +/- Speed", 1244, 48);
}

void showGraph() {
  noStroke();
  fill(panelColor);
  rect(22, 107, 890, 598, 16);
  fill(subtleColor);
  textAlign(LEFT, CENTER);
  textSize(13);
  text("WEIGHTED UNDIRECTED GRAPH", 45, 129);

  for (int pass = 0; pass < 2; pass++) {
    for (int i = 0; i < edges.size(); i++) {
      int status = edgeStatus(i);
      if (pass == 0 && status == 1) continue;
      if (pass == 1 && status != 1) continue;
      Edge e = edges.get(i);
      if (status == 1) {
        stroke(acceptedColor);
        strokeWeight(5);
      } else if (status == 2) {
        stroke(rejectedColor, 155);
        strokeWeight(2);
      } else if (status == 3) {
        stroke(currentColor);
        strokeWeight(4);
      } else {
        stroke(idleColor);
        strokeWeight(2);
      }
      line(positions[e.u][0], positions[e.u][1], positions[e.v][0], positions[e.v][1]);
    }
  }

  for (int i = 0; i < edges.size(); i++) drawWeight(edges.get(i), edgeStatus(i));

  boolean[] connected = new boolean[vertexCount];
  for (int i = 0; i < step && i < decisions.size(); i++) {
    Decision d = decisions.get(i);
    if (d.accepted) {
      connected[d.edge.u] = true;
      connected[d.edge.v] = true;
    }
  }

  for (int i = 0; i < vertexCount; i++) {
    float x = positions[i][0];
    float y = positions[i][1];
    stroke(connected[i] ? acceptedColor : color(128, 159, 188));
    strokeWeight(3);
    fill(connected[i] ? color(32, 110, 105) : color(45, 75, 111));
    ellipse(x, y, 53, 53);
    noStroke();
    fill(textColor);
    textAlign(CENTER, CENTER);
    textSize(21);
    text(names[i], x, y - 2);
  }

  noStroke();
  fill(182, 202, 219);
  textSize(13);
  textAlign(LEFT, CENTER);
  text("Accepted", 66, 673);
  fill(acceptedColor);
  ellipse(53, 673, 10, 10);
  fill(182, 202, 219);
  text("Cycle / skipped", 215, 673);
  fill(rejectedColor);
  ellipse(200, 673, 10, 10);
  fill(182, 202, 219);
  text("Next edge", 412, 673);
  fill(currentColor);
  ellipse(399, 673, 10, 10);
}

void drawWeight(Edge e, int status) {
  float ax = positions[e.u][0];
  float ay = positions[e.u][1];
  float bx = positions[e.v][0];
  float by = positions[e.v][1];
  float dx = bx - ax;
  float dy = by - ay;
  float len = max(1, sqrt(dx * dx + dy * dy));
  float x = (ax + bx) / 2 - dy / len * 12;
  float y = (ay + by) / 2 + dx / len * 12;

  noStroke();
  if (status == 1) fill(acceptedColor);
  else if (status == 2) fill(rejectedColor);
  else if (status == 3) fill(currentColor);
  else fill(41, 58, 80);
  rectMode(CENTER);
  rect(x, y, 31, 25, 7);
  rectMode(CORNER);
  fill(status == 1 || status == 2 || status == 3 ? color(13, 25, 39) : textColor);
  textAlign(CENTER, CENTER);
  textSize(13);
  text(e.weight, x, y - 1);
}

void showPanel() {
  noStroke();
  fill(panelColor);
  rect(926, 107, 333, 598, 16);
  fill(textColor);
  textAlign(LEFT, CENTER);
  textSize(19);
  text("MST PROGRESS", 951, 140);

  int sum = 0;
  int count = 0;
  if (step > 0) {
    Decision current = decisions.get(step - 1);
    sum = current.sum;
    count = current.count;
  }

  fill(acceptedColor);
  textSize(41);
  text(sum, 951, 190);
  fill(subtleColor);
  textSize(13);
  text("TOTAL WEIGHT", 952, 224);
  fill(textColor);
  textSize(15);
  text(count + " / " + (vertexCount - 1) + " edges selected", 1094, 189);
  fill(subtleColor);
  textSize(13);
  text("Step " + step + " / " + decisions.size(), 1094, 221);

  fill(32, 49, 72);
  rect(948, 243, 287, 46, 9);
  textAlign(LEFT, CENTER);
  if (step == decisions.size()) {
    fill(acceptedColor);
    textSize(15);
    text("MST COMPLETE", 964, 266);
  } else if (step == 0) {
    fill(currentColor);
    textSize(14);
    text("Ready to inspect the first edge", 964, 266);
  } else {
    Decision d = decisions.get(step - 1);
    fill(d.accepted ? acceptedColor : rejectedColor);
    textSize(14);
    text(names[d.edge.u] + "-" + names[d.edge.v] + "  w=" + d.edge.weight + "  " + (d.accepted ? "ACCEPT" : "CYCLE / SKIP"), 964, 266);
  }

  fill(subtleColor);
  textSize(12);
  text("SORTED EDGES", 951, 311);
  text("DECISION", 1158, 311);

  int rowHeight = 22;
  for (int i = 0; i < edges.size(); i++) {
    int y = 335 + rowHeight * i;
    int status = edgeStatus(i);
    if (status == 3) {
      noStroke();
      fill(70, 65, 56);
      rect(947, y - 12, 288, 22, 5);
    }
    fill(status == 1 ? acceptedColor : status == 2 ? rejectedColor : status == 3 ? currentColor : subtleColor);
    textAlign(LEFT, CENTER);
    textSize(13);
    Edge e = edges.get(i);
    text(nf(i + 1, 2) + "   " + names[e.u] + "-" + names[e.v] + "   w=" + nf(e.weight, 2), 950, y);
    textAlign(RIGHT, CENTER);
    text(status == 1 ? "ADD" : status == 2 ? "SKIP" : status == 3 ? "NEXT" : "-", 1230, y);
  }
}

void showFooter() {
  noStroke();
  fill(19, 34, 55);
  rect(0, 716, width, 44);
  fill(textColor);
  textAlign(LEFT, CENTER);
  textSize(14);
  String state = step == decisions.size() ? "DONE" : playing ? "PLAYING" : "PAUSED";
  text(state + "     " + (randomGraph ? "Random weights" : "Sample graph") + "     Delay: " + interval + " ms", 35, 738);
  textAlign(RIGHT, CENTER);
  fill(subtleColor);
  text("Cycle check: Disjoint Set Union (Union-Find)", 1245, 738);
}

void nextStep() {
  step = min(step + 1, decisions.size());
  lastTick = millis();
  if (step == decisions.size()) playing = false;
}

void previousStep() {
  step = max(0, step - 1);
  playing = false;
  lastTick = millis();
}

void keyPressed() {
  if (key == ' ' ) {
    if (step >= decisions.size()) step = 0;
    playing = !playing;
    lastTick = millis();
  } else if (key == 'r' || key == 'R') {
    step = 0;
    playing = false;
  } else if (key == 'n' || key == 'N') {
    randomWeights();
  } else if (key == '1') {
    makeGraph();
  } else if (key == 'f' || key == 'F') {
    step = decisions.size();
    playing = false;
  } else if (key == '+' || key == '=') {
    interval = max(150, interval - 100);
  } else if (key == '-' || key == '_') {
    interval = min(2000, interval + 100);
  } else if (key == CODED && keyCode == RIGHT) {
    playing = false;
    nextStep();
  } else if (key == CODED && keyCode == LEFT) {
    previousStep();
  }
}
