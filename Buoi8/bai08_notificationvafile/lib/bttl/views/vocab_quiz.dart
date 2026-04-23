import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/bai4.dart';

class VocabQuiz extends StatefulWidget {
  const VocabQuiz({super.key});

  @override
  State<VocabQuiz> createState() => _VocabQuizState();
}

class _VocabQuizState extends State<VocabQuiz> {
  final VocabularyService vocabService = VocabularyService();
  final TextEditingController answerController = TextEditingController();

  List<Word> questions = [];
  int currentIndex = 0;
  int correctCount = 0;
  int wrongCount = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    questions = await vocabService.loadWords();
    questions.shuffle();
    setState(() {});
  }

  void _submitAnswer() {
    if (questions.isEmpty) return;

    final current = questions[currentIndex];
    final answer = answerController.text.trim().toLowerCase();
    final correctAnswer = current.meaning.trim().toLowerCase();

    if (answer == correctAnswer) {
      correctCount++;
    } else {
      wrongCount++;
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        answerController.clear();
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    int total = questions.length;
    double ratio = total > 0 ? (correctCount / total) * 100 : 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Kết quả kiểm tra"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Số câu đúng: $correctCount"),
            Text("Số câu sai: $wrongCount"),
            const SizedBox(height: 8),
            Text("Tỉ lệ đúng: ${ratio.toStringAsFixed(1)}%"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back home
            },
            child: const Text("Hoàn thành"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Kiểm tra từ")),
        body: const Center(child: Text("Kho từ vựng đang trống.")),
      );
    }

    final current = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kiểm tra từ"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LinearProgressIndicator(value: (currentIndex + 1) / questions.length),
            const SizedBox(height: 24),
            Text(
              "Câu hỏi ${currentIndex + 1}/${questions.length}",
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const Expanded(
              child: Center(
                child: Icon(Icons.psychology, size: 100, color: Colors.blue),
              ),
            ),
            Text(
              current.original,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                hintText: "Nhập đáp án của bạn",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submitAnswer(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitAnswer,
                child: const Text("Gửi đáp án"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
