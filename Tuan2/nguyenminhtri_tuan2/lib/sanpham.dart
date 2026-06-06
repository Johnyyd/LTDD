class SanPham {
  // Khai báo các thuộc tính
  String _maSP = '';
  String _tenSP = '';
  double _donGia = 0;
  double _giamGia = 0;

  // Khai báo constructor mặc định, không có tham số
  SanPham() {
    _maSP = "SP000";
    _tenSP = "Unknown";
    _donGia = 0;
    _giamGia = 0;
  }

  // Khai báo constructor có tham số, có tên là full với  4 tham số
  SanPham.full(String ma, String ten, double gia, double giam) {
    _maSP = ma;
    _tenSP = ten;
    _donGia = gia;
    _giamGia = giam;
  }

  // getter và setter cho các thuộc tính
  // Phương thức giao tiếp với bên ngoài
  // getter cho _maSP
  String get maSP => _maSP;
  // setter cho _maSP
  set maSP(String value) {
    if (value.isNotEmpty) {
      _maSP = value;
    }
  }

  // getter cho _tenSP
  String get tenSP => _maSP;
  // setter cho _tenSP
  set tenSP(String value) {
    if (value.isNotEmpty) {
      _tenSP = value;
    }
  }

  // getter cho _donGia
  double get donGia => _donGia;
  // setter cho _donGia
  set donGia(double value) {
    if (value > 0) {
      _donGia = value;
    }
  }

  // getter cho _giamGia
  double get giamGia => _giamGia;
  set giamGia(double value) {
    if (value >= 0 && value <= 100) {
      _giamGia = value;
    }
  }

  // tính thuế nhập khẩu
  double tinhThueNhapKhau() {
    return 0.01 * _donGia;
  }

  // show function
  void showInfo() {
    print(
      "Mã sản phẩm: $_maSP " +
          "Tên sản phẩm: $_tenSP " +
          "Đơn giá: $_donGia " +
          "Giảm giá: $_giamGia ",
    );
  }
}
