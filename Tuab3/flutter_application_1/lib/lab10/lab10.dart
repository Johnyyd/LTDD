import 'package:flutter/material.dart';

class lab10 extends StatelessWidget {
  const lab10({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nguyễn Minh Trí',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const lab10Page(title: 'Nguyễn Minh Trí'),
    );
  }
}

class lab10Page extends StatefulWidget {
  const lab10Page({super.key, required this.title});
  final String title;

  @override
  State<lab10Page> createState() => _lab10PageState();
}

class _lab10PageState extends State<lab10Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BottomAppBar Example")),
      body: Center(child: Text('Flutter BottomAppBar Example')),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
            PopupMenuButton(
              icon: Icon(Icons.share),
              itemBuilder: (context) => [
                PopupMenuItem(value: 1, child: Text("Facebook")),
                PopupMenuItem(value: 2, child: Text("Instagram")),
              ],
            ),
            IconButton(icon: Icon(Icons.email), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
