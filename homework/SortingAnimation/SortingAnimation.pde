ArrayList<Array> lists;
Array list, plist;
int type = 0;
int napTime = 180;
int len = 16;
int index = 0;
int loop = 0;
boolean autoFlag = true;
String[] titles = {"Selection Sort", "Bubble Sort", "Insertion Sort", "Merge Sort", "Quick Sort", "Heap Sort"};
int[] seed;

void setup() {
  size(900, 600);
  smooth(8);
  textFont(createFont("Arial", 20));
  makeSeed();
  run(type);
}

void draw() {
  background(12, 18, 30);

  list = lists.get(index);
  list.draw();

  fill(238, 244, 255);
  textSize(26);
  text(titles[type], 30, 42);

  fill(145, 158, 180);
  textSize(14);
  text("SPACE  play/pause     A/S  speed     Z/X  sort     LEFT/RIGHT  step     R  new data", 30, 68);

  fill(238, 244, 255);
  textSize(15);
  text("Step " + index + " / " + loop, 30, height-28);
  text("Delay " + napTime + " ms", width-145, height-28);

  if (autoFlag && frameCount % max(1, napTime/16) == 0) nextStep();
}

void nextStep() {
  if (index < loop) index++;
  else index = 0;
}

void keyPressed() {
  if (key == ' ') {
    autoFlag = !autoFlag;
  }
  else if (key == 'a' || key == 'A') {
    napTime = max(32, napTime-32);
  }
  else if (key == 's' || key == 'S') {
    napTime = min(1000, napTime+32);
  }
  else if (key == 'z' || key == 'Z') {
    type--;
    if (type < 0) type = titles.length-1;
    run(type);
  }
  else if (key == 'x' || key == 'X') {
    type++;
    if (type >= titles.length) type = 0;
    run(type);
  }
  else if (key == 'r' || key == 'R') {
    makeSeed();
    run(type);
  }
  else if (key == CODED) {
    autoFlag = false;
    if (keyCode == LEFT && index > 0) index--;
    else if (keyCode == RIGHT && index < loop) index++;
  }
}

void mousePressed() {
  autoFlag = false;
  if (mouseButton == LEFT && index > 0) index--;
  else if (mouseButton == RIGHT && index < loop) index++;
}

void makeSeed() {
  seed = new int[len];
  for (int i=0; i<len; i++) seed[i] = (int)random(8, 100);
}

void run(int type) {
  loop = index = 0;
  lists = new ArrayList<Array>();
  lists.add(new Array(len, seed, -1, -1));

  if (type == 0) selectionSort();
  else if (type == 1) bubbleSort();
  else if (type == 2) insertionSort();
  else if (type == 3) mergeSort();
  else if (type == 4) quickSort();
  else if (type == 5) heapSort();
}

void addState(int[] arr, int i, int j) {
  lists.add(new Array(len, arr, i, j));
  loop++;
}

void selectionSort() {
  int[] a = seed.clone();
  for (int end=len-1; end>0; end--) {
    int maxIndex = 0;
    for (int j=1; j<=end; j++) {
      if (a[j] > a[maxIndex]) maxIndex = j;
    }
    swap(a, maxIndex, end);
    addState(a, maxIndex, end);
  }
}

void bubbleSort() {
  int[] a = seed.clone();
  for (int end=len-1; end>0; end--) {
    for (int i=0; i<end; i++) {
      if (a[i] > a[i+1]) swap(a, i, i+1);
      addState(a, i, i+1);
    }
  }
}

void insertionSort() {
  int[] a = seed.clone();
  for (int i=1; i<len; i++) {
    int key = a[i];
    int j = i-1;
    while (j>=0 && a[j] > key) {
      a[j+1] = a[j];
      addState(a, j, j+1);
      j--;
    }
    a[j+1] = key;
    addState(a, j+1, i);
  }
}

void mergeSort() {
  int[] a = seed.clone();
  mergeSort(a, 0, len-1);
}

void mergeSort(int[] a, int low, int high) {
  if (low >= high) return;
  int mid = (low+high)/2;
  mergeSort(a, low, mid);
  mergeSort(a, mid+1, high);
  merge(a, low, mid, high);
}

void merge(int[] a, int low, int mid, int high) {
  int[] temp = new int[high-low+1];
  int i=low, j=mid+1, k=0;

  while (i<=mid && j<=high) {
    if (a[i] <= a[j]) temp[k++] = a[i++];
    else temp[k++] = a[j++];
  }
  while (i<=mid) temp[k++] = a[i++];
  while (j<=high) temp[k++] = a[j++];

  for (int n=0; n<temp.length; n++) {
    a[low+n] = temp[n];
    addState(a, low+n, high);
  }
}

void quickSort() {
  int[] a = seed.clone();
  quickSort(a, 0, len-1);
}

void quickSort(int[] a, int low, int high) {
  if (low >= high) return;
  int p = partition(a, low, high);
  quickSort(a, low, p-1);
  quickSort(a, p+1, high);
}

int partition(int[] a, int low, int high) {
  int pivot = a[high];
  int i = low-1;

  for (int j=low; j<high; j++) {
    if (a[j] <= pivot) {
      i++;
      swap(a, i, j);
      addState(a, i, j);
    } else {
      addState(a, j, high);
    }
  }

  swap(a, i+1, high);
  addState(a, i+1, high);
  return i+1;
}

void heapSort() {
  int[] a = seed.clone();

  for (int i=len/2-1; i>=0; i--) heapify(a, len, i);

  for (int end=len-1; end>0; end--) {
    swap(a, 0, end);
    addState(a, 0, end);
    heapify(a, end, 0);
  }
}

void heapify(int[] a, int n, int root) {
  int largest = root;
  int left = 2*root+1;
  int right = 2*root+2;

  if (left<n && a[left] > a[largest]) largest = left;
  if (right<n && a[right] > a[largest]) largest = right;

  if (largest != root) {
    swap(a, root, largest);
    addState(a, root, largest);
    heapify(a, n, largest);
  }
}

void swap(int[] arr, int i, int j) {
  int tmp = arr[i];
  arr[i] = arr[j];
  arr[j] = tmp;
}
