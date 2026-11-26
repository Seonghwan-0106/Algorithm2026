import java.util.ArrayList;
import java.util.Locale;

String expression = "12+(3*4)-5";
String postfixResult = "";
String numericResult = "";
String statusText = "Press ENTER to convert an expression.";
ArrayList<String> tokens = new ArrayList<String>();
ArrayList<CalcFrame> frames = new ArrayList<CalcFrame>();
int currentFrame = -1;
int interval = 680;
int lastTick = 0;
boolean playing = false;
PFont uiFont;

class CalcFrame {
  String token;
  String action;
  int tokenIndex;
  ArrayList<String> operators;
  ArrayList<String> output;

  CalcFrame(String t, String a, int i, ArrayList<String> stack, ArrayList<String> postfix) {
    token = t;
    action = a;
    tokenIndex = i;
    operators = new ArrayList<String>(stack);
    output = new ArrayList<String>(postfix);
  }
}

void setup() {
  size(1200, 760);
  smooth(8);
  uiFont = createFont("SansSerif", 17);
  textFont(uiFont);
  convertExpression();
}

void draw() {
  background(15, 21, 34);

  if (playing && millis() - lastTick >= interval) {
    if (currentFrame < frames.size() - 1) {
      currentFrame++;
      lastTick = millis();
    } else playing = false;
  }

  drawHeader();
  drawExpression();
  drawProcess();
  drawStack();
  drawResults();
}

void drawHeader() {
  textAlign(LEFT, BASELINE);
  fill(241, 246, 255);
  textSize(27);
  text("INFIX TO POSTFIX", 34, 48);
  fill(130, 153, 179);
  textSize(14);
  text("HOMEWORK 4  /  STACK  /  SHUNTING-YARD ALGORITHM  /  CALCULATOR", 36, 77);
}

void drawExpression() {
  noStroke();
  fill(24, 34, 52);
  rect(24, 100, 1152, 104, 17);
  fill(158, 180, 205);
  textSize(15);
  textAlign(LEFT, BASELINE);
  text("INFIX EXPRESSION  (type numbers and + - * / % ^ ( ))", 47, 131);
  fill(244, 249, 255);
  textSize(27);
  text(expression.length() == 0 ? "_" : expression, 47, 177);
}

void drawProcess() {
  noStroke();
  fill(24, 34, 52);
  rect(24, 220, 747, 370, 17);
  fill(185, 204, 227);
  textAlign(LEFT, BASELINE);
  textSize(18);
  text("CONVERSION PROCESS", 47, 256);

  if (frames.isEmpty()) {
    fill(130, 153, 179);
    textSize(16);
    text(statusText, 49, 313, 690, 85);
    return;
  }

  CalcFrame frame = frames.get(max(0, currentFrame));
  fill(129, 152, 175);
  textSize(15);
  text("TOKEN STREAM", 47, 296);
  drawTokenStream(frame.tokenIndex);

  fill(129, 152, 175);
  textSize(15);
  text("CURRENT ACTION", 47, 402);
  fill(242, 247, 255);
  textSize(18);
  text(frame.action, 47, 421, 690, 45);

  fill(129, 152, 175);
  textSize(15);
  text("POSTFIX OUTPUT", 47, 505);
  fill(43, 200, 173);
  textSize(19);
  String output = joinItems(frame.output);
  text(output.length() == 0 ? "(empty)" : output, 47, 518, 691, 65);
}

void drawTokenStream(int active) {
  int x = 47;
  int y = 315;
  textAlign(CENTER, CENTER);
  textSize(16);
  for (int i = 0; i < tokens.size(); i++) {
    String token = tokens.get(i);
    int chipW = max(43, (int)textWidth(token) + 22);
    if (x + chipW > 742) {
      x = 47;
      y += 45;
    }
    noStroke();
    if (i == active) fill(247, 187, 72);
    else if (i < active) fill(39, 126, 122);
    else fill(43, 60, 86);
    rect(x, y, chipW, 35, 8);
    fill(255);
    text(token, x + chipW / 2.0f, y + 17);
    x += chipW + 9;
  }
  textAlign(LEFT, BASELINE);
}

void drawStack() {
  noStroke();
  fill(24, 34, 52);
  rect(788, 220, 388, 370, 17);
  textAlign(LEFT, BASELINE);
  fill(185, 204, 227);
  textSize(18);
  text("OPERATOR STACK", 812, 256);
  fill(134, 157, 181);
  textSize(14);
  text("TOP", 814, 289);

  if (frames.isEmpty()) return;
  CalcFrame frame = frames.get(max(0, currentFrame));
  if (frame.operators.isEmpty()) {
    fill(135, 156, 182);
    textSize(16);
    text("(empty)", 812, 334);
  } else {
    for (int i = frame.operators.size() - 1; i >= 0; i--) {
      int slot = frame.operators.size() - 1 - i;
      float y = 307 + slot * 49;
      fill(slot == 0 ? color(255, 191, 79) : color(47, 75, 109));
      noStroke();
      rect(814, y, 337, 40, 9);
      fill(255);
      textSize(20);
      textAlign(CENTER, CENTER);
      text(frame.operators.get(i), 981, y + 20);
    }
    textAlign(LEFT, BASELINE);
  }

  fill(130, 153, 179);
  textSize(15);
  text("Step " + (max(0, currentFrame) + 1) + " / " + frames.size(), 814, 567);
}

