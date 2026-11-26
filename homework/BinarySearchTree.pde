import java.util.ArrayList;
import java.util.Collections;

BSTNode root;
ArrayList<Integer> traversal = new ArrayList<Integer>();
ArrayList<Integer> searchPath = new ArrayList<Integer>();
String traversalMode = "INORDER";
String editMode = "";
String typedNumber = "";
String statusText = "Ready. Select a command to begin.";
int traversalStep = -1;
int interval = 700;
int lastTick = 0;
int nodeCount = 0;
boolean playing = false;
PFont uiFont;
float nodeRadius = 22;

class BSTNode {
  int value;
  BSTNode left;
  BSTNode right;
  float x;
  float y;

  BSTNode(int value) {
    this.value = value;
  }
}

void setup() {
  size(1200, 760);
  smooth(8);
  uiFont = createFont("SansSerif", 17);
  textFont(uiFont);
  exampleTree();
}

void draw() {
  background(15, 21, 34);

  if (playing && millis() - lastTick >= interval) {
    if (traversalStep < traversal.size() - 1) {
      traversalStep++;
      lastTick = millis();
    } else {
      playing = false;
    }
  }

  drawHeader();
  drawTreePanel();
  drawInfoPanel();
  drawFooter();
}

void exampleTree() {
  root = null;
  int[] values = {43, 21, 66, 14, 32, 55, 78, 9, 18, 27, 38};
  for (int v : values) root = insertNode(root, v);
  updateTraversal();
  statusText = "Example tree loaded (11 nodes).";
}

void randomTree() {
  root = null;
  ArrayList<Integer> values = new ArrayList<Integer>();
  for (int i = 1; i <= 99; i++) values.add(i);
  Collections.shuffle(values);
  for (int i = 0; i < 10; i++) root = insertNode(root, values.get(i));
  updateTraversal();
  statusText = "New random tree generated.";
}

BSTNode insertNode(BSTNode node, int value) {
  if (node == null) return new BSTNode(value);
  if (value < node.value) node.left = insertNode(node.left, value);
  else if (value > node.value) node.right = insertNode(node.right, value);
  return node;
}

BSTNode removeNode(BSTNode node, int value) {
  if (node == null) return null;
  if (value < node.value) node.left = removeNode(node.left, value);
  else if (value > node.value) node.right = removeNode(node.right, value);
  else {
    if (node.left == null) return node.right;
    if (node.right == null) return node.left;
    BSTNode successor = node.right;
    while (successor.left != null) successor = successor.left;
    node.value = successor.value;
    node.right = removeNode(node.right, successor.value);
  }
  return node;
}

boolean contains(BSTNode node, int value) {
  while (node != null) {
    if (value == node.value) return true;
    node = value < node.value ? node.left : node.right;
  }
  return false;
}

void findPath(int value) {
  searchPath.clear();
  BSTNode node = root;
  while (node != null) {
    searchPath.add(node.value);
    if (node.value == value) return;
    node = value < node.value ? node.left : node.right;
  }
}

void updateTraversal() {
  traversal.clear();
  collectTraversal(root);
  traversalStep = -1;
  playing = false;
  searchPath.clear();
  nodeCount = countNodes(root);
}

void collectTraversal(BSTNode node) {
  if (node == null) return;
  if (traversalMode.equals("PREORDER")) traversal.add(node.value);
  collectTraversal(node.left);
  if (traversalMode.equals("INORDER")) traversal.add(node.value);
  collectTraversal(node.right);
  if (traversalMode.equals("POSTORDER")) traversal.add(node.value);
}

int countNodes(BSTNode node) {
  if (node == null) return 0;
  return 1 + countNodes(node.left) + countNodes(node.right);
}

int treeDepth(BSTNode node) {
  if (node == null) return 0;
  return 1 + max(treeDepth(node.left), treeDepth(node.right));
}

