class TodoTask {
  String title; // Bắt buộc phải có
  String? mask; // Không bắt buộc có
  bool isCompleted; // Bắt buộc phải có

  // Constructor (bắt buộc phải khởi tạo)
  TodoTask({required this.title, this.mask, this.isCompleted = false});
}
