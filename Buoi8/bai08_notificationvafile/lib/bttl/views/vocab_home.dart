import 'package:flutter/material.dart';
import 'vocab_add.dart';
import 'vocab_learn.dart';
import 'vocab_quiz.dart';
import 'screen_todo_remind.dart'; // Using this as the "Lịch nhắc" or a placeholder

class VocabHome extends StatelessWidget {
  const VocabHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Học từ vựng English"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: GridView.count(
          padding: const EdgeInsets.all(24),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuCard(
              context,
              "Thêm từ",
              Icons.add_circle_outline,
              Colors.orange,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VocabAdd())),
            ),
            _buildMenuCard(
              context,
              "Học từ",
              Icons.menu_book,
              Colors.green,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VocabLearn())),
            ),
            _buildMenuCard(
              context,
              "Kiểm tra từ",
              Icons.quiz_outlined,
              Colors.blue,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VocabQuiz())),
            ),
            _buildMenuCard(
              context,
              "Lịch nhắc",
              Icons.notifications_active_outlined,
              Colors.purple,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScreenTodoRemind())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
