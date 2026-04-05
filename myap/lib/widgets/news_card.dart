import 'package:flutter/material.dart';
import '../models/news.dart';

/// Reusable card widget displaying news items in the analysis flow.
class NewsCard extends StatelessWidget {
  final NewsItem news;
  final VoidCallback? onAnalyze;

  const NewsCard({super.key, required this.news, this.onAnalyze});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(news.category, style: const TextStyle(fontSize: 12, color: Colors.indigo)),
                Text(news.source, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text(news.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(news.snippet, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            if (onAnalyze != null) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: onAnalyze,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Analyze'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
