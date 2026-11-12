int V = 9;
boolean[][] graph = new boolean[V][V];
float[][] pos = {
  {405, 190}, {185, 310}, {410, 330},
  {655, 310}, {185, 515}, {405, 520},
  {655, 515}, {310, 675}, {550, 675}
};

ArrayList<SearchStep> steps = new ArrayList<SearchStep>();
int[] parent = new int[V];
int[] visitRank = new int[V];
int startVertex = 0;
int currentStep = -1;
int interval = 700;
int lastTick = 0;
boolean playing = false;
String mode = "";
PFont uiFont;

class SearchStep {
  int vertex;
  int[] frontier;

  SearchStep(int v, ArrayList<Integer> items) {
    vertex = v;
    frontier = new int[items.size()];
    for (int i = 0; i < items.size(); i++) {
      frontier[i] = items.get(i);
    }
  }
}

void setup() {
  size(1200, 680);
  smooth(8);
  uiFont = createFont("SansSerif", 16);
  textFont(uiFont);
  initGraph();
  beginSearch("BFS");
}

void initGraph() {
  addEdge(0, 1);
  addEdge(0, 2);
  addEdge(0, 3);
  addEdge(1, 4);
  addEdge(1, 5);
  addEdge(2, 5);
  addEdge(2, 6);
  addEdge(3, 6);
  addEdge(4, 7);
  addEdge(5, 7);
  addEdge(5, 8);
  addEdge(6, 8);
  addEdge(7, 8);
}

void addEdge(int a, int b) {
  graph[a][b] = true;
  graph[b][a] = true;
}

void beginSearch(String selectedMode) {
  mode = selectedMode;
  steps.clear();
  for (int i = 0; i < V; i++) {
    parent[i] = -1;
    visitRank[i] = -1;
  }

  if (mode.equals("BFS")) {
    buildBFS();
  } else {
    boolean[] visited = new boolean[V];
    ArrayList<Integer> callStack = new ArrayList<Integer>();
    buildDFS(startVertex, visited, callStack);
  }

  currentStep = 0;
  playing = true;
  lastTick = millis();
  print(mode + " : ");
  for (int i = 0; i < steps.size(); i++) {
    print((steps.get(i).vertex + 1) + (i == steps.size() - 1 ? "" : " -> "));
  }
  println();
}

void buildBFS() {
  boolean[] discovered = new boolean[V];
  ArrayList<Integer> queue = new ArrayList<Integer>();
  queue.add(startVertex);
  discovered[startVertex] = true;

  while (!queue.isEmpty()) {
    int v = queue.remove(0);
    visitRank[v] = steps.size();

    for (int next = 0; next < V; next++) {
      if (graph[v][next] && !discovered[next]) {
        discovered[next] = true;
        parent[next] = v;
        queue.add(next);
      }
    }
    steps.add(new SearchStep(v, queue));
  }
}

void buildDFS(int v, boolean[] visited, ArrayList<Integer> callStack) {
  visited[v] = true;
  visitRank[v] = steps.size();
  callStack.add(v);
  steps.add(new SearchStep(v, callStack));

  for (int next = 0; next < V; next++) {
    if (graph[v][next] && !visited[next]) {
      parent[next] = v;
      buildDFS(next, visited, callStack);
    }
  }
  callStack.remove(callStack.size() - 1);
}

void resetSearch() {
  mode = "";
  steps.clear();
  currentStep = -1;
  playing = false;
  for (int i = 0; i < V; i++) {
    parent[i] = -1;
    visitRank[i] = -1;
  }
}

void draw() {
  background(15, 21, 34);
  scale(width / 1320.0f, height / 760.0f);

  if (playing && currentStep < steps.size() - 1 && millis() - lastTick >= interval) {
    currentStep++;
    lastTick = millis();
    if (currentStep == steps.size() - 1) playing = false;
  }

  drawHeader();
  drawGraph();
  drawPanel();
}

