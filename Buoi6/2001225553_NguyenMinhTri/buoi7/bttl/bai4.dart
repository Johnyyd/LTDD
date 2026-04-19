import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

// --- Models ---
class FavoriteRoute {
  final int? id;
  final String name;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final String travelMode;

  FavoriteRoute({
    this.id,
    required this.name,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.travelMode,
  });

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

// --- Database Helper ---
class DatabaseHelper {
  static Database? _database;
  static final String tableName = 'favorites';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  _initDb() async {
    String path = p.join(await getDatabasesPath(), 'maps_favorites.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, start_lat REAL, start_lng REAL, end_lat REAL, end_lng REAL, travel_mode TEXT)",
      );
    });
  }

  Future<int> insertFavorite(FavoriteRoute route) async {
    Database db = await database;
    return await db.insert(tableName, route.toMap());
  }

  Future<List<FavoriteRoute>> getFavorites() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => FavoriteRoute.fromMap(maps[i]));
  }

  Future<int> deleteFavorite(int id) async {
    Database db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

// --- Main Widget ---
class Bai4 extends StatefulWidget {
  const Bai4({super.key});

  @override
  State<Bai4> createState() => _Bai4State();
}

class _Bai4State extends State<Bai4> {
  final Completer<GoogleMapController> _controller = Completer();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  final String _apiKey = "YOUR_API_KEY"; // REPLACE WITH REAL API KEY

  // State variables
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _currentPosition;
  LatLng? _startPoint;
  LatLng? _endPoint;
  String _distance = "";
  String _duration = "";
  String _travelMode = "driving"; // driving, walking, bicycling
  
  final TextEditingController _searchController = TextEditingController();
  List<FavoriteRoute> _favorites = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final favorites = await _dbHelper.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  // --- API Methods ---

  Future<void> _getDirections() async {
    if (_startPoint == null || _endPoint == null) return;

    final url = "https://maps.googleapis.com/maps/api/directions/json?origin=${_startPoint!.latitude},${_startPoint!.longitude}&destination=${_endPoint!.latitude},${_endPoint!.longitude}&mode=$_travelMode&key=$_apiKey";
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];
          
          setState(() {
            _distance = leg['distance']['text'];
            _duration = leg['duration']['text'];
            _polylines.clear();
            _polylines.add(Polyline(
              polylineId: const PolylineId('route'),
              points: _decodePolyline(route['overview_polyline']['points']),
              color: Colors.blue,
              width: 5,
            ));
          });
          
          // Fit camera to show the whole route
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newLatLngBounds(
            _getLatLngBounds(_startPoint!, _endPoint!),
            50.0,
          ));
        }
      }
    } catch (e) {
      debugPrint("Error fetching directions: $e");
    }
  }

  Future<void> _searchAndGo(String address) async {
    final url = "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$_apiKey";
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          final latLng = LatLng(location['lat'], location['lng']);
          
          _moveCamera(latLng);
          _setPoint(latLng, "Search Result");
        }
      }
    } catch (e) {
      debugPrint("Error geocoding: $e");
    }
  }

  Future<void> _searchNearby(String type) async {
    if (_currentPosition == null) return;
    
    final url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=2000&type=$type&key=$_apiKey";
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];
        
        setState(() {
          _markers.clear();
          if (_startPoint != null) _addMarker(_startPoint!, "start", Colors.green);
          if (_endPoint != null) _addMarker(_endPoint!, "end", Colors.red);
          
          for (var item in results.take(10)) {
            final loc = item['geometry']['location'];
            final latLng = LatLng(loc['lat'], loc['lng']);
            _markers.add(Marker(
              markerId: MarkerId(item['place_id']),
              position: latLng,
              infoWindow: InfoWindow(title: item['name']),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            ));
          }
        });
      }
    } catch (e) {
      debugPrint("Error searching nearby: $e");
    }
  }

  // --- Helpers ---

  void _setPoint(LatLng point, String title) {
    setState(() {
      if (_startPoint == null) {
        _startPoint = point;
        _addMarker(point, "start", Colors.green);
      } else {
        _endPoint = point;
        _addMarker(point, "end", Colors.red);
        _getDirections();
      }
    });
  }

  void _addMarker(LatLng position, String id, Color color) {
    _markers.removeWhere((m) => m.markerId.value == id);
    _markers.add(Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        id == "start" ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
      ),
    ));
  }

  Future<void> _moveCamera(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
  }

  LatLngBounds _getLatLngBounds(LatLng p1, LatLng p2) {
    double minLat = p1.latitude < p2.latitude ? p1.latitude : p2.latitude;
    double maxLat = p1.latitude > p2.latitude ? p1.latitude : p2.latitude;
    double minLng = p1.longitude < p2.longitude ? p1.longitude : p2.longitude;
    double maxLng = p1.longitude > p2.longitude ? p1.longitude : p2.longitude;
    return LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng));
  }

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
        title: const Text('Map Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => _showFavorites(),
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.7769, 106.7009),
              zoom: 12,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) => _controller.complete(controller),
            onTap: (point) => _setPoint(point, "Selected Point"),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          
          // Top Search Bar
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Card(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search address...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _searchAndGo(_searchController.text),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onSubmitted: _searchAndGo,
                  ),
                ),
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

          // Bottom Info Panel
          if (_distance.isNotEmpty)
            Positioned(
              bottom: 110,
              left: 10,
              right: 10,
              child: Card(
                color: Colors.white.withAlpha(230),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Distance: $_distance", style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text("Duration: $_duration"),
                        ],
                      ),
                      Row(
                        children: [
                          _modeButton("driving", Icons.directions_car),
                          _modeButton("walking", Icons.directions_walk),
                          _modeButton("bicycling", Icons.directions_bike),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "save",
            onPressed: () => _saveCurrentRoute(),
            child: const Icon(Icons.save),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "swap",
            onPressed: () {
              setState(() {
                final temp = _startPoint;
                _startPoint = _endPoint;
                _endPoint = temp;
                _markers.clear();
                if (_startPoint != null) _addMarker(_startPoint!, "start", Colors.green);
                if (_endPoint != null) _addMarker(_endPoint!, "end", Colors.red);
                _getDirections();
              });
            },
            child: const Icon(Icons.swap_vert),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "dest",
            onPressed: () {
               if (_currentPosition != null) {
                 _endPoint = _currentPosition;
                 _addMarker(_endPoint!, "end", Colors.red);
                 _getDirections();
               }
            },
            tooltip: "Set current as destination",
            child: const Icon(Icons.flag),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "loc",
            onPressed: () async {
              await _getCurrentLocation();
              if (_currentPosition != null) _moveCamera(_currentPosition!);
            },
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }

  Widget _typeChip(String type, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ActionChip(
        avatar: Icon(icon, size: 16),
        label: Text(type),
        onPressed: () => _searchNearby(type),
      ),
    );
  }

  Widget _modeButton(String mode, IconData icon) {
    bool selected = _travelMode == mode;
    return IconButton(
      icon: Icon(icon, color: selected ? Colors.blue : Colors.grey),
      onPressed: () {
        setState(() {
          _travelMode = mode;
          _getDirections();
        });
      },
    );
  }

  void _saveCurrentRoute() async {
    if (_startPoint == null || _endPoint == null) return;
    
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Save Favorite"),
        content: TextField(controller: nameController, decoration: const InputDecoration(hintText: "Enter name")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final route = FavoriteRoute(
                name: nameController.text.isEmpty ? "Saved Route" : nameController.text,
                startLat: _startPoint!.latitude,
                startLng: _startPoint!.longitude,
                endLat: _endPoint!.latitude,
                endLng: _endPoint!.longitude,
                travelMode: _travelMode,
              );
              await _dbHelper.insertFavorite(route);
              _loadFavorites();
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showFavorites() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final f = _favorites[index];
          return ListTile(
            title: Text(f.name),
            subtitle: Text("Mode: ${f.travelMode}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await _dbHelper.deleteFavorite(f.id!);
                _loadFavorites();
                if (mounted) Navigator.pop(context);
              },
            ),
            onTap: () {
              setState(() {
                _startPoint = LatLng(f.startLat, f.startLng);
                _endPoint = LatLng(f.endLat, f.endLng);
                _travelMode = f.travelMode;
                _markers.clear();
                _addMarker(_startPoint!, "start", Colors.green);
                _addMarker(_endPoint!, "end", Colors.red);
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
