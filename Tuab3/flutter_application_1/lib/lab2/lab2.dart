import 'package:flutter/material.dart';

class lab2 extends StatelessWidget {
  const lab2({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nguyễn Minh Trí',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const lab2Page(title: 'Nguyễn Minh Trí'),
    );
  }
}

class lab2Page extends StatefulWidget {
  const lab2Page({super.key, required this.title});
  final String title;

  @override
  State<lab2Page> createState() => _lab2PageState();
}

class _lab2PageState extends State<lab2Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(width: 290, height: 190, color: Colors.green),
            Container(width: 250, height: 170, color: Colors.red),
            Container(width: 220, height: 150, color: Colors.yellow),
          ],
        ),
      ),
    );
  }
}
