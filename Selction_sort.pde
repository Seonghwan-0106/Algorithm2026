int[] list = new int[5];

// 랜덤 숫자 5개 생성 (0~999)
for (int i = 0; i < list.length; i++) {
  list[i] = (int)random(1000);
}

println("정렬 전");
for (int i = 0; i < list.length; i++) {
  print(list[i] + " ");
}
println();

// Selection Sort
for (int i = 0; i < list.length - 1; i++) {

  int minIndex = i;

  for (int j = i + 1; j < list.length; j++) {
    if (list[j] < list[minIndex]) {
      minIndex = j;
    }
  }

  int temp = list[i];
  list[i] = list[minIndex];
  list[minIndex] = temp;
}

println("정렬 후");
for (int i = 0; i < list.length; i++) {
  print(list[i] + " ");
}
