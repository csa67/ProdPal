class Mood {
  final String label;
  final String emojiGreyPath;
  final String emojiColorPath;

  Mood(this.label, this.emojiGreyPath, this.emojiColorPath);
}

final List<Mood> moods = [
  Mood('Terrible', 'assets/terrible_grey.png', 'assets/terrible_color.png'),
  Mood('Bad', 'assets/bad_grey.png', 'assets/bad_color.png'),
  Mood('Okay', 'assets/okay_grey.png', 'assets/okay_color.png'),
  Mood('Good', 'assets/good_grey.png', 'assets/good_color.png'),
  Mood('Excellent', 'assets/ex_grey.png', 'assets/ex_color.png'),
];