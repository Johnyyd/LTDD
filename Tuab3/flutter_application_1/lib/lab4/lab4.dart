import 'package:flutter/material.dart';

class lab4 extends StatelessWidget {
  const lab4({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nguyễn Minh Trí',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const lab4Page(title: 'Nguyễn Minh Trí'),
    );
  }
}

class lab4Page extends StatefulWidget {
  const lab4Page({super.key, required this.title});
  final String title;

  @override
  State<lab4Page> createState() => _lab4PageState();
}

class _lab4PageState extends State<lab4Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          children: <Widget>[
            Text('Begin'),
            Spacer(), // Defaults to a flex of one.
            Text('Middle'),
            // Gives twice the space between Middle and End than Begin and Middle.
            Spacer(flex: 2),
            Text('End'),
          ],
        ),
      ),
    );
  }
}
