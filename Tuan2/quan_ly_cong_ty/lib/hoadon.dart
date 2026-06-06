class HoaDon {
  // Khai báo thuộc tính
  late String _maHD;
  late String _tenKH;
  late DateTime _ngayLap;
  late double _tongTien;

  // Khai báo getter
  String get maHD => _maHD;
  String get tenKH => _tenKH;
  DateTime get ngayLap => _ngayLap;
  double get tongTien => _tongTien;

  // Khai báo setter
  set maHD(String maHD) {
    _maHD = maHD;
  }

  set tenKH(String tenKH) {
    _tenKH = tenKH;
  }

  set ngayLap(DateTime ngayLap) {
    _ngayLap = ngayLap;
  }

  set tongTien(double tongTien) {
    _tongTien = tongTien;
  }

  // Khai báo constructor mặc định
  HoaDon() {
    _maHD = "HD000";
    _tenKH = "Unknown";
    _ngayLap = DateTime.now();
    _tongTien = 0.0;
  }

  // Khai báo constructor có đầy đủ các tham số
  HoaDon.full(String maHD, String tenKH, DateTime ngayLap, double tongTien) {
    _maHD = maHD;
    _tenKH = tenKH;
    _ngayLap = ngayLap;
    _tongTien = tongTien;
  }

  // Khai báo phương thức
  void inHoaDon() {
    print("----- HÓA ĐƠN -----");
    print("Mã hóa đơn: $_maHD");
    print("Tên khách hàng: $_tenKH");
    print("Ngày lập: $_ngayLap");
    print("Tổng tiền: $_tongTien");
  }

  double tinhTongTien(
    double giaSanPham,
    int soLuong,
    double Function() tinhDiscount,
  ) {
    _tongTien = giaSanPham * soLuong;
    double discount = tinhDiscount();
    return _tongTien - (_tongTien * discount);
  }
}
