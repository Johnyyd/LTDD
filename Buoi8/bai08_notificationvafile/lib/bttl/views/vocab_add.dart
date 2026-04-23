import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/bai4.dart';
import '../services/bai1.dart';

class VocabAdd extends StatefulWidget {
  const VocabAdd({super.key});

  @override
  State<VocabAdd> createState() => _VocabAddState();
}

class _VocabAddState extends State<VocabAdd> {
  final TextEditingController wordController = TextEditingController();
  final TextEditingController meaningController = TextEditingController();
  final VocabularyService vocabService = VocabularyService();
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    // Ensure notification service is ready
    notificationService.init();
  }

  void _saveAndRemind() async {
    final wordText = wordController.text.trim();
    final meaningText = meaningController.text.trim();

    if (wordText.isEmpty || meaningText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ từ và nghĩa")),
      );
      return;
    }

    final newWord = Word(original: wordText, meaning: meaningText);

    // 1. Save to file
    await vocabService.appendWord(newWord);

    // 2. Show immediately notification & SnackBar
    await notificationService.showSimpleNotification(
      title: "Đã lưu từ mới",
      body: "Hãy ôn tập từ '$wordText' sau 10 phút nhé!",
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đã lưu từ: $wordText. Nhắc học sau 10 phút."),
          backgroundColor: Colors.green,
        ),
      );
    }

    // 3. Schedule 10-minute reminder
    await notificationService.scheduleNotificationAfter(
      const Duration(minutes: 10),
      "vocab_reminder_channel",
      "Ôn tập từ vựng",
      "Đã đến lúc ôn tập từ '$wordText' ($meaningText)!",
    );

    // Clear inputs
    wordController.clear();
    meaningController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm từ vựng mới")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Thêm từ mới vào kho kiến thức của bạn",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: wordController,
              decoration: const InputDecoration(
                labelText: "Từ (English)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: meaningController,
              decoration: const InputDecoration(
                labelText: "Nghĩa (Tiếng Việt)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.translate),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveAndRemind,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Lưu và Nhắc học sau 10 phút",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
