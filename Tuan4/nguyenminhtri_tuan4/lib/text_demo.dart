import 'package:flutter/material.dart'; // Nhập thư viện vật liệu (Material Design) cốt lõi của Flutter.

// Định nghĩa lớp TextDemo kế thừa từ StatelessWidget vì giao diện này không thay đổi trạng thái.
class TextDemo extends StatelessWidget {
  const TextDemo({super.key}); // Hàm khởi tạo (Constructor) cho widget.

  @override
  Widget build(BuildContext context) {
    // Hàm build để xây dựng giao diện người dùng.
    return MaterialApp(
      // Widget gốc cung cấp các cấu hình cơ bản cho ứng dụng.
      title: 'Ứng dụng demo Flutter', // Tiêu đề của ứng dụng.
      debugShowCheckedModeBanner:
          false, // Tắt biểu tượng chữ "Debug" ở góc màn hình.
      theme: ThemeData(
        // Cấu hình chủ đề (màu sắc, font chữ...) cho ứng dụng.
        primarySwatch: Colors.blue, // Thiết lập tông màu chủ đạo là màu xanh.
      ),
      home: Scaffold(
        // Widget cung cấp cấu trúc cơ bản của một màn hình (AppBar, Body...).
        appBar: AppBar(
          // Thanh ứng dụng ở phía trên cùng.
          title: const Text(
            // Hiển thị tiêu đề trên thanh AppBar.
            "Sử dụng Text và Image",
            style: TextStyle(
              // Định dạng kiểu chữ cho tiêu đề.
              color: Color.fromARGB(255, 201, 229, 16), // Màu chữ (ARGB).
              fontSize: 18,
            ), // Kích thước chữ.
          ),
          backgroundColor: Colors.blue[900], // Màu nền của thanh AppBar.
          leading: IconButton(
            // Biểu tượng nằm ở bên trái của thanh AppBar.
            icon: const Icon(Icons.home), // Sử dụng biểu tượng ngôi nhà (Home).
            onPressed:
                () {}, // Hành động khi nhấn vào nút (hiện đang để trống).
          ),
        ),
        body: SingleChildScrollView(
          // Widget cho phép cuộn nội dung nếu nó vượt quá kích thước màn hình.
          child: Center(
            // Widget căn giữa thành phần con của nó.
            child: Column(
              // Sắp xếp các widget con theo chiều dọc.
              mainAxisAlignment: MainAxisAlignment
                  .start, // Căn các widget con bắt đầu từ trên cùng.
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Căn các widget con sát lề trái.
              children: [
                // Danh sách các widget con bên trong Column.
                const SizedBox(
                  height: 40,
                ), // Tạo một khoảng trống dọc có chiều cao 40.
                const Padding(
                  // Thêm khoảng cách đệm xung quanh widget con.
                  padding: EdgeInsets.all(
                    8.0,
                  ), // Thêm 8 đơn vị khoảng cách ở tất cả các cạnh.
                  child: Center(
                    // Căn giữa dòng chữ tiêu đề chính.
                    child: Text(
                      "LẬP TRÌNH DI ĐỘNG KHÓA 13!",
                      style: TextStyle(
                        color: Color.fromARGB(255, 235, 19, 19), // Màu đỏ.
                        fontSize: 25, // Cỡ chữ lớn.
                        fontWeight: FontWeight.bold,
                      ), // Kiểu chữ đậm.
                      textAlign: TextAlign.center, // Căn lề văn bản ở giữa.
                    ),
                  ),
                ),
                Center(
                  // Căn giữa hình ảnh logo.
                  child: Image.asset(
                    // Hiển thị hình ảnh từ tài nguyên cục bộ (assets).
                    "assets/images/logo.png", // Đường dẫn tệp hình ảnh đã khai báo.
                    width: 100, // Chiều rộng hình ảnh.
                    height: 100, // Chiều cao hình ảnh.
                    fit: BoxFit
                        .scaleDown, // Hình ảnh tự thu nhỏ để vừa khung mà không bị cắt.
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                    left: 8,
                  ), // Chỉ thêm khoảng cách ở phía trên và bên trái.
                  child: Text(
                    "Chúc các bạn đạt kết quả tốt",
                    style: TextStyle(
                      color: Color.fromARGB(255, 169, 13, 248), // Màu tím.
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ), // Tạo khoảng trống 10 đơn vị giữa các dòng.
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Giảng viên: Nguyễn Thanh Truyền",
                    style: TextStyle(
                      color: Color.fromARGB(
                        255,
                        54,
                        63,
                        244,
                      ), // Màu xanh dương.
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Số tiết: 75 tiết",
                    style: TextStyle(
                      color: Color.fromARGB(255, 54, 63, 244),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left, // Căn lề văn bản sang trái.
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
