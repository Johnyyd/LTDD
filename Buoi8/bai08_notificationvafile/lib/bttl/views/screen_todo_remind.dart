import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../services/bai1.dart';
import '../services/bai2.dart';

class ScreenTodoRemind extends StatefulWidget {
  const ScreenTodoRemind({super.key});

  @override
  State<ScreenTodoRemind> createState() => _ScreenTodoRemindState();
}

class _ScreenTodoRemindState extends State<ScreenTodoRemind> {
  final TextEditingController controller = TextEditingController();
  final FileService fileService = FileService();
  final NotificationService notificationService = NotificationService();
  
  List<Todo> todos = [];
  DateTime? selectedTime;

  @override
  void initState() {
    super.initState();
    loadData();
    // Khởi tạo notification service
    notificationService.init();
  }

  void loadData() async {
    todos = await fileService.loadTodos();
    setState(() {});
  }

  void addTodo() async {
    if (controller.text.isEmpty || selectedTime == null) return;

    final todo = Todo(title: controller.text, time: selectedTime!);

    // 1. Lưu vào file (từ bài 2)
    todos.add(todo);
    await fileService.saveTodos(todos);

    // 2. Hiển thị notification đã thêm lịch (từ bài 3)
    await notificationService.showSimpleNotification(
      title: 'Đã thêm lịch nhắc',
      body: 'Công việc: ${todo.title} vào lúc ${formatTime(todo.time)}',
    );

    // 3. Thiết lập lịch cho công việc (từ bài 3)
    await notificationService.scheduleNotificationAt(
      id: todos.length, // ID duy nhất cho mỗi notification
      title: 'Nhắc việc: ${todo.title}',
      body: 'Đã đến giờ thực hiện công việc bạn đã hẹn!',
      scheduledTime: todo.time,
    );

    controller.clear();
    selectedTime = null;

    setState(() {});
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu công việc và đặt lịch nhắc!')),
      );
    }
  }

  // CHỌN NGÀY + GIỜ
  void pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      if (!mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        selectedTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        setState(() {});
      }
    }
  }

  String formatTime(DateTime time) {
    return DateFormat("dd/MM/yyyy HH:mm").format(time);
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.indigo.shade100,
      Colors.teal.shade100,
      Colors.amber.shade100,
      Colors.deepOrange.shade100,
      Colors.cyan.shade100,
    ];
    
    Color getTextColor(Color bg) {
      return bg.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ứng dụng Nhắc việc"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Nhập công việc
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Tên công việc cần nhắc",
                prefixIcon: const Icon(Icons.edit_note),
                filled: true,
                fillColor: Colors.grey.shade50,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Chọn thời gian
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent.withAlpha(77)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event, color: Colors.blueAccent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thời gian nhắc nhở:",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        Text(
                          selectedTime == null
                              ? "Chưa chọn thời gian"
                              : formatTime(selectedTime!),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: pickDateTime,
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text("Chọn"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      elevation: 0,
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Nút Lưu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: addTodo,
                icon: const Icon(Icons.save),
                label: const Text("LƯU & ĐẶT LỊCH NHẮC"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Danh sách hiển thị
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Danh sách nhắc việc:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: todos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          const Text("Chưa có công việc nào được lên lịch", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final t = todos[todos.length - 1 - index]; // Đảo ngược để thấy cái mới nhất
                        final Color bgColor = colors[index % colors.length];
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          color: bgColor,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: Colors.white.withAlpha(128),
                              child: const Icon(Icons.notifications_active, color: Colors.blueAccent),
                            ),
                            title: Text(
                              t.title,
                              style: TextStyle(
                                color: getTextColor(bgColor),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(Icons.access_time, size: 14, color: Colors.black54),
                                const SizedBox(width: 4),
                                Text(
                                  formatTime(t.time),
                                  style: TextStyle(
                                    color: getTextColor(bgColor).withAlpha(179),
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () async {
                                setState(() {
                                  todos.remove(t);
                                });
                                await fileService.saveTodos(todos);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
