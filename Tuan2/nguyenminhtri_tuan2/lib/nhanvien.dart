class NhanVien {
  // Khai báo thuộc tính
  String _maNV = '';
  String _tenNV = '';
  double _heSoLuong = 0.0;
  String _phongBan = '';
  double _soNgayLV = 0.0;
  static double LCB = 2340;

  // Khai báo constructer mặc định
  NhanVien() {
    _maNV = "NV000";
    _tenNV = "Nguyễn Văn A";
    _heSoLuong = 2.34;
    _phongBan = "Tổ chức";
    _soNgayLV = 22;
  }

  // Khai báo constructer có tham số,
  // có tên là fullPara với 5 tham số
  NhanVien.fullPara(
    String ma,
    String ten,
    double hs,
    String phong,
    double ngay,
  ) {
    _maNV = ma;
    _tenNV = ten;
    _heSoLuong = hs;
    _phongBan = phong;
    _soNgayLV = ngay;
  }

  // Hàm đánh giá, xếp loại
  String xepLoai() {
    if (_soNgayLV > 25) {
      return 'A';
    } else if (_soNgayLV > 22) {
      return 'B';
    } else {
      return 'C';
    }
  }

  // Hàm tính lương
  double tinhLuong() {
    String xl = xepLoai();
    double hsThiDua = 0.5;

    if (xl == 'A') {
      hsThiDua = 1.0;
    } else if (xl == 'B') {
      hsThiDua = 0.75;
    }

    return LCB * _heSoLuong * hsThiDua;
  }

  // overiding toString() trả về chuỗi thông tin của nhân viên
  // có thể hiểu là 1 hàm hiển thị kết quả, thông tin
  @override
  String toString() {
    return "$_maNV\t" +
        "$_tenNV\t" +
        "$_heSoLuong\t" +
        "$_phongBan\t" +
        "$_soNgayLV\t" +
        "${tinhLuong()}";
  }
}