void positionTree() {
  if (root == null) return;
  int depth = treeDepth(root);
  nodeRadius = max(12, min(22, 25 - max(0, depth - 6)));
  int[] index = {0};
  float stepX = min(85, 710.0f / max(1, nodeCount - 1));
  float leftX = 420 - (nodeCount - 1) * stepX * 0.5f;
  float stepY = min(74, 400.0f / max(1, depth - 1));
  assignPosition(root, 0, index, leftX, stepX, stepY);
}

void assignPosition(BSTNode node, int depth, int[] index, float leftX, float stepX, float stepY) {
  if (node == null) return;
  assignPosition(node.left, depth + 1, index, leftX, stepX, stepY);
  node.x = leftX + index[0] * stepX;
  node.y = 184 + depth * stepY;
  index[0]++;
  assignPosition(node.right, depth + 1, index, leftX, stepX, stepY);
}

void drawHeader() {
  fill(241, 246, 255);
  textAlign(LEFT, BASELINE);
  textSize(29);
  text("BINARY SEARCH TREE", 30, 47);
  fill(133, 153, 179);
  textSize(14);
  text("HOMEWORK 3  /  INSERT  DELETE  SEARCH  INORDER  PREORDER  POSTORDER", 32, 77);
}

void drawTreePanel() {
  noStroke();
  fill(24, 34, 52);
  rect(20, 100, 810, 527, 17);
  fill(182, 202, 225);
  textSize(17);
  textAlign(LEFT, BASELINE);
  text("TREE VIEW", 43, 137);

  if (root == null) {
    fill(119, 142, 166);
    textAlign(CENTER, CENTER);
    text("Empty tree  |  Press I to insert a value", 424, 360);
    return;
  }

  positionTree();
  drawEdges(root);
  drawNodes(root);
}

void drawEdges(BSTNode node) {
  if (node == null) return;
  stroke(98, 117, 147);
  strokeWeight(2.5f);
  if (node.left != null) line(node.x, node.y, node.left.x, node.left.y);
  if (node.right != null) line(node.x, node.y, node.right.x, node.right.y);
  drawEdges(node.left);
  drawEdges(node.right);
}

void drawNodes(BSTNode node) {
  if (node == null) return;
  drawNodes(node.left);
  drawNodes(node.right);

  int rank = traversal.indexOf(node.value);
  boolean visited = traversalStep >= 0 && rank >= 0 && rank <= traversalStep;
  boolean current = traversalStep >= 0 && rank == traversalStep;
  boolean searched = searchPath.contains(node.value);
  boolean target = searched && searchPath.get(searchPath.size() - 1) == node.value;

  noStroke();
  if (current || target) fill(255, 194, 80);
  else if (visited) fill(42, 193, 169);
  else if (searched) fill(79, 135, 206);
  else fill(48, 72, 106);
  ellipse(node.x, node.y, nodeRadius * 2, nodeRadius * 2);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(nodeRadius < 17 ? 12 : 16);
  text(node.value, node.x, node.y - 1);
}

void drawInfoPanel() {
  noStroke();
  fill(24, 34, 52);
  rect(849, 100, 331, 527, 17);
  textAlign(LEFT, BASELINE);
  fill(182, 202, 225);
  textSize(17);
  text("TRAVERSAL", 872, 139);
  fill(42, 193, 169);
  textSize(22);
  text(traversalMode, 872, 175);

  fill(145, 165, 188);
  textSize(14);
  text("Nodes: " + nodeCount + "    Height: " + max(0, treeDepth(root) - 1), 872, 211);
  text("Visited: " + max(0, traversalStep + 1) + " / " + traversal.size(), 872, 238);

  fill(182, 202, 225);
  textSize(16);
  text("VISIT ORDER", 872, 278);
  fill(228, 236, 247);
  textSize(16);
  text(joinValues(traversal), 872, 293, 284, 110);

  fill(182, 202, 225);
  textSize(16);
  text("CURRENT ACTION", 872, 429);
  fill(242, 247, 255);
  textSize(14);
  text(statusText, 872, 443, 284, 75);

  fill(145, 165, 188);
  textSize(14);
  text("Input (0-999): " + (editMode.length() > 0 ? editMode + " > " + typedNumber + "_" : "-"), 872, 561);
  fill(118, 137, 159);
  text("Yellow: current   Teal: visited", 872, 594);
}

