import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

// =============================================================================
// PHẦN 1: MÔ HÌNH DỮ LIỆU (MODELS)
// =============================================================================

/// Lớp [FavoriteRoute] đại diện cho một tuyến đường được người dùng lưu lại.
/// Chứa thông tin về tọa độ điểm đầu, điểm cuối và phương tiện di chuyển.
class FavoriteRoute {
  final int? id; // Định danh duy nhất, tự động tăng trong SQLite
  final String name; // Tên do người dùng đặt (Ví dụ: "Đường đi làm")
  final double startLat; // Vĩ độ điểm bắt đầu
  final double startLng; // Kinh độ điểm bắt đầu
  final double endLat; // Vĩ độ điểm kết thúc
  final double endLng; // Kinh độ điểm kết thúc
  final String travelMode; // Phương tiện: driving, walking, bicycling, two_wheeler

  FavoriteRoute({
    this.id,
    required this.name,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.travelMode,
  });

  /// Chuyển đổi đối tượng Dart thành một [Map] để lưu vào cơ sở dữ liệu SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'start_lat': startLat,
      'start_lng': startLng,
      'end_lat': endLat,
      'end_lng': endLng,
      'travel_mode': travelMode,
    };
  }

  /// Khởi tạo đối tượng từ dữ liệu [Map] lấy ra từ cơ sở dữ liệu SQLite.
  factory FavoriteRoute.fromMap(Map<String, dynamic> map) {
    return FavoriteRoute(
      id: map['id'],
      name: map['name'],
      startLat: map['start_lat'],
      startLng: map['start_lng'],
      endLat: map['end_lat'],
      endLng: map['end_lng'],
      travelMode: map['travel_mode'],
    );
  }
}

// =============================================================================
// PHẦN 2: QUẢN LÝ CƠ SỞ DỮ LIỆU (DATABASE HELPER)
// =============================================================================

