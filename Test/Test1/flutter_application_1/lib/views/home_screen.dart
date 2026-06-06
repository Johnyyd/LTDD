import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Khởi tạo Controller
  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder lắng nghe _controller.
    // Khi _controller gọi notifyListeners(), đoạn code bên trong builder sẽ chạy lại.
    return ListenableBuilder(
      listenable: _controller,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("MVC Counter App"),
            backgroundColor: Colors.deepPurple[100],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bạn đã bấm nút số lần là:'),
                // Hiển thị dữ liệu từ Controller
                Text(
                  '${_controller.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          // Gọi hàm logic từ Controller
          floatingActionButton: FloatingActionButton(
            // Gọi hàm logic từ Controller
            onPressed: _controller.incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
