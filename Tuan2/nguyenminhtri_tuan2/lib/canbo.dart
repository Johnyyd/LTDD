import 'package:nguyenminhtri_tuan2/nhanvien.dart';

class CanBo extends NhanVien {
  // Khai báo thuộc tính
  String _chucVu = '';
  double _hsChucVu = 0.0;

  // Khai báo constructor mặc định kế thức từ class NhanVien
  // có thêm 2 thuộc tính mới từ class CanBo
  CanBo() : super() {
    _chucVu = "Unknown";
    _hsChucVu = 0.0;
  }

  // Khai báo constructor có tham số kế thức từ class NhanVien
  // có thêm 2 thuộc tính mới từ class CanBo
  CanBo.fullPara(
    String ma,
    String ten,
    double hs,
    String phong,
    double ngay,
    String cv,
    double hscv,
  ) : super.fullPara(ma, ten, hs, phong, ngay) {
    _chucVu = cv;
    _hsChucVu = hscv;
  }
  // overiding toString() trả về chuỗi thông tin của CanBo
  // có thể hiểu là 1 hàm hiển thị kết quả, thông tin
  // kế thừa từ class NhanVien
  @override
  String toString() {
    return super.toString() + "\t" + "$_chucVu\t" + "$_hsChucVu";
  }

  // Hàm tính lương kế thừa từ class NhanVien
  @override
  double tinhLuong() {
    return super.tinhLuong() * _hsChucVu * 1100;
  }
}