/// Lớp [DatabaseHelper] thực hiện các thao tác CRUD (Thêm, Đọc, Xóa) trên SQLite.
class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'favorites';

  /// Getter để lấy đối tượng database, đảm bảo chỉ khởi tạo một lần (Singleton).
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  /// Khởi tạo file database .db trong thư mục ứng dụng của hệ thống.
  Future<Database> _initDb() async {
    String path = p.join(await getDatabasesPath(), 'maps_favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Tạo bảng favorites khi database được tạo lần đầu.
        return db.execute(
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, start_lat REAL, start_lng REAL, end_lat REAL, end_lng REAL, travel_mode TEXT)",
        );
      },
    );
  }

  /// Thêm một mục yêu thích mới vào bảng.
  Future<int> insertFavorite(FavoriteRoute route) async {
    Database db = await database;
    return await db.insert(tableName, route.toMap());
  }

  /// Truy vấn tất cả các bản ghi có trong bảng favorites.
  Future<List<FavoriteRoute>> getFavorites() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => FavoriteRoute.fromMap(maps[i]));
  }

  /// Xóa bản ghi theo ID duy nhất.
  Future<int> deleteFavorite(int id) async {
    Database db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

// =============================================================================
// PHẦN 3: GIAO DIỆN CHÍNH (MAP PRO)
// =============================================================================

class Bai4 extends StatefulWidget {
  const Bai4({super.key});

  @override
  State<Bai4> createState() => _Bai4State();
}

class _Bai4State extends State<Bai4> {
  // --- QUẢN LÝ ĐIỀU KHIỂN & DỮ LIỆU ---
  final Completer<GoogleMapController> _controller = Completer();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  /// Google API Key dùng cho Directions, Geocoding và Places.
  /// Lưu ý: Cần bật Billing trên Google Cloud để các API Pro hoạt động.
  final String _apiKey = "AIzaSyAiNR7CtH5SJPODhh4Miq0vzK_wsah_Ko0"; 

  // --- TRẠNG THÁI GIAO DIỆN (UI STATE) ---
  final Set<Marker> _markers = {}; // Các điểm đánh dấu hiển thị trên Map
  final Set<Polyline> _polylines = {}; // Đường kẻ vẽ lộ trình
  LatLng? _currentPosition; // Vị trí GPS hiện tại của người dùng
  LatLng? _startPoint; // Điểm bắt đầu lộ trình
  LatLng? _endPoint; // Điểm kết thúc lộ trình
  String _distance = ""; // Khoảng cách hiển thị (VD: "5.2 km")
  String _duration = ""; // Thời gian hiển thị (VD: "12 mins")
  String _travelMode = "driving"; // Phương tiện: driving, walking, bicycling, two_wheeler
  bool _isSimulated = true; // Chế độ "Free Route": Sử dụng OSRM/Nominatim miễn phí

  final TextEditingController _searchController = TextEditingController();
  List<FavoriteRoute> _favorites = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Lấy GPS ngay khi mở app
    _loadFavorites(); // Nạp dữ liệu yêu thích từ SQLite
  }

  /// Hàm tải danh sách yêu thích và cập nhật lên State.
  void _loadFavorites() async {
    final favorites = await _dbHelper.getFavorites();
    if (mounted) {
      setState(() {
        _favorites = favorites;
      });
    }
  }

  /// Hàm lấy vị trí GPS hiện tại của thiết bị sử dụng package Geolocator.
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }

  // =============================================================================
  // PHẦN 4: CÁC PHƯƠNG THỨC API (ROUTING & SEARCH)
  // =============================================================================

  /// Phương thức tổng quát để bắt đầu tìm đường.
  /// Sẽ tự động chọn giữa Google API (Pro) hoặc OSRM (Free) dựa trên flag [_isSimulated].
  Future<void> _getDirections() async {
    if (_startPoint == null || _endPoint == null) return;

    if (_isSimulated) {
      _getFreeDirections(); // Chế độ miễn phí
      return;
    }

    // URL gọi Google Directions API
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_startPoint!.latitude},${_startPoint!.longitude}&destination=${_endPoint!.latitude},${_endPoint!.longitude}&mode=$_travelMode&key=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          if (mounted) {
            setState(() {
              _distance = leg['distance']['text'];
              _duration = leg['duration']['text'];
              _polylines.clear();
              // Giải mã chuỗi Google Polyline thành danh sách điểm LatLng
              _polylines.add(
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: _decodePolyline(route['overview_polyline']['points']),
                  color: Colors.blue,
                  width: 5,
                ),
              );
            });
            _fitRoute(); // Zoom Map để thấy toàn bộ hành trình
          }
        } else {
          // Báo lỗi nếu API trả về trạng thái không thành công (VD: REQUEST_DENIED)
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Google Error: ${data['status']} - ${data['error_message'] ?? ''}")),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Lỗi Google Directions: $e");
    }
  }

  /// Phương thức sử dụng OSRM để tìm đường đi thật sự trên mặt đường mà không cần Key.
  Future<void> _getFreeDirections() async {
    // Lưu ý: OSRM nhận tham số theo thứ tự: longitude, latitude
    final url = "http://router.project-osrm.org/route/v1/driving/"
        "${_startPoint!.longitude},${_startPoint!.latitude};"
        "${_endPoint!.longitude},${_endPoint!.latitude}"
        "?overview=full&geometries=polyline";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 'Ok' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final distance = route['distance'] / 1000.0; // Mét -> KM
          final duration = route['duration'] / 60.0; // Giây -> Phút

          if (mounted) {
            setState(() {
              _distance = "${distance.toStringAsFixed(1)} km (Free)";
              _duration = "${duration.toStringAsFixed(0)} min (Free)";
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
      }
    } catch (e) {
      debugPrint("Lỗi OSRM: $e");
    }
  }

  /// Tìm kiếm địa chỉ: Tự động chuyển đổi từ tên địa điểm sang tọa độ.
  /// Sử dụng Nominatim (Miễn phí) khi ở chế độ [_isSimulated].
  Future<void> _searchAndGo(String address) async {
    if (address.isEmpty) return;
    
    // Đảm bảo đã có vị trí xuất phát (Current Location)
    if (_currentPosition == null) {
      await _getCurrentLocation();
    }

    if (_isSimulated) {
      // Nominatim yêu cầu header 'User-Agent' để tuân thủ chính sách sử dụng miễn phí.
      final url = "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&limit=1";
      try {
        final response = await http.get(Uri.parse(url), headers: {'User-Agent': 'FlutterMapApp'});
        if (response.statusCode == 200) {
          final List data = jsonDecode(response.body);
          if (data.isNotEmpty) {
            final latLng = LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
            _setupSearchRoute(latLng);
            return;
          }
        }
      } catch (e) {
        debugPrint("Lỗi Nominatim Search: $e");
      }
    }

    // Google Geocoding: Dành cho tìm kiếm chất lượng cao (Cần Key/Billing)
    final url = "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$_apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final loc = data['results'][0]['geometry']['location'];
          _setupSearchRoute(LatLng(loc['lat'], loc['lng']));
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Search Denied: ${data['status']}")));
          }
        }
      }
    } catch (e) {
      debugPrint("Lỗi Google Search: $e");
    }
  }

  /// Hàm hỗ trợ thiết lập điểm đi là vị trí hiện tại và điểm đến là kết quả search.
  void _setupSearchRoute(LatLng dest) {
    if (mounted) {
      setState(() {
        if (_currentPosition != null) {
          _startPoint = _currentPosition;
          _addMarker(_startPoint!, "start");
        }
        _endPoint = dest;
        _addMarker(_endPoint!, "end");
        _polylines.clear();
      });
      _moveCamera(dest);
      _getDirections();
    }
  }

  /// Tìm và đánh dấu các địa điểm xung quanh (Nhà hàng, khách sạn...) bằng Google Places API.
  Future<void> _searchNearby(String type) async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đang lấy vị trí... thúi")));
      return;
    }

    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=2000&type=$type&key=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'] ?? [];

        if (mounted) {
          setState(() {
            _markers.clear();
            // Giữ lại điểm Start/End nếu có
            if (_startPoint != null) _addMarker(_startPoint!, "start");
            if (_endPoint != null) _addMarker(_endPoint!, "end");

            for (var item in results.take(10)) {
              final loc = item['geometry']['location'];
              _markers.add(
                Marker(
                  markerId: MarkerId(item['place_id']),
                  position: LatLng(loc['lat'], loc['lng']),
                  infoWindow: InfoWindow(title: item['name']),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                ),
              );
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Places Error: $e");
    }
  }

  // =============================================================================
  // PHẦN 5: CÁC TIỆN ÍCH DÀNH CHO BẢN ĐỒ (HELPERS)
  // =============================================================================

  /// Xử lý tap trực tiếp trên bản đồ để chọn điểm.
  void _setPoint(LatLng point) {
    if (mounted) {
      setState(() {
        if (_startPoint == null) {
          _startPoint = point;
          _addMarker(point, "start");
        } else {
          _endPoint = point;
          _addMarker(point, "end");
          _getDirections(); // Tự động tìm đường khi đủ 2 điểm
        }
      });
    }
  }

  /// Đồng bộ hóa danh sách Marker để tránh bị lặp điểm cũ.
  void _addMarker(LatLng position, String id) {
    _markers.removeWhere((m) => m.markerId.value == id);
    _markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(
          title: id == "start" ? "Điểm xuất phát" : "Điểm đích",
          snippet: "Chạm để xem chi tiết",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          id == "start" ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
        ),
      ),
    );
  }

  /// Di chuyển Camera một cách mượt mà.
  Future<void> _moveCamera(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
  }

  /// Tự động zoom bản đồ bao phủ toàn bộ vùng giữa điểm Start và End.
  Future<void> _fitRoute() async {
    if (_startPoint == null || _endPoint == null) return;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(_getLatLngBounds(_startPoint!, _endPoint!), 70.0),
    );
  }

  /// Tính toán tọa độ giới hạn (Bounding Box) để hiển thị trọn vẹn lộ trình.
  LatLngBounds _getLatLngBounds(LatLng p1, LatLng p2) {
    double minLat = p1.latitude < p2.latitude ? p1.latitude : p2.latitude;
    double maxLat = p1.latitude > p2.latitude ? p1.latitude : p2.latitude;
    double minLng = p1.longitude < p2.longitude ? p1.longitude : p2.longitude;
    double maxLng = p1.longitude > p2.longitude ? p1.longitude : p2.longitude;
    return LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng));
  }

  /// Giải mã thuật toán mã hóa Polyline của Google Maps về danh sách LatLng.
  /// Đây là thuật toán tiêu chuẩn dựa trên mã ASCII 64 và bit shift.
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
      shift = 0; result = 0;
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
        title: const Text('Map Pro (Bai 4)'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Nút gạt chế độ Free Route (Nominatim + OSRM)
          Row(
            children: [
              const Text("Free", style: TextStyle(fontSize: 12, color: Colors.blueAccent)),
              Switch(
                value: _isSimulated,
                activeColor: Colors.blueAccent,
                onChanged: (val) {
                  setState(() => _isSimulated = val);
                  if (_startPoint != null && _endPoint != null) _getDirections();
                },
              ),
            ],
          ),
          IconButton(icon: const Icon(Icons.favorite_border, color: Colors.pink), onPressed: _showFavorites),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          // LỚP 1: BẢN ĐỒ
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(10.7769, 106.7009), zoom: 12),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) => _controller.complete(controller),
            onTap: _setPoint,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          
          // LỚP 2: THANH TÌM KIẾM VÀ CHIPS
          Positioned(
            top: 10, left: 10, right: 10,
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 5,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Nhập địa chỉ bạn muốn đến...",
                      prefixIcon: const Icon(Icons.search, color: Colors.blue),
                      suffixIcon: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.blue), onPressed: () => _searchAndGo(_searchController.text)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onSubmitted: _searchAndGo,
                  ),
                ),
                // Thanh cuộn ngang chứa các loại địa điểm tìm kiếm nhanh
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _typeChip("restaurant", Icons.restaurant),
                      _typeChip("hotel", Icons.hotel),
                      _typeChip("hospital", Icons.local_hospital),
                      _typeChip("school", Icons.school),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // LỚP 3: OVERLAY HƯỚNG DẪN
          Positioned(
            top: 125, left: 40, right: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(color: Colors.black.withAlpha(150), borderRadius: BorderRadius.circular(20)),
              child: Text(
                _startPoint == null ? "B1: Chạm chọn điểm xuất phát" : _endPoint == null ? "B2: Chạm chọn điểm đích" : "Đã vẽ lộ trình!",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // LỚP 4: NÚT RESET NHANH (REFRESH)
          Positioned(
            bottom: 200, right: 15,
            child: FloatingActionButton.small(
              heroTag: "refresh",
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  _startPoint = null; _endPoint = null;
                  _markers.clear(); _polylines.clear();
                  _distance = ""; _duration = "";
                });
              },
              child: const Icon(Icons.refresh, color: Colors.blueAccent),
            ),
          ),

          // LỚP 5: THẺ THÔNG TIN LỘ TRÌNH (DISTANCE INFO)
          if (_distance.isNotEmpty)
            Positioned(
              bottom: 110, left: 15, right: 15,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 10,
                color: Colors.white.withAlpha(245),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Cự ly: $_distance", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                          Text("Thời gian: $_duration", style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      // Chọn phương tiện
                      Row(
                        children: [
                          _modeButton("driving", Icons.directions_car),
                          _modeButton("two_wheeler", Icons.motorcycle),
                          _modeButton("walking", Icons.directions_walk),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      // CỘT FAB CHỨC NĂNG (Góc dưới phải)
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(heroTag: "save", onPressed: _saveCurrentRoute, child: const Icon(Icons.bookmark_add)),
          const SizedBox(height: 10),
          FloatingActionButton(heroTag: "swap", onPressed: _swapPoints, child: const Icon(Icons.swap_calls)),
          const SizedBox(height: 10),
          FloatingActionButton(heroTag: "dest", onPressed: _setCurrentAsDest, tooltip: "Chọn tôi làm Đích", child: const Icon(Icons.flag_circle_rounded)),
          const SizedBox(height: 10),
          FloatingActionButton(heroTag: "loc", onPressed: _gotoMe, child: const Icon(Icons.my_location, color: Colors.white), backgroundColor: Colors.blueAccent),
        ],
      ),
    );
  }

  // --- WIDGET RENDERERS ---

  Widget _typeChip(String type, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ActionChip(
        avatar: Icon(icon, size: 16, color: Colors.blue),
        label: Text(type),
        onPressed: () => _searchNearby(type),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _modeButton(String mode, IconData icon) {
    bool selected = _travelMode == mode;
    return IconButton(
      icon: Icon(icon, color: selected ? Colors.blue : Colors.grey, size: 28),
      onPressed: () {
        setState(() => _travelMode = mode);
        _getDirections();
      },
    );
  }

  // =============================================================================
  // PHẦN 6: LOGIC ĐIỀU KHIỂN CHI TIẾT
  // =============================================================================

  void _swapPoints() {
    if (_startPoint == null || _endPoint == null) return;
    setState(() {
      final temp = _startPoint;
      _startPoint = _endPoint;
      _endPoint = temp;
      _markers.clear();
      _addMarker(_startPoint!, "start");
      _addMarker(_endPoint!, "end");
      _getDirections();
    });
  }

  void _setCurrentAsDest() {
    if (_currentPosition != null) {
      setState(() {
        _endPoint = _currentPosition;
        _addMarker(_endPoint!, "end");
        _getDirections();
      });
    }
  }

  void _gotoMe() async {
    await _getCurrentLocation();
    if (_currentPosition != null) _moveCamera(_currentPosition!);
  }

  void _saveCurrentRoute() async {
    if (_startPoint == null || _endPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng chọn đủ 2 điểm trước!")));
      return;
    }

    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Lưu tuyến đường"),
        content: TextField(controller: nameController, decoration: const InputDecoration(hintText: "VD: Nhà bà ngoại")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () async {
              final route = FavoriteRoute(
                name: nameController.text.isEmpty ? "Tuyến đường Lưu" : nameController.text,
                startLat: _startPoint!.latitude, startLng: _startPoint!.longitude,
                endLat: _endPoint!.latitude, endLng: _endPoint!.longitude,
                travelMode: _travelMode,
              );
              await _dbHelper.insertFavorite(route);
              _loadFavorites();
              Navigator.pop(context);
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  void _showFavorites() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => _favorites.isEmpty 
        ? const Center(child: Text("Của tôi chưa có mục nào")) 
        : ListView.builder(
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              final f = _favorites[index];
              return ListTile(
                leading: const Icon(Icons.history_edu, color: Colors.blue),
                title: Text(f.name),
                subtitle: Text("Phương tiện: ${f.travelMode}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                  onPressed: () async {
                    await _dbHelper.deleteFavorite(f.id!);
                    _loadFavorites();
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() {
                    _startPoint = LatLng(f.startLat, f.startLng);
                    _endPoint = LatLng(f.endLat, f.endLng);
                    _travelMode = f.travelMode;
                    _markers.clear();
                    _addMarker(_startPoint!, "start");
                    _addMarker(_endPoint!, "end");
                    _getDirections();
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
    );
  }
}
