import 'package:flutter/material.dart';
import 'package:hci/model/Quote.dart';

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  late Quote _currentQuote;
  final _quoteService = DummyQuoteService();

  @override
  void initState() {
    super.initState();
    _loadRandomQuote();
  }

  void _loadRandomQuote() async {
    Quote quote = await _quoteService.fetchRandomQuote();
    setState(() {
      _currentQuote = quote;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motivational Quote')),
      body: _currentQuote == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              _currentQuote.content,
              style: const TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(_currentQuote.isFavorite ? Icons.star : Icons.star_border),
                onPressed: () {
                  setState(() {
                    _currentQuote.toggleFavorite();
                  });
                },
              ),
              ElevatedButton(
                onPressed: _loadRandomQuote,
                child: const Text('Change Quote'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
