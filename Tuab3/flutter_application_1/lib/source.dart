import 'package:flutter/material.dart';

class lab1 extends StatelessWidget {
  const lab1({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nguyễn Minh Trí',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const lab1Page(title: 'Nguyễn Minh Trí'),
    );
  }
}

class lab1Page extends StatefulWidget {
  const lab1Page({super.key, required this.title});
  final String title;

  @override
  State<lab1Page> createState() => _lab1PageState();
}

class _lab1PageState extends State<lab1Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(),
    );
  }
}
