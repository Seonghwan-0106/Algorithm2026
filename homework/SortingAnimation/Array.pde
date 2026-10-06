class SortArray {
  int i0, j0, len, max;
  int[] arr;

  SortArray(int len, int i0, int j0) {
    max = 100;
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;
    arr = new int[len];
    shuffle();
  }

  SortArray(int len, int[] arr, int i0, int j0) {
    max = 100;
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;
    this.arr = new int[len];

    for (int i=0; i<len; i++) {
      this.arr[i] = arr[i];
    }
  }

  void draw() {
    float left = 32;
    float right = width - 32;
    float top = 92;
    float bottom = height - 76;
    float gap = 5;
    float w = (right-left)/len;

    noStroke();

    for (int i=0; i<len; i++) {
      float h = map(arr[i], 0, max, 8, bottom-top);
      float x = left + i*w + gap/2;
      float y = bottom-h;

      if (i == i0 || i == j0) {
        fill(255, 196, 74);
      } else {
        fill(94, 214, 255);
      }

      rect(x, y, w-gap, h, 7, 7, 2, 2);
    }
  }

  void shuffle() {
    for (int i=0; i<len; i++) {
      arr[i] = (int)random(8, max);
    }
  }

  void printArray() {
    print("("+nf(i0, 2)+","+nf(j0, 2)+")- ");

    for (int i=0; i<len; i++) {
      print(nf(arr[i], 2)+" ");
    }

    println();
  }
}
