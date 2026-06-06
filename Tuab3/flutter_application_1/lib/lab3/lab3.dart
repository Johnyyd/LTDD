import 'package:flutter/material.dart';

class lab3 extends StatelessWidget {
  const lab3({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nguyễn Minh Trí',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const lab3Page(title: 'Nguyễn Minh Trí'),
    );
  }
}

class lab3Page extends StatefulWidget {
  const lab3Page({super.key, required this.title});
  final String title;

  @override
  State<lab3Page> createState() => _lab3PageState();
}

class _lab3PageState extends State<lab3Page> {
  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: IndexedStack(
          alignment: Alignment.center,
          index: this.selectedIndex,
          children: <Widget>[
            Container(width: 290, height: 210, color: Colors.green),
            Container(width: 250, height: 170, color: Colors.red),
            Container(width: 220, height: 150, color: Colors.yellow),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("Next"),
        onPressed: () {
          setState(() {
            if (this.selectedIndex < 2) {
              this.selectedIndex++;
            } else {
              this.selectedIndex = 0;
            }
          });
        },
      ),
    );
  }
}
