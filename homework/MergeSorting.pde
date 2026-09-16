int[] list = new int[5];

void setup() {

  // 랜덤 숫자 5개 생성
  for (int i = 0; i < list.length; i++) {
    list[i] = (int)random(1000);
  }

  println("정렬 전");
  for (int i = 0; i < list.length; i++) {
    print(list[i] + " ");
  }
  println();

  // Merge Sort 실행
  mergeSort(list, 0, list.length - 1);

  println("정렬 후");
  for (int i = 0; i < list.length; i++) {
    print(list[i] + " ");
  }
  println();
}


// Merge Sort
void mergeSort(int[] list, int left, int right) {

  if (left < right) {

    int mid = (left + right) / 2;

    mergeSort(list, left, mid);
    mergeSort(list, mid + 1, right);

    merge(list, left, mid, right);
  }
}


// Merge
void merge(int[] list, int left, int mid, int right) {

  int[] temp = new int[right - left + 1];

  int i = left;
  int j = mid + 1;
  int k = 0;

  while (i <= mid && j <= right) {

    if (list[i] <= list[j]) {
      temp[k] = list[i];
      i++;
    } else {
      temp[k] = list[j];
      j++;
    }

    k++;
  }

  while (i <= mid) {
    temp[k] = list[i];
    i++;
    k++;
  }

  while (j <= right) {
    temp[k] = list[j];
    j++;
    k++;
  }

  for (int n = 0; n < temp.length; n++) {
    list[left + n] = temp[n];
  }
}
