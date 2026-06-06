import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trang chủ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AppPage(title: 'Trang chủ'),
    );
  }
}

class AppPage extends StatefulWidget {
  const AppPage({super.key, required this.title});

  final String title;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              "",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(children: [Column(), Column(), Column()]),
          ],
        ),
      ),
    );
  }
}
