import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_models.dart';

class TodoController extends ChangeNotifier {
  // ChangeNotifier để theo dõi Controller thay đổi trạng thái

  // Danh sách dữ liệu
  final List<TodoTask> _task = [];

  // Getter lấy danh sách dữ liệu
  List<TodoTask> get task => _task;

  TodoController({List<TodoTask>? initialTasks}) {
    // Nếu có dữ liệu truyền vào thì thêm nó vào danh sách chính
    if (initialTasks != null) {
      _task.addAll(initialTasks);
    }
  }

  // Function
  // Thêm công việc mới
  void addTask(String taskTitle, String mask) {
    // Kiểm tra dữ liệu rỗng
    if (taskTitle.isEmpty) return;

    // Thêm vào danh sách
    _task.add(TodoTask(title: taskTitle, mask: mask));
    notifyListeners();
  }

  // Xóa công việc
  void removeTask(int index) {
    _task.removeAt(index);
    notifyListeners();
  }

  // Cập nhật trạng thái công việc
  bool toggleTaskStatus(int index) {
    _task[index].isCompleted = !_task[index].isCompleted;
    notifyListeners();
    return _task[index].isCompleted;
  }

  // Xóa tất cả công việc đã hoàn thành
  void removeComplete() {
    _task.removeWhere((t) => t.isCompleted == true);
    notifyListeners();
  }

  // Xóa tất cả công việc
  void removeAll() {
    _task.clear();
    notifyListeners();
  }

  // Chỉnh sửa lại công việc
  void editTask(int index, String taskTitle, String mask, bool status) {
    _task[index].title = taskTitle;
    _task[index].mask = mask;
    _task[index].isCompleted = status;
    notifyListeners();
  }
}
