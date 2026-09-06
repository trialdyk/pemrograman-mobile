void main(List<String> args) {
  int i = 0;

  for (;;) {
    if (i == 5) {
      break;
    }
    print("perulangan ke ${i + 1}");
    i++;
  }

  for (int j = 1; j < 10; j++) {
    if (j % 2 == 0) {
      continue;
    }
    print(j);
  }
}
