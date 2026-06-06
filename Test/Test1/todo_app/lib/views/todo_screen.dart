import 'package:flutter/material.dart';
import 'package:todo_app/controllers/todo_controller.dart';
import 'package:todo_app/models/todo_models.dart';

class TodoScreen extends StatefulWidget {
  //
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoController _todoController = TodoController(
    initialTasks: [
      TodoTask(title: "Học Flutter cơ bản", mask: "Ưu tiên cao"),
      TodoTask(title: "Đi siêu thị", mask: "Mua rau, thịt"),
      TodoTask(
        title: "Chạy bộ",
        mask: "5km buổi chiều",
        isCompleted: true,
      ), // Đã xong
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My To-do List"),
        backgroundColor: Colors.greenAccent,
        actions: [
          // Xóa tất cả công việc
          IconButton(
            onPressed: () {
              _todoController.removeAll();
            },
            icon: const Icon(Icons.delete),
          ),
          // Xóa công việc đã hoàn thành
          IconButton(
            onPressed: () {
              _todoController.removeComplete();
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      // Lắng nghe Controller
      body: ListenableBuilder(
        listenable: _todoController,
        builder: (context, child) {
          // Nếu danh sách rỗng thì thông báo
          if (_todoController.task.isEmpty) {
            return const Center(child: Text("Chưa có công việc nào!"));
          }

          // Hiển thị danh sách
          return ListView.builder(
            itemCount: _todoController.task.length,
            itemBuilder: (context, index) {
              // Lấy công việc tại vị trí index
              final task = _todoController.task[index];

              // Giao diện cho từng DÒNG
              return Card(
                child: ListTile(
                  // Checkbox
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      _todoController.toggleTaskStatus(index);
                    },
                  ),
                  // Tên công việc
                  title: Row(
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      Text("  "),
                      Text(
                        task.mask ?? "",
                        style: TextStyle(
                          color: task.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  // Nút xóa bên phải
                  trailing: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Chỉ chiếm diện tích vừa đủ
                    children: [
                      // Nút chỉnh sửa
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Gọi hàm hiện dialog sửa
                          _showEditTaskDialog(index, task);
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          _todoController.removeTask(index);
                        },
                        icon: Icon(color: Colors.red, Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // Thêm công việc
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: "btn1",
            onPressed: _showAddTaskDialog,
            child: const Icon(Icons.add),
          ),
          // FloatingActionButton(heroTag: "btn2", onPressed: () {}, child: const Icon(Icons.add)),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    // Tạo Controller riêng cho ô nhập liệu
    TextEditingController textController = TextEditingController();
    TextEditingController maskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm công việc"),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Nhập tên công việc"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                _todoController.addTask(
                  textController.text,
                  maskController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text("Thêm"),
            ),
          ],
        );
      },
    );
  }

  // Hàm hiển thị Dialog sửa
  void _showEditTaskDialog(int index, TodoTask task) {
    // Khởi tạo controller với dữ liệu cũ để người dùng sửa
    TextEditingController titleController = TextEditingController(
      text: task.title,
    );
    TextEditingController maskController = TextEditingController(
      text: task.mask,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chỉnh sửa công việc"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Tên công việc"),
              ),
              TextField(
                controller: maskController,
                decoration: const InputDecoration(labelText: "Ghi chú (Mask)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                // Gọi hàm editTask trong Controller
                _todoController.editTask(
                  index,
                  titleController.text,
                  maskController.text,
                  task.isCompleted,
                );
                Navigator.pop(context);
              },
              child: const Text("Lưu"),
            ),
          ],
        );
      },
    );
  }
}
