import 'package:nguyenminhtri_tuan2/phongtro.dart';

class PhongTroA extends PhongTro {
  // Khai báo các thuộc tính
  int _nguoiThan = 0;

  // Khai báo constructor mặc định, kế thừa từ class PhongTro
  // có thêm 1 thuộc tính mới từ class PhongTroA
  PhongTroA() : super() {
    _nguoiThan = 0;
  }

  // Khai báo constructor có tham số, có tên là full với 6 tham số
  PhongTroA.full(
    String ma,
    String ten,
    bool tang,
    double gia,
    int ng,
    int ngay,
    int nguoi,
  ) : super.full(ma, ten, tang, gia, ng, ngay) {
    _nguoiThan = nguoi;
  }

  @override
  String toString() {
    return super.toString() +
        " Người thân:$_nguoiThan" +
        " Tiền thuê: ${tinhTienThue()} ";
  }

  @override
  double tinhTienThue() {
    double tienThue = _nguoiThan * 100000;
    return super.tinhTienThue() + tienThue;
  }
}
