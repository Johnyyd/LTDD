import 'package:flutter/material.dart';

class lab5 extends StatelessWidget {
  const lab5({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nguyễn Minh Trí',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const lab5Page(title: 'Nguyễn Minh Trí'),
    );
  }
}

class lab5Page extends StatefulWidget {
  const lab5Page({super.key, required this.title});
  final String title;

  @override
  State<lab5Page> createState() => _lab5PageState();
}

class _lab5PageState extends State<lab5Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          children: [
            ElevatedButton(child: Text("B1"), onPressed: () {}),
            Icon(Icons.ac_unit, size: 32, color: Colors.red),
            ElevatedButton(
              child: Text("B2"),
              onPressed: () {},
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(50, 100)),
              ),
            ),
            Icon(Icons.add_circle, size: 96, color: Colors.green),
            ElevatedButton(child: Text("Btn 3"), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