void drawResults() {
  noStroke();
  fill(24, 34, 52);
  rect(24, 606, 1152, 130, 17);
  fill(177, 200, 224);
  textAlign(LEFT, BASELINE);
  textSize(15);
  text("POSTFIX", 47, 640);
  fill(234, 245, 254);
  textSize(20);
  boolean completed = !frames.isEmpty() && currentFrame == frames.size() - 1;
  text(completed ? postfixResult : "Finish the animation to see the result", 47, 668, 760, 34);

  fill(177, 200, 224);
  textSize(15);
  text("RESULT", 941, 639);
  fill(44, 203, 172);
  textSize(28);
  textAlign(RIGHT, BASELINE);
  text(completed ? numericResult : "-", 1144, 681);

  textAlign(LEFT, BASELINE);
  fill(125, 147, 174);
  textSize(13);
  text("ENTER Convert    SPACE Play/Pause    LEFT/RIGHT Step    F Finish    R Sample    C Clear    [ / ] Speed", 47, 717);
}

void captureFrame(String token, String action, int index, ArrayList<String> operators, ArrayList<String> output) {
  frames.add(new CalcFrame(token, action, index, operators, output));
}

ArrayList<String> tokenize(String input) {
  ArrayList<String> result = new ArrayList<String>();
  boolean expectOperand = true;
  int i = 0;

  while (i < input.length()) {
    char ch = input.charAt(i);
    if (Character.isWhitespace(ch)) {
      i++;
      continue;
    }

    boolean signed = ch == '-' && expectOperand && i + 1 < input.length() && (Character.isDigit(input.charAt(i + 1)) || input.charAt(i + 1) == '.');
    if (Character.isDigit(ch) || ch == '.' || signed) {
      if (!expectOperand) throw new RuntimeException("Missing operator before a number.");
      int start = i;
      if (signed) i++;
      boolean decimal = false;
      boolean digit = false;
      while (i < input.length()) {
        char d = input.charAt(i);
        if (Character.isDigit(d)) {
          digit = true;
          i++;
        } else if (d == '.' && !decimal) {
          decimal = true;
          i++;
        } else break;
      }
      if (!digit) throw new RuntimeException("Invalid number.");
      result.add(input.substring(start, i));
      expectOperand = false;
      continue;
    }

    if (ch == '(') {
      if (!expectOperand) throw new RuntimeException("Missing operator before '('.");
      result.add("(");
      expectOperand = true;
    } else if (ch == ')') {
      if (expectOperand) throw new RuntimeException("Unexpected ')'.");
      result.add(")");
      expectOperand = false;
    } else if (isOperator("" + ch)) {
      if (expectOperand) throw new RuntimeException("Expected a number before '" + ch + "'.");
      result.add("" + ch);
      expectOperand = true;
    } else throw new RuntimeException("Unsupported character: " + ch);
    i++;
  }

  if (result.isEmpty()) throw new RuntimeException("Enter an expression first.");
  if (expectOperand) throw new RuntimeException("Expression ends with an operator.");
  return result;
}

boolean isOperator(String t) {
  return t.equals("+") || t.equals("-") || t.equals("*") || t.equals("/") || t.equals("%") || t.equals("^");
}

int precedence(String operator) {
  if (operator.equals("^") ) return 3;
  if (operator.equals("*") || operator.equals("/") || operator.equals("%")) return 2;
  if (operator.equals("+") || operator.equals("-")) return 1;
  return 0;
}

