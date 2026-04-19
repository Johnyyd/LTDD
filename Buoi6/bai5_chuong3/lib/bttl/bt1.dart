import 'package:flutter/material.dart';

class Bai1 extends StatelessWidget {
  const Bai1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home, color: Colors.black),
        backgroundColor: Colors.amber,
        title: const Text(
          "ListView Demo",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "Chọn loại đề tài",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTopicItem("Đồ án"),
                _buildTopicItem("KLKS"),
                _buildTopicItem("Luận văn"),
                _buildTopicItem("Khác"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "Chọn chuyên ngành thực hiện",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildSpecialtyItem(
            Icons.home,
            "Công nghệ phần mềm",
            "Phát triển các ứng dụng giải quyết các vấn đề thực tế",
          ),
          _buildSpecialtyItem(
            Icons.home,
            "Hệ thống thông tin",
            "Phát triển các kỹ thuật xử lý thông tin trong tổ chức",
          ),
          _buildSpecialtyItem(
            Icons.home,
            "Mạng máy tính",
            "Xử lý các vấn đề liên quan đến mạng máy tính",
          ),
          _buildSpecialtyItem(
            Icons.home,
            "An toàn thông tin",
            "Thiết kế và đảm bảo an toàn cho hệ thống máy tính",
          ),
        ],
      ),
    );
  }

  Widget _buildTopicItem(String label) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 74, 0, 97),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtyItem(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color.fromARGB(
            255,
            17,
            153,
            243,
          ).withValues(alpha: 0.1),
          child: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward, size: 16),
        onTap: () {},
      ),
    );
  }
}
