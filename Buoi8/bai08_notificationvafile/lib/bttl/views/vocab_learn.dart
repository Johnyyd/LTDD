import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/bai4.dart';
import '../services/bai1.dart';

class VocabLearn extends StatefulWidget {
  const VocabLearn({super.key});

  @override
  State<VocabLearn> createState() => _VocabLearnState();
}

class _VocabLearnState extends State<VocabLearn> {
  final VocabularyService vocabService = VocabularyService();
  final NotificationService notificationService = NotificationService();
  final TextEditingController answerController = TextEditingController();

  List<Word> words = [];
  int currentIndex = 0;
  int correctCount = 0;
  int wrongCount = 0;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    notificationService.init();
    _loadWords();
  }

  void _loadWords() async {
    words = await vocabService.loadWords();
    words.shuffle(); // Shuffle for learning
    setState(() {});
  }

  void _checkAnswer() async {
    if (words.isEmpty) return;
    
    final currentWord = words[currentIndex];
    final answer = answerController.text.trim().toLowerCase();
    final correctAnswer = currentWord.meaning.trim().toLowerCase();

    bool isCorrect = answer == correctAnswer;

    if (isCorrect) {
      correctCount++;
    } else {
      wrongCount++;
      // Notify if wrongCount is a multiple of 3
      if (wrongCount > 0 && wrongCount % 3 == 0) {
        await notificationService.showSimpleNotification(
          title: "Cố gắng lên!",
          body: "Bạn đã trả lời sai $wrongCount câu rồi. Hãy tập trung hơn nhé!",
        );
      }
    }

    if (currentIndex < words.length - 1) {
      currentIndex++;
      answerController.clear();
    } else {
      finished = true;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Học từ")),
        body: const Center(child: Text("Kho từ vựng đang trống. Hãy thêm từ mới!")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Học từ"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: finished ? _buildFinishView() : _buildStudyView(),
      ),
    );
  }

  Widget _buildStudyView() {
    final currentWord = words[currentIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildScoreCounter("Đúng", correctCount, Colors.green),
            _buildScoreCounter("Sai", wrongCount, Colors.red),
          ],
        ),
        const SizedBox(height: 48),
        const Text(
          "Từ này có nghĩa là gì?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Text(
          currentWord.original,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: answerController,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: "Nhập nghĩa tiếng Việt",
            border: UnderlineInputBorder(),
          ),
          onSubmitted: (_) => _checkAnswer(),
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: _checkAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text("Check"),
        ),
      ],
    );
  }

  Widget _buildFinishView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration, size: 80, color: Colors.orange),
          const SizedBox(height: 24),
          const Text("Hoàn thành!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text("Đúng: $correctCount - Sai: $wrongCount", style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Quay lại"),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCounter(String label, int value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withAlpha(50),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "$value",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}
