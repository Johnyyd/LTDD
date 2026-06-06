import 'package:flutter/material.dart';

class Bai3 extends StatelessWidget {
  const Bai3({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trang chủ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Bai3(),
    );
  }
}

class Bai3Page extends StatefulWidget {
  const Bai3Page({super.key});

  final String _maSP = "";

  @override
  State<Bai3Page> createState() => _Bai3PageState();
}

class _Bai3PageState extends State<Bai3Page> {
  List<Bai3> dsItems = [Bai3(), Bai3(), Bai3(), Bai3(), Bai3()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: [
            for (var item in [1, 2, 3, 4, 5]) Column(),
          ],
        ),
      ),
    );
  }
}
