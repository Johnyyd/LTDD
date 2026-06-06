class PhongTro {
  // Khai báo các thuộc tính
  String _maPhong = '';
  String _tenPhong = '';
  bool _coTang = false;
  double _giaThue = 0;
  int _soNguoi = 0;
  int _soNgay = 0;

  // Khai báo constructor mặc định, không có tham số
  PhongTro() {
    _maPhong = "Unknown";
    _tenPhong = "Unknown";
    _coTang = false;
    _giaThue = 0;
    _soNguoi = 0;
    _soNgay = 0;
  }

  // Khai báo constructor có tham số, có tên là full với  3 tham số
  PhongTro.full(
    String ma,
    String ten,
    bool tang,
    double gia,
    int ng,
    int ngay,
  ) {
    _maPhong = ma;
    _tenPhong = ten;
    _coTang = tang;
    _giaThue = gia;
    _soNguoi = ng;
    _soNgay = ngay;
  }

  // Tính tiền thuê
  double tinhTienThue() {
    double giaNguoi = _soNguoi * 100000;
    if (_coTang == true) {
      return _giaThue * _soNgay * 1.1 + giaNguoi;
    } else {
      return _giaThue * _soNgay + giaNguoi;
    }
  }

  @override
  String toString() {
    return "Mã phòng: $_maPhong " +
        "Tên phòng: $_tenPhong " +
        "Có tầng: $_coTang " +
        "Giá thuê: $_giaThue " +
        "Số người: $_soNguoi " +
        "Số ngày: $_soNgay";
  }

  // Lọc phòng trọ có trên 2 người
  bool filterPhongTro() {
    bool flag = false;
    if (_soNguoi > 2) {
      flag = true;
    }
    return flag;
  }
}
