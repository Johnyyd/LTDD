import 'package:flutter/material.dart';

class lab6 extends StatelessWidget {
  const lab6({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nguyễn Minh Trí',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const lab6Page(title: 'Nguyễn Minh Trí'),
    );
  }
}

class lab6Page extends StatefulWidget {
  const lab6Page({super.key, required this.title});
  final String title;

  @override
  State<lab6Page> createState() => _lab6PageState();
}

class _lab6PageState extends State<lab6Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 250,
          height: 100,
          child: ElevatedButton(child: Text("Button "), onPressed: () {}),
        ),
      ),
    );
  }
}
