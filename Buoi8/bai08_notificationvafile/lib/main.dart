import 'package:flutter/material.dart';
import 'package:bai08_notificationvafile/bttl/services/bai1.dart';
import 'package:bai08_notificationvafile/bttl/views/screen_noti_ex.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // nền trắng toàn app
      ),
      home: ScreenNotiEx(),
    );
  }
}