String joinValues(ArrayList<Integer> values) {
  if (values.isEmpty()) return "(empty)";
  String result = "";
  for (int i = 0; i < values.size(); i++) {
    if (i > 0) result += "  >  ";
    result += values.get(i);
  }
  return result;
}

void drawFooter() {
  noStroke();
  fill(24, 34, 52);
  rect(20, 644, 1160, 93, 17);
  textAlign(LEFT, BASELINE);
  fill(228, 236, 247);
  textSize(15);
  text("I Insert    D Delete    F Find    Q Inorder    W Preorder    E Postorder    N Random    R Example    C Clear", 38, 680);
  fill(135, 158, 183);
  textSize(14);
  text("Enter Apply    Backspace Edit    Space Play/Pause    Left/Right Step    A/S Speed", 38, 714);
}

void executeEdit() {
  if (editMode.length() == 0 || typedNumber.length() == 0) return;
  int value = Integer.parseInt(typedNumber);
  String op = editMode;
  editMode = "";
  typedNumber = "";

  if (op.equals("INSERT")) {
    if (contains(root, value)) statusText = value + " already exists.";
    else if (countNodes(root) >= 18) statusText = "Maximum of 18 nodes reached.";
    else {
      root = insertNode(root, value);
      updateTraversal();
      statusText = "Inserted " + value + ".";
    }
  } else if (op.equals("DELETE")) {
    if (!contains(root, value)) statusText = value + " was not found.";
    else {
      root = removeNode(root, value);
      updateTraversal();
      statusText = "Deleted " + value + ".";
    }
  } else if (op.equals("FIND")) {
    traversalStep = -1;
    playing = false;
    findPath(value);
    statusText = contains(root, value) ? "Found " + value + "!" : value + " was not found.";
    println("Search " + value + ": " + joinValues(searchPath));
  }
}

void changeTraversal(String selected) {
  traversalMode = selected;
  updateTraversal();
  playing = !traversal.isEmpty();
  lastTick = millis();
  statusText = selected + " traversal started.";
  println(selected + ": " + joinValues(traversal));
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      playing = false;
      traversalStep = min(traversal.size() - 1, traversalStep + 1);
    } else if (keyCode == LEFT) {
      playing = false;
      traversalStep = max(-1, traversalStep - 1);
    }
    return;
  }

  if (editMode.length() > 0) {
    if (key >= '0' && key <= '9' && typedNumber.length() < 3) typedNumber += key;
    else if (key == BACKSPACE && typedNumber.length() > 0) typedNumber = typedNumber.substring(0, typedNumber.length() - 1);
    else if (key == ENTER || key == RETURN) executeEdit();
    else if (key == ESC) {
      key = 0;
      editMode = "";
      typedNumber = "";
      statusText = "Action cancelled.";
    }
    return;
  }

  char k = Character.toUpperCase(key);
  if (k == 'I' || k == 'D' || k == 'F') {
    editMode = k == 'I' ? "INSERT" : k == 'D' ? "DELETE" : "FIND";
    typedNumber = "";
    playing = false;
    statusText = "Enter a value, then press Enter.";
  } else if (k == 'Q') changeTraversal("INORDER");
  else if (k == 'W') changeTraversal("PREORDER");
  else if (k == 'E') changeTraversal("POSTORDER");
  else if (k == 'N') randomTree();
  else if (k == 'R') exampleTree();
  else if (k == 'C') {
    root = null;
    updateTraversal();
    statusText = "Tree cleared.";
  } else if (key == ' ') {
    if (traversalStep == traversal.size() - 1) traversalStep = -1;
    playing = !playing && !traversal.isEmpty();
    lastTick = millis();
  } else if (k == 'A') interval = min(2000, interval + 100);
  else if (k == 'S') interval = max(100, interval - 100);
}
