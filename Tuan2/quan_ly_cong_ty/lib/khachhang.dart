import 'hoadon.dart' as hoadon;

class Khachhang {
  String? _maKH;
  String? _tenKH;
  String? _diaChi;
  String? _soDT;

  // getter
  String? get getMaKH => _maKH;
  String? get getTenKH => _tenKH;
  String? get getDiaChi => _diaChi;
  String? get getSoDT => _soDT;

  // setter
  set setMaKH(String? maKH) {
    _maKH = maKH;
  }

  set setTenKH(String? tenKH) {
    _tenKH = tenKH;
  }

  set setDiaChi(String? diaChi) {
    _diaChi = diaChi;
  }

  set setSoDT(String? soDT) {
    _soDT = soDT;
  }

  // Constructor mặc định
  Khachhang() {
    _maKH = "KH000";
    _tenKH = "Unknown";
    _diaChi = "Unknown";
    _soDT = "Unknown";
  }

  // Constructor có đầy đủ các tham số
  Khachhang.full(String? maKH, String? tenKH, String? diaChi, String? soDT) {
    _maKH = maKH;
    _tenKH = tenKH;
    _diaChi = diaChi;
    _soDT = soDT;
  }

  // Phương thức
  // Quản lý danh sách hóa đơn
  final List<hoadon.HoaDon> _danhSachHoaDon = [];
  void themHoaDon(hoadon.HoaDon hd) {
    _danhSachHoaDon.add(hd);
  }

  void inDanhSachHoaDon() {
    for (var hd in _danhSachHoaDon) {
      hd.inHoaDon();
    }
  }

  double tinhTongTien() {
    double tong = 0.0;
    for (var hd in _danhSachHoaDon) {
      tong += hd.tongTien;
    }
    return tong;
  }
}

class IndividualKhachHang extends Khachhang {
  final double _distance;
  final int _quantity;

  IndividualKhachHang(
    String? maKH,
    String? tenKH,
    String? diaChi,
    String? soDT,
    this._distance,
    this._quantity,
  ) : super.full(maKH, tenKH, diaChi, soDT);

  double tinhDiscount() {
    double discount = 0.0;
    if (_quantity > 10) {
      discount += 0.1; // 10% discount for quantity
    }
    if (_distance > 50) {
      discount += 0.05; // 5% discount for distance
    }
    return discount;
  }
}

class CompanyKhachHang extends Khachhang {
  final int _tenure;
  final bool _isEmployee;

  CompanyKhachHang(
    String? maKH,
    String? tenKH,
    String? diaChi,
    String? soDT,
    this._tenure,
    this._isEmployee,
  ) : super.full(maKH, tenKH, diaChi, soDT);

  double tinhDiscount() {
    double discount = 0.0;
    if (_tenure > 5) {
      discount += 0.1;
    }
    if (_isEmployee) {
      discount += 0.05;
    }
    return discount;
  }
}
