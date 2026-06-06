import 'package:nguyenminhtri_tuan2/phongtro.dart';

class PhongTroB extends PhongTro {
  // Khai báo các thuộc tính
  bool _giatUi = true;
  bool _interet = true;

  // Khai báo constructor mặc định, kế thừa từ class PhongTro
  // có thêm 2 thuộc tính mới từ class PhongTroB
  PhongTroB() : super() {
    _giatUi = true;
    _interet = true;
  }

  // Khai báo constructor có tham số, có tên là full với  3 tham số
  PhongTroB.full(
    String ma,
    String ten,
    bool tang,
    double gia,
    int ng,
    int ngay,
    bool giat,
    bool interet,
  ) : super.full(ma, ten, tang, gia, ng, ngay) {
    _giatUi = giat;
    _interet = interet;
  }

  @override
  String toString() {
    return super.toString() +
        " Giặt ủi: $_giatUi" +
        " Internet: $_interet" +
        " Tiền thuê: ${tinhTienThue()} ";
  }

  @override
  double tinhTienThue() {
    double tienThue = 0;
    if (_giatUi == true) {
      tienThue += 200000;
    }
    if (_interet == true) {
      tienThue += 200000;
    }
    return super.tinhTienThue() + tienThue;
  }
}