void drawHeader() {
  noStroke();
  fill(241, 248, 255);
  textAlign(LEFT, BASELINE);
  textSize(27);
  text("GRAPH SEARCH", 34, 47);
  fill(123, 176, 195);
  textSize(13);
  text("BFS / DFS  |  Undirected graph  |  " + V + " vertices", 36, 74);

  fill(178, 194, 216);
  textSize(13);
  textAlign(RIGHT, BASELINE);
  text("B  BFS     D  DFS     SPACE  Play/Pause     LEFT/RIGHT  Step     F  Finish     R  Reset     +/-  Speed", 1280, 54);
  textAlign(LEFT, BASELINE);
}

void drawGraph() {
  noStroke();
  fill(22, 32, 49);
  rect(26, 108, 846, 625, 16);
  fill(139, 157, 182);
  textSize(13);
  text("GRAPH  /  CLICK A VERTEX TO CHANGE START", 48, 137);

  stroke(66, 83, 105);
  strokeWeight(2);
  for (int a = 0; a < V; a++) {
    for (int b = a + 1; b < V; b++) {
      if (graph[a][b]) {
        line(pos[a][0], pos[a][1], pos[b][0], pos[b][1]);
      }
    }
  }

  for (int v = 0; v < V; v++) {
    if (parent[v] >= 0 && visitRank[v] >= 0 && visitRank[v] <= currentStep) {
      stroke(40, 188, 168);
      strokeWeight(4);
      line(pos[parent[v]][0], pos[parent[v]][1], pos[v][0], pos[v][1]);
    }
  }

  int active = -1;
  if (currentStep >= 0 && currentStep < steps.size()) {
    active = steps.get(currentStep).vertex;
  }
  if (active >= 0 && parent[active] >= 0) {
    stroke(255, 199, 83);
    strokeWeight(5);
    line(pos[parent[active]][0], pos[parent[active]][1], pos[active][0], pos[active][1]);
  }

  for (int v = 0; v < V; v++) {
    boolean visited = visitRank[v] >= 0 && visitRank[v] <= currentStep;
    boolean current = v == active;

    if (v == startVertex) {
      noFill();
      stroke(110, 222, 221);
      strokeWeight(2);
      ellipse(pos[v][0], pos[v][1], 70, 70);
    }

    noStroke();
    if (current) fill(255, 194, 73);
    else if (visited) fill(29, 175, 158);
    else fill(47, 67, 94);
    ellipse(pos[v][0], pos[v][1], 52, 52);

    fill(current ? color(35, 41, 53) : color(244, 251, 255));
    textAlign(CENTER, CENTER);
    textSize(19);
    text(v + 1, pos[v][0], pos[v][1] - 1);

    if (visited) {
      fill(223, 239, 250);
      textSize(12);
      text("#" + (visitRank[v] + 1), pos[v][0] + 32, pos[v][1] - 25);
    }
  }

  fill(148, 166, 187);
  textAlign(LEFT, BASELINE);
  textSize(12);
  text("START", 52, 699);
  fill(110, 222, 221);
  text("VERTEX " + (startVertex + 1), 100, 699);
}

