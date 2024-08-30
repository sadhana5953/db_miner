// {
// "message": "All Quotes Fetched Successfully",
// "Quotes": [
// {
// "id": 1,
// "category": "Inspiration",
// "quote": "The only way to do great work is to love what you do.",
// "author": "Steve Jobs",
// "description": "Encouraging quote about the importance of passion in work."
// },]

class QuotesModal {
  List<QuotesList> quotes = [];

  QuotesModal({required this.quotes});

  factory QuotesModal.fromMap(Map m1) {
    return QuotesModal(
        quotes:
        (m1['Quotes'] as List).map((e) => QuotesList.fromMap(e)).toList());
  }
}

class QuotesList {
  late String category, quote, author, description;

  QuotesList(
      {required this.category,
        required this.author,
        required this.quote,
        required this.description});

  factory QuotesList.fromMap(Map m1) {
    return QuotesList(
        category: m1['category'],
        author: m1['author'],
        quote: m1['quote'],
        description: m1['description']);
  }
}