import 'package:flutter/material.dart';
import 'bttl/bai1.dart';
import 'bttl/bai2.dart';
import 'bttl/bai4.dart';

void main() {
  runApp(MapNavigatorApp());
}

class MapNavigatorApp extends StatelessWidget {
  const MapNavigatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Navigator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Map Navigator')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Bai1()),
                      );
                    },
                    child:
                        const Text('Bai 1', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Bai2()),
                      );
                    },
                    child:
                        const Text('Bai 2', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Bai4()),
                      );
                    },
                    child:
                        const Text('Bai 4', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
