import 'package:flutter/material.dart';
import '../models/counter_model.dart';

// Kế thừa ChangeNotifier để có khả năng "hét lên" khi dữ liệu đổi
class HomeController extends ChangeNotifier {
  // 1. Giữ Model
  final CounterModel _model = CounterModel();

  // 2. Getter để View lấy dữ liệu hiển thị
  int get count => _model.count;

  // 3. Hàm xử lý logic (Action)
  void incrementCounter() {
    _model.count++; // Tăng số
    notifyListeners(); // <--- QUAN TRỌNG: Báo cho View biết để vẽ lại
  }
}
