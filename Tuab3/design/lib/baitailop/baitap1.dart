import 'package:flutter/material.dart';

class Bai1_1 extends StatelessWidget {
  const Bai1_1({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thông tin sinh viên',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Bai1_1Page(),
    );
  }
}

class Bai1_1Page extends StatefulWidget {
  const Bai1_1Page({super.key});

  @override
  State<Bai1_1Page> createState() => _Bai1_1PageState();
}

class _Bai1_1PageState extends State<Bai1_1Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Add a color here
                borderRadius: BorderRadius.circular(
                  100,
                ), // Set the border radius
                border: Border.all(
                  color: Colors.black, // Optional: add a border color
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage("assets/images/hieu.jpg"),
              ),
            ),
            Text(
              "Họ và tên: Nguyễn Văn A",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              "MSSV: 2001221234",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              "Lớp: 13DHTH02",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              "Khóa: 13 Đại học",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              "Ngành: Công nghệ thông tin",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              "Trường: Đại học Công Thương Thành phố Hồ Chí Minh",
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
            BackButton(
              color: Colors.grey,
              onPressed: () {
                Text("Trở về");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Bai1_2 extends StatelessWidget {
  const Bai1_2({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thông tin giảng viên',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Bai1_2Page(),
    );
  }
}

class Bai1_2Page extends StatefulWidget {
  const Bai1_2Page({super.key});

  @override
  State<Bai1_2Page> createState() => _Bai1_2PageState();
}

class _Bai1_2PageState extends State<Bai1_2Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Add a color here
                borderRadius: BorderRadius.circular(
                  100,
                ), // Set the border radius
                border: Border.all(
                  color: Colors.black, // Optional: add a border color
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage("assets/images/gv.jpg"),
              ),
            ),
            Text(
              "Giảng viên Trần Thị A",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              "Khoa: Công nghệ thông tin",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              "Học hàm: Thạc Sĩ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              "Chuyên ngành: Công Nghệ Phần Mềm",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              "Giảng dạy: Nhập môn lập trình, Lập trình Windows, Lập trình Web,...",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            BackButton(
              color: Colors.grey,
              onPressed: () {
                Text("Trở về");
              },
            ),
          ],
        ),
      ),
    );
  }
}