void drawPanel() {
  int x = 892;
  noStroke();
  fill(22, 32, 49);
  rect(x, 108, 399, 625, 16);

  textAlign(LEFT, BASELINE);
  textSize(14);
  fill(137, 159, 185);
  text("ALGORITHM", x + 24, 149);
  fill(238, 248, 255);
  textSize(28);
  text(mode.equals("") ? "READY" : mode, x + 24, 185);

  fill(136, 157, 179);
  textSize(13);
  text("CURRENT VERTEX", x + 24, 229);
  fill(255, 198, 82);
  textSize(25);
  String current = currentStep >= 0 && currentStep < steps.size() ? "" + (steps.get(currentStep).vertex + 1) : "-";
  text(current, x + 24, 264);

  fill(137, 159, 185);
  textSize(13);
  text("PROGRESS", x + 160, 229);
  fill(236, 246, 255);
  textSize(20);
  int count = currentStep < 0 ? 0 : currentStep + 1;
  text(count + " / " + V, x + 160, 263);

  fill(48, 68, 85);
  rect(x + 24, 283, 350, 8, 5);
  fill(36, 183, 163);
  rect(x + 24, 283, 350.0f * count / V, 8, 5);

  fill(137, 159, 185);
  textSize(13);
  text("VISIT ORDER", x + 24, 340);
  fill(238, 248, 255);
  textSize(17);
  text(orderString(), x + 24, 358, 348, 80);

  fill(137, 159, 185);
  textSize(13);
  text(mode.equals("DFS") ? "RECURSION STACK" : "QUEUE (FRONT FIRST)", x + 24, 475);
  fill(31, 47, 66);
  rect(x + 24, 489, 350, 53, 10);
  fill(174, 242, 226);
  textSize(17);
  text(frontierString(), x + 38, 507, 320, 43);

  fill(137, 159, 185);
  textSize(13);
  text("HOW IT WORKS", x + 24, 589);
  fill(222, 233, 247);
  textSize(14);
  if (mode.equals("BFS")) {
    text("BFS explores one level at a time.\nIt uses a FIFO queue.", x + 24, 602, 350, 57);
  } else if (mode.equals("DFS")) {
    text("DFS follows a path as far as possible.\nIt uses recursion (call stack).", x + 24, 602, 350, 57);
  } else {
    text("Press B or D to start exploring.\nClick a node to select a new start.", x + 24, 602, 350, 57);
  }

  fill(122, 144, 166);
  textSize(12);
  text("STEP DELAY  " + interval + " ms", x + 24, 691);
  text("TIME  O(V + E)", x + 222, 691);
}

String orderString() {
  if (currentStep < 0) return "Press B or D to begin";
  String result = "";
  for (int i = 0; i <= currentStep; i++) {
    if (i > 0) result += i == 5 ? "\n" : "  >  ";
    result += steps.get(i).vertex + 1;
  }
  return result;
}

String frontierString() {
  if (currentStep < 0) return "[ ]";
  int[] items = steps.get(currentStep).frontier;
  if (items.length == 0) return "[ empty ]";
  String result = "[ ";
  for (int i = 0; i < items.length; i++) {
    if (i > 0) result += ", ";
    result += (items[i] + 1);
  }
  return result + " ]";
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      playing = false;
      if (currentStep < steps.size() - 1) currentStep++;
    } else if (keyCode == LEFT) {
      playing = false;
      if (currentStep > 0) currentStep--;
    }
    return;
  }

  if (key == 'b' || key == 'B') beginSearch("BFS");
  else if (key == 'd' || key == 'D') beginSearch("DFS");
  else if (key == 'r' || key == 'R') resetSearch();
  else if (key == 'f' || key == 'F') {
    if (!steps.isEmpty()) currentStep = steps.size() - 1;
    playing = false;
  } else if (key == ' ') {
    if (steps.isEmpty()) beginSearch("BFS");
    else {
      if (currentStep >= steps.size() - 1) currentStep = -1;
      playing = !playing;
      lastTick = millis();
    }
  } else if (key == '+' || key == '=') interval = max(150, interval - 100);
  else if (key == '-' || key == '_') interval = min(1800, interval + 100);
}

void mousePressed() {
  for (int v = 0; v < V; v++) {
    if (dist(mouseX * 1320.0f / width, mouseY * 760.0f / height, pos[v][0], pos[v][1]) <= 29) {
      startVertex = v;
      if (mode.equals("BFS")) beginSearch("BFS");
      else if (mode.equals("DFS")) beginSearch("DFS");
      else resetSearch();
      return;
    }
  }
}
