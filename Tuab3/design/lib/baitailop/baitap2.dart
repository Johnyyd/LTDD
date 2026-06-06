import 'package:flutter/material.dart';

class Bai2 extends StatelessWidget {
  const Bai2({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trang chủ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Bai2Page(),
    );
  }
}

class Bai2Page extends StatefulWidget {
  final String maDeTai;
  final String tenDeTai;
  final int soLuong;
  final String chuyenNganh;
  final String giangVienHD;
  final String yeuCau;

  const Bai2Page({
    super.key,
    this.maDeTai = "",
    this.tenDeTai = "",
    this.soLuong = 0,
    this.chuyenNganh = "",
    this.giangVienHD = "",
    this.yeuCau = "",
  });

  const Bai2Page.full(
    this.maDeTai,
    this.tenDeTai,
    this.soLuong,
    this.chuyenNganh,
    this.giangVienHD,
    this.yeuCau,
  ) : super(key: null);

  @override
  State<Bai2Page> createState() => _Bai2State();
}

class _Bai2State extends State<Bai2Page> {
  final List<Bai2Page> dsDeTai = [
    Bai2Page.full(
      "LTDD123",
      "Ứng dụng quản lý sinh viên",
      3,
      "Công nghệ thông tin",
      "Nguyễn Văn A",
      "Sử dụng Flutter để phát triển ứng dụng di động",
    ),
    Bai2Page.full(
      "LTDD456",
      "Hệ thống đặt phòng khách sạn",
      4,
      "Công nghệ thông tin",
      "Trần Thị B",
      "Xây dựng ứng dụng web với React và Node.js",
    ),
    Bai2Page.full(
      "LTDD789",
      "Phân tích dữ liệu lớn",
      2,
      "Khoa học dữ liệu",
      "Lê Văn C",
      "Sử dụng Python và các thư viện phân tích dữ liệu",
    ),
    Bai2Page.full(
      "LTDD101",
      "Mạng xã hội cho sinh viên",
      5,
      "Công nghệ thông tin",
      "Phạm Thị D",
      "Phát triển ứng dụng di động với React Native",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đề tài khóa luận'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              return;
            },
            alignment: Alignment.centerLeft,
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              return;
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  for (var detai in dsDeTai)
                    Column(
                      children: [
                        Text(
                          "Mã đề tài: ${detai.maDeTai}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            decoration: TextDecoration.combine([
                              TextDecoration.underline,
                              TextDecoration.overline,
                            ]),
                          ),
                        ),
                        Text(
                          "Tên đề tài: ${detai.tenDeTai}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          "Số lượng sinh viên: ${detai.soLuong}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                        Text(
                          "Chuyên ngành: ${detai.chuyenNganh}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "Giảng viên hướng dẫn: ${detai.giangVienHD}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          "Yêu cầu: ${detai.yeuCau}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: Container(color: Colors.grey),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
