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

  // Heap Sort 실행
  heapSort(list);

  println("정렬 후");
  for (int i = 0; i < list.length; i++) {
    print(list[i] + " ");
  }
  println();
}


// Heap Sort
void heapSort(int[] list) {

  int n = list.length;

  // Max Heap 만들기
  for (int i = n / 2 - 1; i >= 0; i--) {
    heapify(list, n, i);
  }

  // 가장 큰 값을 뒤로 보내기
  for (int i = n - 1; i > 0; i--) {

    int temp = list[0];
    list[0] = list[i];
    list[i] = temp;

    heapify(list, i, 0);
  }
}


// Heapify
void heapify(int[] list, int n, int i) {

  int largest = i;

  int left = 2 * i + 1;
  int right = 2 * i + 2;

  // 왼쪽 자식이 더 큰지 확인
  if (left < n && list[left] > list[largest]) {
    largest = left;
  }

  // 오른쪽 자식이 더 큰지 확인
  if (right < n && list[right] > list[largest]) {
    largest = right;
  }

  // 가장 큰 값이 부모가 아니라면 교환
  if (largest != i) {

    int temp = list[i];
    list[i] = list[largest];
    list[largest] = temp;

    heapify(list, n, largest);
  }
}
