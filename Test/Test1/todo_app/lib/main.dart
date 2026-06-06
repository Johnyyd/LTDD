import 'package:flutter/material.dart';
import 'views/todo_screen.dart'; // <--- Nhớ import

void main() {
  runApp(
    const MaterialApp(
      home: TodoScreen(),
      debugShowCheckedModeBanner: false, // Tắt chữ Debug đỏ đỏ ở góc
    ),
  );
}
