import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/word.dart';

class VocabularyService {
  Future<String> get _path async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _file async {
    final path = await _path;
    return File('$path/vocabulary.txt');
  }

  // Save the entire list of words to file
  Future<void> saveWords(List<Word> words) async {
    final file = await _file;
    String data = words.map((w) => w.toFileString()).join("\n");
    await file.writeAsString(data);
  }

  // Load words from file
  Future<List<Word>> loadWords() async {
    try {
      final file = await _file;
      if (!await file.exists()) return [];
      
      final content = await file.readAsString();
      return content
          .split("\n")
          .where((line) => line.isNotEmpty)
          .map((line) => Word.fromString(line))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Add a single word to the existing file
  Future<void> appendWord(Word word) async {
    final words = await loadWords();
    words.add(word);
    await saveWords(words);
  }
}
