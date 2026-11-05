int cnt = 5;
int[][] value = new int[4][cnt];
int[][] dp = new int[4][cnt];

void setup() {
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < cnt; col++) {
      value[row][col] = (int)random(-10, 16);
    }
  }

  for (int col = 0; col < cnt; col++) {
    value[3][col] = value[0][col] + value[2][col];
  }

  for (int p = 0; p < 4; p++) {
    dp[p][0] = value[p][0];
  }

  for (int col = 1; col < cnt; col++) {
    dp[0][col] = max(dp[1][col - 1], dp[2][col - 1]) + value[0][col];
    dp[1][col] = max(max(dp[0][col - 1], dp[2][col - 1]), dp[3][col - 1]) + value[1][col];
    dp[2][col] = max(dp[0][col - 1], dp[1][col - 1]) + value[2][col];
    dp[3][col] = dp[1][col - 1] + value[3][col];
  }

  for (int p = 0; p < 4; p++) {
    for (int col = 0; col < cnt; col++) {
      print(String.format("%+05d ", dp[p][col]));
    }
    println();
  }

  int answer = dp[0][cnt - 1];
  for (int p = 1; p < 4; p++) {
    answer = max(answer, dp[p][cnt - 1]);
  }
  println(answer);
}
