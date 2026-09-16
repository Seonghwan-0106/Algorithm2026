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

// Insertion Sort
for (int i = 1; i < list.length; i++) {
  int key = list[i];
  int j = i - 1;

  while (j >= 0 && list[j] > key) {
    list[j + 1] = list[j];
    j--;
  }

  list[j + 1] = key;
}

println("정렬 후");
for (int i = 0; i < list.length; i++) {
  print(list[i] + " ");
}
