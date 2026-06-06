import 'package:flutter/material.dart';
import 'baitap4.dart';
import 'package:nguyenminhtri_2001225553_tuan4/baitaplop/baitap1.dart';
import 'package:nguyenminhtri_2001225553_tuan4/baitaplop/baitap2.dart';
import 'package:nguyenminhtri_2001225553_tuan4/baitaplop/baitap3.dart';

class Bai5 extends StatelessWidget {
  const Bai5({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trang chủ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, // Khuyến khích dùng Material 3 cho UI hiện đại
      ),
      debugShowCheckedModeBanner: false, // Tắt chữ DEBUG góc phải
      home: const Bai5Page(),
    );
  }
}

class GiangVien {
  final String maGV;
  final String tenGV;
  final String boMon;

  GiangVien(this.maGV, this.tenGV, this.boMon);
}

class Khoa {
  final String maKhoa;
  final String tenKhoa;

  Khoa(this.maKhoa, this.tenKhoa);
}

class BoMon {
  final String maBoMon;
  final String tenBoMon;

  BoMon(this.maBoMon, this.tenBoMon);
}

class Bai5Page extends StatefulWidget {
  final String tenNganh;
  final List<GiangVien> giangVien;
  final List<Khoa> khoa;
  final List<BoMon> boMon;
  final String hinhAnh;
  final String moTa;

  const Bai5Page({
    super.key,
    this.tenNganh = "",
    this.giangVien = const [],
    this.khoa = const [],
    this.boMon = const [],
    this.hinhAnh = "",
    this.moTa = "",
  });

  const Bai5Page.full(
    this.tenNganh,
    this.giangVien,
    this.khoa,
    this.boMon,
    this.hinhAnh,
    this.moTa,
  ) : super(key: null);

  @override
  State<Bai5Page> createState() => _Bai5State();
}

class _Bai5State extends State<Bai5Page> {
  final List<Bai5Page> dsNganh = [
    Bai5Page.full(
      "Công nghệ thông tin",
      [
        GiangVien("GV001", "Nguyễn Văn A", "Công nghệ phần mềm"),
        GiangVien("GV002", "Trần Thị B", "Khoa học máy tính"),
        GiangVien("GV003", "Lê Văn C", "Hệ thống thông tin"),
        GiangVien("GV007", "Phan Thị G", "Trí tuệ nhân tạo"),
        GiangVien("GV008", "Đỗ Văn H", "Phát triển phần mềm"),
      ],
      [
        Khoa("K001", "Khoa Công nghệ Thông tin"),
        Khoa("K002", "Khoa Khoa học Máy tính"),
        Khoa("K003", "Khoa Trí tuệ Nhân tạo"),
      ],
      [
        BoMon("BM001", "Công nghệ phần mềm"),
        BoMon("BM002", "Khoa học máy tính"),
      ],
      "assets/images/anh1.png",
      "Ngành Công nghệ thông tin đào tạo các kỹ năng về lập trình, phát triển phần mềm và xây dựng hệ thống.",
    ),
    Bai5Page.full(
      "An toàn thông tin",
      [
        GiangVien("GV004", "Phạm Thị D", "Mạng máy tính"),
        GiangVien("GV005", "Đỗ Văn E", "Bảo mật thông tin"),
        GiangVien("GV006", "Hoàng Thị F", "Mật mã học"),
      ],
      [Khoa("K001", "Khoa An toàn thông tin"), Khoa("K002", "Khoa Bảo mật")],
      [
        BoMon("BM001", "Mạng máy tính"),
        BoMon("BM002", "Mật mã học"),
        BoMon("BM003", "Bảo mật thông tin"),
      ],
      "assets/images/anh2.png",
      "Ngành An toàn thông tin đào tạo các kỹ năng về bảo mật, phòng chống tấn công mạng và an ninh hệ thống.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[100], // Thêm màu nền sáng cho Scaffold để Card nổi bật
      appBar: AppBar(
        title: const Text(
          'Danh sách ngành học',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          // Các nút điều hướng
          IconButton(
            tooltip: "Bài 1.1",
            icon: const Icon(Icons.looks_one, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bai1_1()),
              );
            },
          ),
          IconButton(
            tooltip: "Bài 1.2",
            icon: const Icon(Icons.looks_two, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bai1_2()),
              );
            },
          ),
          IconButton(
            tooltip: "Bài 2",
            icon: const Icon(Icons.looks_3, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bai2()),
              );
            },
          ),
          IconButton(
            tooltip: "Bài 3",
            icon: const Icon(Icons.looks_4, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bai3()),
              );
            },
          ),
          IconButton(
            tooltip: "Bài 4",
            icon: const Icon(Icons.looks_5, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bai4()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dsNganh.length,
        itemBuilder: (context, index) {
          final nganh = dsNganh[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Phần hình ảnh có bo góc phía trên
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.asset(
                    nganh.hinhAnh,
                    height: 180,
                    fit: BoxFit.cover,
                    // Hiển thị khung xám nếu không tìm thấy ảnh
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên ngành
                      Text(
                        nganh.tenNganh,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Mô tả
                      Text(
                        nganh.moTa,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Danh sách Giảng viên (Dùng ExpansionTile để thu gọn)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue.shade100),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          shape:
                              const Border(), // Xóa viền mặc định của ExpansionTile
                          leading: const Icon(Icons.school, color: Colors.blue),
                          title: Text(
                            "Giảng viên (${nganh.giangVien.length})",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: nganh.giangVien.map((gv) {
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              leading: const Icon(Icons.person, size: 20),
                              title: Text(gv.tenGV),
                              subtitle: Text(
                                gv.boMon,
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Danh sách Khoa
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange.shade100),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          shape: const Border(),
                          leading: const Icon(
                            Icons.account_balance,
                            color: Colors.orange,
                          ),
                          title: Text(
                            "Khoa (${nganh.khoa.length})",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: nganh.khoa.map((k) {
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              leading: const Icon(Icons.business, size: 20),
                              title: Text(k.tenKhoa),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
