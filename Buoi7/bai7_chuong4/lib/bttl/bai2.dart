import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- Bài 2: Tìm đường đi cơ bản ---
// File này cung cấp giao diện đơn giản để nhập tọa độ hoặc chạm bản đồ để tìm đường.
class Bai2 extends StatefulWidget {
  const Bai2({super.key});

  @override
  State<Bai2> createState() => _Bai2State();
}

class _Bai2State extends State<Bai2> {
  // Điều khiển Google Map thông qua Completer
  final Completer<GoogleMapController> _controller = Completer();

  // Quản lý các đối tượng hiển thị trên bản đồ
  final Set<Marker> _markers = {}; // Các điểm đánh dấu
  final Set<Polyline> _polylines = {}; // Các đoạn thẳng/đường đi nối các điểm

  // Controller để lấy dữ liệu từ các ô nhập liệu
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  LatLng? _startLatLng; // Tọa độ điểm bắt đầu
  LatLng? _endLatLng; // Tọa độ điểm kết thúc
  bool _isSimulated =
      false; // Chế độ "Free Route" (Sử dụng OSRM thay vì Google API)

  // API Key dùng chung cho dự án
  final String _apiKey = "AIzaSyAiNR7CtH5SJPODhh4Miq0vzK_wsah_Ko0";

  // Vị trí mặc định khi mở bản đồ (TP.HCM)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Tự động xác định vị trí người dùng khi bắt đầu
  }

  // Hàm lấy vị trí hiện tại và điền vào ô "Xuất phát"
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _startLatLng = LatLng(position.latitude, position.longitude);
      _addMarker(_startLatLng!, "Xuất phát", Colors.green);
      // Hiển thị tọa độ vĩ độ, kinh độ lên ô nhập liệu
      _startController.text = "${position.latitude}, ${position.longitude}";
      _moveCamera(_startLatLng!);
    });
  }

  // Hàm thêm hoặc cập nhật Marker trên bản đồ
  void _addMarker(LatLng position, String id, Color color) {
    setState(() {
      _markers.removeWhere((m) => m.markerId.value == id);
      _markers.add(
        Marker(
          markerId: MarkerId(id),
          position: position,
          infoWindow: InfoWindow(title: id),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            id == "Xuất phát"
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
        ),
      );
    });
  }

  // Di chuyển góc nhìn Camera của bản đồ
  Future<void> _moveCamera(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
  }

  // Xử lý khi người dùng chạm vào một điểm trên bản đồ
  void _onMapTap(LatLng position) {
    setState(() {
      // Nếu ô xuất phát trống, gán điểm chạm làm điểm xuất phát
      if (_startController.text.isEmpty) {
        _startLatLng = position;
        _startController.text = "${position.latitude}, ${position.longitude}";
        _addMarker(position, "Xuất phát", Colors.green);
      } else {
        // Nếu đã có điểm xuất phát, gán điểm chạm làm đích đến
        _endLatLng = position;
        _endController.text = "${position.latitude}, ${position.longitude}";
        _addMarker(position, "Đích đến", Colors.red);
        _findRoute(); // Tự động tìm đường ngay sau khi chọn xong
      }
    });
  }

  // Hàm chính để xử lý yêu cầu tìm đường
  Future<void> _findRoute() async {
    if (_startController.text.isEmpty || _endController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn cả hai điểm!')),
      );
      return;
    }

    try {
      // Phân tách chuỗi tọa độ từ ô nhập liệu thành số double
      List<String> start = _startController.text.split(',');
      List<String> end = _endController.text.split(',');
      _startLatLng = LatLng(
        double.parse(start[0].trim()),
        double.parse(start[1].trim()),
      );
      _endLatLng = LatLng(
        double.parse(end[0].trim()),
        double.parse(end[1].trim()),
      );

      // Nếu đang bật Simulation (Free Route), dùng OSRM để tránh phí Google
      if (_isSimulated) {
        _getFreeDirections();
        return;
      }

      // URL gọi Google Directions API
      String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${_startLatLng!.latitude},${_startLatLng!.longitude}&destination=${_endLatLng!.latitude},${_endLatLng!.longitude}&key=$_apiKey";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          String polylinePoints =
              data['routes'][0]['overview_polyline']['points'];
          List<LatLng> points = _decodePolyline(polylinePoints);

          setState(() {
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                points: points,
                color: Colors.blue,
                width: 5,
              ),
            );
          });
          _fitRoute(); // Zoom ra để thấy cả 2 điểm
        } else {
          // Hiển thị lỗi từ Google (VD: Billing not enabled)
          String status = data['status'];
          String error = data['error_message'] ?? "Không tìm thấy đường đi.";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi ($status): $error'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  // Hàm lấy đường đi thật theo mặt đường MIỄN PHÍ dùng OSRM
  Future<void> _getFreeDirections() async {
    final url =
        "http://router.project-osrm.org/route/v1/driving/"
        "${_startLatLng!.longitude},${_startLatLng!.latitude};"
        "${_endLatLng!.longitude},${_endLatLng!.latitude}"
        "?overview=full&geometries=polyline";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 'Ok' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];

          setState(() {
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                points: _decodePolyline(route['geometry']),
                color: Colors.blueAccent,
                width: 5,
              ),
            );
          });
          _fitRoute();
        }
      }
    } catch (e) {
      debugPrint("OSRM Error: $e");
    }
  }

  // Tự động điều chỉnh bản đồ để hiển thị toàn bộ lộ trình
  Future<void> _fitRoute() async {
    if (_startLatLng == null || _endLatLng == null) return;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        _getLatLngBounds(_startLatLng!, _endLatLng!),
        70.0,
      ),
    );
  }

  // Helper tính toán khung nhìn chứa cả 2 tọa độ
  LatLngBounds _getLatLngBounds(LatLng p1, LatLng p2) {
    double minLat = p1.latitude < p2.latitude ? p1.latitude : p2.latitude;
    double maxLat = p1.latitude > p2.latitude ? p1.latitude : p2.latitude;
    double minLng = p1.longitude < p2.longitude ? p1.longitude : p2.longitude;
    double maxLng = p1.longitude > p2.longitude ? p1.longitude : p2.longitude;
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // Giải mã chuỗi Polyline thành danh sách các điểm LatLng (Chuẩn Google)
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Finder (Bai 2)'),
        actions: [
          // Điều khiển chế độ Free Route
          Row(
            children: [
              const Text("Free Route", style: TextStyle(fontSize: 12)),
              Switch(
                value: _isSimulated,
                onChanged: (val) {
                  setState(() => _isSimulated = val);
                  if (_startLatLng != null && _endLatLng != null) _findRoute();
                },
              ),
            ],
          ),
          // Nút Reset nhanh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _startController.clear();
                _endController.clear();
                _markers.clear();
                _polylines.clear();
                _startLatLng = null;
                _endLatLng = null;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Phần nhập liệu tọa độ
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _startController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm xuất phát (Chạm bản đồ hoặc nhập)',
                  ),
                ),
                TextField(
                  controller: _endController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm đích (Chạm bản đồ hoặc nhập)',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _findRoute,
                  child: const Text('Tìm đường đi'),
                ),
              ],
            ),
          ),
          // Phần hiển thị bản đồ
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (controller) => _controller.complete(controller),
              onTap: _onMapTap,
              myLocationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
