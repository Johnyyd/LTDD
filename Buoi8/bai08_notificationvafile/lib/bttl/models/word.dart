class Word {
  final String original;
  final String meaning;

  Word({required this.original, required this.meaning});

  // Convert Word object to a string for file storage
  String toFileString() {
    return "$original|$meaning";
  }

  // Parse Word object from a string line in the file
  static Word fromString(String line) {
    final parts = line.split("|");
    if (parts.length < 2) {
      return Word(original: "Unknown", meaning: "Unknown");
    }
    return Word(original: parts[0], meaning: parts[1]);
  }
}
