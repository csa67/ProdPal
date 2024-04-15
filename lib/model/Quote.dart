class Quote {
  final int id;
  final String content;
  final String author;
  bool isFavorite;

  Quote(
      {required this.id,
      required this.content,
      this.author = "Unknown",
      this.isFavorite = false});

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}

class DummyQuoteService {
  final List<Quote> _quotes = [
    Quote(
        id: 1,
        content:
            "Success is not final; failure is not fatal: It is the courage to continue that counts."),
    Quote(
        id: 2,
        content: "The secret of getting ahead is getting started.",
        author: "Mark Twain"),
    Quote(
        id: 3,
        content:
            "You don't have to be great to start, but you have to start to be great.",
        author: "Zig Ziglar"),
    Quote(
        id: 4,
        content: "Don't watch the clock; do what it does. Keep going.",
        author: "Sam Levenson"),
    Quote(
        id: 5,
        content:
            "The only way to achieve the impossible is to believe it is possible.",
        author: "Charles Kingsleigh(from Alice in Wonderland)"),
    Quote(
        id: 6,
        content: "You miss 100% of the shots you don't take.",
        author: "Wayne Gretzky"),
    Quote(
        id: 7,
        content: "The way to get started is to quit talking and begin doing.",
        author: "Walt Disney"),
    Quote(
        id: 8,
        content: "The only person you are destined to become is the person you decide to be.",
        author: "Ralph Waldo Emerson"),
    Quote(
        id: 9,
        content: "The future depends on what you do today.",
        author: "Mahatma Gandhi"),
    Quote(
        id: 10,
        content: "You are never too old to set another goal or to dream a new dream.",
        author: "C.S. Lewis"),
    Quote(
      id:11,
      content: "The difference between ordinary and extraordinary is that little extra.",
      author: "Jimmy Johnson"
    ),
  ];

  Future<Quote> fetchRandomQuote() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _quotes[(DateTime.now().millisecondsSinceEpoch % _quotes.length)];
  }
}
