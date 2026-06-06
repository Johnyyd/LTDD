import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bai_tap_1.dart';
import 'bai_tap_2.dart';
import 'bai_tap_3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Khởi tạo Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thực Hành Firebase',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Bài Tập')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BaiTap1())),
              child: const Text('Bài tập 1: Authentication'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BaiTap2())),
              child: const Text('Bài tập 2: Storage Upload'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BaiTap3())),
              child: const Text('Bài tập 3: Products (Firestore + Storage)'),
            ),
          ],
        ),
      ),
    );
  }
}