import 'package:nguyenminhtri_tuan2/monhoc.dart' as monhoc;

class ThucHanh extends monhoc.MonHoc {
  // Khai báo constructor mặc định
  ThucHanh() : super();

  // Khai báo constructor có tham số, có tên là full với 4 tham số
  // Kế thừa từ class monhoc.MonHoc

  ThucHanh.full(String ma, String ten, int sotc, double diem)
    : super.full(ma, ten, sotc, diem);

  @override
  String toString() {
    return super.toString();
  }
}
