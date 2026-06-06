import 'dart:io';
import 'demo02.dart';

// Pass
int inputUser(){
  stdout.write("Nhập vào 1 số nguyên: ");
  String? input = stdin.readLineSync();
  
  // Kiểm tra rỗng của input
  if(input == null){
    stdout.write("Không có dữ liệu");
  }
  
  // Ép kiểu dữ liệu từ String sang int và kiểm tra dương
  int number = int.parse(input!);
  if(number <= 10){
    inputUser();
  }

  return number;
}


// a Pass
int count(int value){
  // Biến đếm
  int cnt = 0;
  for(int i = 0; i < value.toString().length; i++){
    cnt+=1;
  }
  return cnt;
}

// b Pass
int totalDigit(int value){
  // Biến cộng
  int total = 0;
  for(int i = 0; i < count(value); i++){
    // Ép kiểu dữ liệu từ String sang int, lấy từng phần tử trong chuỗi và cộng vào biến total
    total += int.parse(value.toString()[i]);
  }
  return total;
}

// c Pass
bool isEvenNumber(int number){
  for(int i = 0; i < count(number); i++){
    // Kiểm tra số chẵn
    if(int.parse(number.toString()[i]) % 2 != 0){
      return true;
    }
  }
  return false;
}

// d Pass
int maxDigit(int number){
  int max = 0;
  for(int i = 0; i < count(number); i++){
    // Tìm số lớn nhất trong chuỗi
    if(max < int.parse(number.toString()[i])){
      max = int.parse(number.toString()[i]);
    }
  }
  return max;
}

// e
bool isPrimeDigit(int number){
  for(int i = 0; i < count(number); i++){
    // Kiểm tra số nguyên tố trong chuỗi
    if(!checkPrime(int.parse(number.toString()[i]))){
      return true;
    }
  }
  return false;
}