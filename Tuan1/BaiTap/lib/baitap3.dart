import 'baitap1.dart';
import 'demo02.dart';

List<int> numbers = [];

// a Pass
List<int> inputList(int n, List<int> numbers){
  for(int i = 0; i < n; i++){
    numbers.add(inputUser());
  }
  return numbers;
}

// b Pass
int totalList(List<int> numbers){
  int total = 0;
  // Tính tổng các phần tử trong danh sách
  for(int i = 0; i < numbers.length; i++){
    total += numbers[i];
  }
  return total;
}

// c Pass
List<int> primrList(List<int> numbers){
  List<int> primeNumbers = [];
  // Lọc ra các số nguyên tố trong danh sách
  primeNumbers = numbers.where((number) => checkPrime(number)).toList();
  return primeNumbers;
}

// d Pass
List<int> findList(List<int> numbers, int value){
  if(numbers.where((number) => number == value).isNotEmpty){
    print("Vị trí: ${numbers.indexOf(value)}");
  }
  else{
    numbers.insert(0, value);
  }
  return numbers;
}
