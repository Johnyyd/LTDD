import 'package:flutter/material.dart';

class lab8 extends StatelessWidget {
  const lab8({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nguyễn Minh Trí',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const lab8Page(title: 'Nguyễn Minh Trí'),
    );
  }
}

class lab8Page extends StatefulWidget {
  const lab8Page({super.key, required this.title});
  final String title;

  @override
  State<lab8Page> createState() => _lab8PageState();
}

class _lab8PageState extends State<lab8Page> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Scaffold Example')),
      body: Center(child: Text('You have pressed the button $_count times.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => this._count++);
        },
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
