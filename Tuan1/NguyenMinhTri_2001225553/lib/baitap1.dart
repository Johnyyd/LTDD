import 'dart:io';

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
  if(number <= 0){
    inputUser();
  }

  return number;
}

// Pass
double purchase(int number, double price){
  double total = 0;
  if(number > 10)
  {
    total += number * price * 0.9;
  }
  else if(number >= 5)
  {
    total += number * price * 0.95;
  }
  else{
    total += number * price;
  }
  return total; 
}

// Pass
String show(double total){
  return "Tổng tiền là: $total";
}

