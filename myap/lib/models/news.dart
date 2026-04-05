class NewsItem {
  final String title;
  final String source;
  final String snippet;
  final String correctAnswer;
  final String explanation;
  final String category;

  const NewsItem({
    required this.title,
    required this.source,
    required this.snippet,
    required this.correctAnswer,
    required this.explanation,
    required this.category,
  });
}

class AnalysisResult {
  final NewsItem news;
  final bool isCorrect;
  final String selectedAnswer;
  final int rewardXp;

  const AnalysisResult({
    required this.news,
    required this.isCorrect,
    required this.selectedAnswer,
    required this.rewardXp,
  });
}
