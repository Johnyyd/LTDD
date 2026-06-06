class MonHoc {
  // Khai báo các thuộc tính
  late String _maMH;
  late String _tenMH;
  late int _soTC;
  late double _diem;

  // Khai báo constructor mặc định, không có tham số
  MonHoc() {
    _maMH = "MH000";
    _tenMH = "Unknown";
    _soTC = 0;
    _diem = 0.0;
  }

  // Khai báo constructor có tham số, có tên là maVaTen có 2 tham số
  MonHoc.maVaTen(String ma, String ten) {
    _maMH = ma;
    _tenMH = ten;
    _soTC = 0;
    _diem = 0.0;
  }

  // Khai báo constructor có tham số, có tên là full có 4 tham số
  MonHoc.full(String ma, String ten, int sotc, double diem) {
    _maMH = ma;
    _tenMH = ten;
    _soTC = sotc;
    _diem = diem;
  }

  // getter và setter cho các thuộc tính
  // Phương thức giao tiếp với bên ngoài

  // getter cho _maMH
  String get maMh => _maMH;

  // setter cho _maMH
  set maMH(String value) {
    if (value.isNotEmpty) {
      _maMH = value;
    }
  }

  // getter cho _tenMH
  String get tenMH {
    return _tenMH;
  }

  // setter cho _tenMH
  set tenMH(String value) {
    if (value.isNotEmpty) {
      _tenMH = value;
    }
  }

  // getter cho _soTC
  int get soTC {
    return _soTC;
  }

  // setter cho _soTC
  set soTC(int value) {
    if (value > 0 && value < 15) {
      _soTC = value;
    }
  }

  // getter cho _diem
  double get diem {
    return _diem;
  }

  // setter cho _diem
  set diem(double value) {
    if (value >= 0 && value <= 10) {
      _diem = value;
    }
  }

  // show function
  void showInfo() {
    print(
      "Mã môn học: $_maMH, Tên môn học: $_tenMH, Số tín chỉ: $_soTC, Điểm: $_diem",
    );
  }

  @override
  String toString() {
    return "Mã môn học: $_maMH, Tên môn học: $_tenMH, Số tín chỉ: $_soTC, Điểm: $_diem";
  }
}
