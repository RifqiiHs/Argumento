import 'package:flutter/material.dart';
import '../models/news.dart';
import '../widgets/custom_button.dart';

/// Result screen that shows feedback after a news analysis decision.
/// Displays whether the answer was correct and a learning explanation.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as AnalysisResult?;
    final result = args ?? AnalysisResult(
      news: const NewsItem(
        title: 'Berita tidak tersedia',
        source: '-',
        snippet: '-',
        correctAnswer: 'Real',
        explanation: 'Data berita tidak ditemukan.',
        category: 'General',
      ),
      isCorrect: false,
      selectedAnswer: 'Real',
      rewardXp: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    result.isCorrect ? Icons.check_circle : Icons.cancel,
                    color: result.isCorrect ? Colors.green : Colors.red,
                    size: 84,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    result.isCorrect ? 'Jawaban Kamu Tepat!' : 'Jawaban Kamu Kurang Tepat',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey.shade900),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Kamu memilih: ${result.selectedAnswer}',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    result.news.explanation,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    '+${result.rewardXp} XP',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 28),
                  CustomButton(
                    label: 'Kembali ke Dashboard',
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