void convertExpression() {
  frames.clear();
  postfixResult = "";
  numericResult = "";
  currentFrame = -1;
  playing = false;

  try {
    tokens = tokenize(expression);
    ArrayList<String> stack = new ArrayList<String>();
    ArrayList<String> output = new ArrayList<String>();

    for (int i = 0; i < tokens.size(); i++) {
      String token = tokens.get(i);
      if (!isOperator(token) && !token.equals("(") && !token.equals(")")) {
        output.add(token);
        captureFrame(token, "Send number " + token + " to postfix output", i, stack, output);
      } else if (token.equals("(")) {
        stack.add(token);
        captureFrame(token, "Push '(' onto operator stack", i, stack, output);
      } else if (token.equals(")")) {
        boolean matched = false;
        while (!stack.isEmpty()) {
          String top = stack.remove(stack.size() - 1);
          if (top.equals("(")) {
            matched = true;
            break;
          }
          output.add(top);
        }
        if (!matched) throw new RuntimeException("Unmatched closing parenthesis.");
        captureFrame(token, "Pop operators until '(' and discard parentheses", i, stack, output);
      } else {
        while (!stack.isEmpty() && isOperator(stack.get(stack.size() - 1))) {
          String top = stack.get(stack.size() - 1);
          boolean shouldPop = precedence(top) > precedence(token) || (precedence(top) == precedence(token) && !token.equals("^"));
          if (!shouldPop) break;
          output.add(stack.remove(stack.size() - 1));
        }
        stack.add(token);
        captureFrame(token, "Pop higher-priority operators, then push '" + token + "'", i, stack, output);
      }
    }

    while (!stack.isEmpty()) {
      String top = stack.remove(stack.size() - 1);
      if (top.equals("(")) throw new RuntimeException("Unmatched opening parenthesis.");
      output.add(top);
      captureFrame("END", "Move remaining operator '" + top + "' into postfix output", tokens.size() - 1, stack, output);
    }

    postfixResult = joinItems(output);
    numericResult = formatNumber(evaluate(output));
    captureFrame("DONE", "Conversion completed successfully", tokens.size() - 1, stack, output);
    currentFrame = 0;
    playing = true;
    lastTick = millis();
    statusText = "Conversion started.";
    println("Infix: " + expression);
    println("Postfix: " + postfixResult);
    println("Result: " + numericResult);
  } catch (RuntimeException error) {
    frames.clear();
    currentFrame = -1;
    playing = false;
    statusText = "ERROR: " + error.getMessage();
    println(statusText);
  }
}

double evaluate(ArrayList<String> postfix) {
  ArrayList<Double> stack = new ArrayList<Double>();
  for (String token : postfix) {
    if (!isOperator(token)) {
      stack.add(Double.parseDouble(token));
      continue;
    }
    if (stack.size() < 2) throw new RuntimeException("Invalid postfix expression.");
    double b = stack.remove(stack.size() - 1);
    double a = stack.remove(stack.size() - 1);
    double value = 0;
    if (token.equals("+")) value = a + b;
    else if (token.equals("-")) value = a - b;
    else if (token.equals("*")) value = a * b;
    else if (token.equals("/")) {
      if (b == 0) throw new RuntimeException("Division by zero.");
      value = a / b;
    } else if (token.equals("%")) {
      if (b == 0) throw new RuntimeException("Modulo by zero.");
      value = a % b;
    } else if (token.equals("^")) value = Math.pow(a, b);
    if (Double.isNaN(value) || Double.isInfinite(value)) throw new RuntimeException("Result is not finite.");
    stack.add(value);
  }
  if (stack.size() != 1) throw new RuntimeException("Invalid expression.");
  return stack.get(0);
}

String formatNumber(double value) {
  if (Math.abs(value) < 0.0000000001) value = 0;
  if (Math.abs(value) <= 1000000000 && Math.abs(value - Math.rint(value)) < 0.000000001) return "" + (long)Math.rint(value);
  return String.format(Locale.US, "%.4f", value);
}

String joinItems(ArrayList<String> items) {
  String result = "";
  for (int i = 0; i < items.size(); i++) {
    if (i > 0) result += " ";
    result += items.get(i);
  }
  return result;
}

void editExpression(String value) {
  expression = value;
  frames.clear();
  tokens.clear();
  currentFrame = -1;
  playing = false;
  postfixResult = "";
  numericResult = "";
  statusText = "Press ENTER to convert.";
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT && !frames.isEmpty()) {
      playing = false;
      currentFrame = min(frames.size() - 1, currentFrame + 1);
    } else if (keyCode == LEFT && !frames.isEmpty()) {
      playing = false;
      currentFrame = max(0, currentFrame - 1);
    }
    return;
  }

  if (key == ENTER || key == RETURN) {
    convertExpression();
    return;
  }
  if (key == BACKSPACE) {
    if (expression.length() > 0) editExpression(expression.substring(0, expression.length() - 1));
    return;
  }
  if (key == ' ') {
    if (!frames.isEmpty()) {
      if (currentFrame == frames.size() - 1) currentFrame = 0;
      playing = !playing;
      lastTick = millis();
    }
    return;
  }
  char k = Character.toUpperCase(key);
  if (k == 'R') {
    editExpression("12+(3*4)-5");
    convertExpression();
  } else if (k == 'C') editExpression("");
  else if (k == 'F' && !frames.isEmpty()) {
    currentFrame = frames.size() - 1;
    playing = false;
  } else if (key == '[') interval = min(2000, interval + 100);
  else if (key == ']') interval = max(100, interval - 100);
  else if ("0123456789+-*/%^().".indexOf(key) >= 0 && expression.length() < 42) editExpression(expression + key);
}
