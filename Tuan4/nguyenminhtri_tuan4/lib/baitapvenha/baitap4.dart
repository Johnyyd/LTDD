import 'package:flutter/material.dart';

class Bai4 extends StatelessWidget {
  const Bai4({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trang chủ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Bai4Page(),
    );
  }
}

class ThanhVien {
  final String maSV;
  final String tenSV;
  final String vaiTro;

  ThanhVien(this.maSV, this.tenSV, this.vaiTro);
}

class Bai4Page extends StatefulWidget {
  final String maNhom;
  final String tenNhom;
  final int soLuong;
  final List<ThanhVien> thanhVien;

  const Bai4Page({
    super.key,
    this.maNhom = "",
    this.tenNhom = "",
    this.soLuong = 0,
    this.thanhVien = const [],
  });

  const Bai4Page.full(this.maNhom, this.tenNhom, this.soLuong, this.thanhVien)
    : super(key: null);

  @override
  State<Bai4Page> createState() => _Bai4State();
}

class _Bai4State extends State<Bai4Page> {
  final List<Bai4Page> dsNhom = [
    Bai4Page.full("N001", "Nhóm 1: Phát triển ứng dụng di động", 3, [
      ThanhVien("SV001", "Nguyễn Văn A", "Trưởng nhóm"),
      ThanhVien("SV002", "Trần Thị B", "Thành viên"),
      ThanhVien("SV003", "Lê Văn C", "Thành viên"),
    ]),
    Bai4Page.full("N002", "Nhóm 2: Phát triển ứng dụng web", 3, [
      ThanhVien("SV004", "Phạm Thị D", "Trưởng nhóm"),
      ThanhVien("SV005", "Đỗ Văn E", "Thành viên"),
      ThanhVien("SV006", "Hoàng Thị F", "Thành viên"),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách nhóm'),
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
                  for (var nhom in dsNhom)
                    Column(
                      children: [
                        Text(
                          "Mã nhóm: ${nhom.maNhom}",
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
                          "Tên nhóm: ${nhom.tenNhom}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          "Số lượng sinh viên: ${nhom.soLuong}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                        for (var thanhVien in nhom.thanhVien)
                          Column(
                            children: [
                              Text(
                                "Mã sinh viên: ${thanhVien.maSV}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                "Tên sinh viên: ${thanhVien.tenSV}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.orange,
                                ),
                              ),
                              Text(
                                "Vai trò: ${thanhVien.vaiTro}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 30,
                          child: Container(color: Colors.grey),
                        ), // Tạo khoảng trống giữa các nhóm
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
