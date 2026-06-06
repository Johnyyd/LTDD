import 'dart:io';

String value = "";

List<String> vowels = ["a", "e", "i", "o", "u"];

// a Pass
String input(){
  stdout.write("Nhập vào 1 chuỗi: ");
  value = stdin.readLineSync()!;
  return value;
}

// b Pass
int countVowels(String value){
  int cnt = 0;
  for(int i = 0; i < value.length; i++){
    for(int j = 0; j < vowels.length; j++){
      if(value[i] == vowels[j]){
        cnt += 1;
      }
    }
  }
  return cnt;
}

// c Pass
int count(String value){
  int cnt = 0;
  for(int i = 0; i < value.length; i++){
    cnt += 1;
  }
  return cnt;
}

// d Pass
bool symmetricList(String value){
  int length = value.length;
  for(int i = 0; i < length; i++){
    if(value[i] != value[length - i - 1]){
      return false;
    }
  }
  return true;
}

// e Pass
List<String> reverse(String value) {
  List<String> list = [];
  String currentWord = ""; // Biến để gom ký tự thành từ

  for (int i = 0; i < value.length; i++) {
    // Nếu ký tự hiện tại KHÁC khoảng trắng, ghép vào từ đang gom
    if (value[i] != " ") {
      currentWord += value[i];
    }
    
    // Logic kiểm tra để chèn từ vào danh sách:
    // 1. Nếu gặp khoảng trắng -> hết 1 từ
    // 2. HOẶC nếu là ký tự cuối cùng của chuỗi (i == length - 1) -> hết từ cuối
    if ((value[i] == " " || i == value.length - 1) && currentWord.isNotEmpty) {
      // Chèn vào vị trí 0 để từ mới luôn đứng đầu (đảo ngược)
      list.insert(0, currentWord); 
      
      // Reset biến tạm để gom từ tiếp theo
      currentWord = ""; 
    }
  }
  
  return list;
}