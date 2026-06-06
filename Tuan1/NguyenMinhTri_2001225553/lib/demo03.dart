void demo03(){
  // Tạo danh sách số nguyên
  List<int> numbers = [10, 20, 30, 40, 50];

  // In ra các phần tử trong danh sách bằng for
  for(int number in numbers){
    print(number);
  }

  // In ra các phần tử trong danh sách bằng forEach
  numbers.forEach(print);

  // In ra các phần tử trong danh sách bằng for-in
  for(int i = 0; i < numbers.length; i++){
    print(numbers[i]);
  }
}
