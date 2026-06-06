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
      home: Bai3Page.full(),
    );
  }
}

class Bai3Page extends StatefulWidget {
  Bai3Page.full({
    this.maSP = "PC0001",
    this.tenSP = "IXT Gaming PC",
    this.nsx = "ITX",
    this.giaBan = 15000000,
    this.moTa = "ITX PC cao cấp, hiệu năng tốt",
    this.hinhAnh = const [
      "assets/images/itx1.png",
      "assets/images/itx2.png",
      "assets/images/itx3.png",
    ],
    Key? key,
  }) : super(key: key);

  final String maSP;
  final String tenSP;
  final String nsx;
  final double giaBan;
  final String moTa;
  final List<String> hinhAnh;

  @override
  State<Bai3Page> createState() => _Bai3PageState();
}

class _Bai3PageState extends State<Bai3Page> {
  // List<Bai3> dsItems = [Bai3(), Bai3(), Bai3(), Bai3(), Bai3()];
  final Bai3Page sanPham = Bai3Page.full();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  for (var item in sanPham.hinhAnh)
                    Image.asset(
                      item,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
              Text(
                sanPham.maSP,
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                sanPham.tenSP,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                sanPham.nsx,
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              Text(
                sanPham.giaBan.toString() + " VND",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                sanPham.moTa,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
