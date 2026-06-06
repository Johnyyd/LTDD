import 'dart:math';
import 'baitap1.dart';

List<int> listNumbers = [];

// a Pass
List<int> randomList(List<int> listNumbers, int n){
  for(int i = 0; i < n; i++){
    int number;
    // Điều kiện
    do{
      number = Random().nextInt(100);
    }while(number < 5 || number > 100);
    listNumbers.add(number);
  }
  return listNumbers;
}

// b Pass
int totalList(List<int> listNumbers){
  int total = 0;
  // listNumbers.forEach((number) {
  //   total += number;
  // });
  for(int i = 0; i < listNumbers.length; i++){
    total += listNumbers[i];
  }
  return total;
}

// c Pass
double averageOdd(List<int> listNumbers){
  double average = 0;
  int cnt = 0;
  for(int i = 0; i < listNumbers.length; i++){
    if(listNumbers[i] % 2 != 0){
      average += listNumbers[i];
      cnt += 1;
    }
  }
  average /= cnt;
  return average;  
}

// d Pass
bool symmetricList(List<int> listNumbers){
  List<int> listNumbersReverse = [];
  // int length = listNumbers.length;
  // for(int i = 0; i < length; i++){
  //   if(listNumbers[i] != listNumbers[length - i - 1]){
  //     return false;
  //   }
  // }
  listNumbersReverse = listNumbers.reversed.toList();
  for(int i = 0; i < listNumbers.length; i++){
    if(listNumbers[i] != listNumbersReverse[i]){
      return false;
    }
  }
  return true;
}

// e Pass
bool isSort(List<int> listNumbers){
  int tmp = listNumbers[0];
  for(int i = 1; i < listNumbers.length; i++){
    if(tmp > listNumbers[i]){
      return false;
    }
    tmp = listNumbers[i];
  }
  return true;
}

// f Pass
int maxNumber(List<int> listNumbers){
  int max = listNumbers[0];
  for(int i = 1; i < listNumbers.length; i++){
    if(max < listNumbers[i]){
      max = listNumbers[i];
    }
  }
  return max;
}

// g Pass 
int maxEvenNumber(List<int> listNumbers){
  int max = maxNumber(listNumbers);
  if(max % 2 == 0){
    return max;
  }
  return 0;
}

// h Pass
List<int> searchList(List<int> listNumbers){
  int number = inputUser();
  if(listNumbers.where((element) => element == number).isNotEmpty){
    listNumbers.remove(number);
  }
  else{
    print("Không tìm thấy số $number trong danh sách");
  }
  return listNumbers;
}