import 'package:flutter/material.dart';

class lab7 extends StatelessWidget {
  const lab7({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nguyễn Minh Trí',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const lab7Page(title: 'Nguyễn Minh Trí'),
    );
  }
}

class lab7Page extends StatefulWidget {
  const lab7Page({super.key, required this.title});
  final String title;

  @override
  State<lab7Page> createState() => _lab7PageState();
}

// 1. Add SingleTickerProviderStateMixin to enable animation
class _lab7PageState extends State<lab7Page>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  // Your original Tween
  final Tween<Offset> _tween = Tween<Offset>(
    begin: const Offset(2, 10),
    end: const Offset(20, 4),
  );

  @override
  void initState() {
    super.initState();
    // 2. Initialize the controller (duration: 3 seconds)
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true); // Cycles back and forth

    // 3. Link the tween to the controller
    _animation = _tween.animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose controllers to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // 4. Use AnimatedBuilder to rebuild the widget every frame
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Calculate current values
            final t = _controller.value; // This is 't' (0.0 to 1.0)
            final currentOffset =
                _animation.value; // This is the calculated x/y

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Animation Running...",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Display dynamic values
                Text(
                  // Using 'toStringAsFixed(2)' to keep numbers readable
                  "t = ${t.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  "x / y = ${currentOffset.dx.toStringAsFixed(2)} / ${currentOffset.dy.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 50),

                // Optional: Visual representation (Scaled up 10x so you can see it move)
                Transform.translate(
                  offset: currentOffset * 10, // Scaling strictly for visibility
                  child: const Icon(Icons.circle, size: 20, color: Colors.blue),
                ),
                const Text(
                  "(Visualizing Offset * 10)",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
