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

  // Quick Sort 실행
  quickSort(list, 0, list.length - 1);

  println("정렬 후");
  for (int i = 0; i < list.length; i++) {
    print(list[i] + " ");
  }
  println();
}


// Quick Sort
void quickSort(int[] list, int low, int high) {

  if (low < high) {

    int pivot = partition(list, low, high);

    // pivot 왼쪽 정렬
    quickSort(list, low, pivot - 1);

    // pivot 오른쪽 정렬
    quickSort(list, pivot + 1, high);
  }
}


// Partition
int partition(int[] list, int low, int high) {

  // 마지막 값을 pivot으로 선택
  int pivot = list[high];

  int i = low - 1;

  for (int j = low; j < high; j++) {

    // pivot보다 작은 값이면 왼쪽으로 이동
    if (list[j] < pivot) {

      i++;

      int temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }

  // pivot을 알맞은 위치로 이동
  int temp = list[i + 1];
  list[i + 1] = list[high];
  list[high] = temp;

  return i + 1;
}
