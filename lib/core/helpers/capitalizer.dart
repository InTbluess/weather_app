String capitalizeWords(String text) {
  return text
      .trim()
      .split(RegExp(r'\s+'))
      .map((word) {
        if (word.isEmpty) return '';
        word = word.toLowerCase();
        return word[0].toUpperCase() + word.substring(1);
      })
      .join(' ');
}
