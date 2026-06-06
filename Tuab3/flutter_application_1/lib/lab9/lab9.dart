import 'package:flutter/material.dart';

class lab9 extends StatelessWidget {
  const lab9({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nguyễn Minh Trí',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const lab9Page(title: 'Nguyễn Minh Trí'),
    );
  }
}

class lab9Page extends StatefulWidget {
  const lab9Page({super.key, required this.title});
  final String title;

  @override
  State<lab9Page> createState() => _lab9PageState();
}

class _lab9PageState extends State<lab9Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar Title"),
        leading: IconButton(
          icon: Icon(Icons.notifications_active),
          onPressed: () {
            showAlert(context);
          },
        ),
      ),
      body: Center(child: Text("Hello World.")),
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(content: Text("Hi")),
    );
  }
}
