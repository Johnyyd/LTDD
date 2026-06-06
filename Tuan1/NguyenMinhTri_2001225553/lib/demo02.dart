import 'dart:io';

bool checkPrime(int number){
  if(number < 2) return false;
  for(int i = 2; i < number; i++){
    if(number % i == 0) return false;
  }
  return true;
}

void demo02(){
  stdout.write("Nhập vào 1 số nguyên: ");
  String? input = stdin.readLineSync();
  
  if(input == null){
    stdout.write("Không có dữ liệu");
  }
  
  int number = int.parse(input!);
  
  if(checkPrime(number)){
    print("$number là số nguyên tố");
  }
  else{
    print("$number không phải là số nguyên tố");
  }
}
