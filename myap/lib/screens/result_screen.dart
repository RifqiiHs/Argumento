import 'package:flutter/material.dart';
import '../models/news.dart';
import '../widgets/custom_button.dart';

/// Result screen that shows feedback after a news analysis decision.
/// Displays whether the answer was correct and a learning explanation.
/// Modern dark theme with neon green accents.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as AnalysisResult?;
    final result =
        args ??
        AnalysisResult(
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

    const Color darkBg = Color(0xFF09090b);
    const Color accentColor = Color(0xFF22c55e); // Neon green
    const Color textPrimary = Color(0xFFffffff); // White
    const Color textSecondary = Color(0xFFd4d4d8); // Light gray
    const Color cardBg = Color(0xFF1a1a1e);
    const Color correctColor = Color(0xFF10b981); // Green
    const Color incorrectColor = Color(0xFFef4444); // Red

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Result',
          style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        ),
        backgroundColor: darkBg,
        elevation: 0,
        foregroundColor: accentColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              darkBg,
              Color.alphaBlend(accentColor.withOpacity(0.05), darkBg),
              darkBg,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: accentColor.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      result.isCorrect ? Icons.check_circle : Icons.cancel,
                      color: result.isCorrect ? correctColor : incorrectColor,
                      size: 84,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      result.isCorrect
                          ? 'Jawaban Kamu Tepat!'
                          : 'Jawaban Kamu Kurang Tepat',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: result.isCorrect ? correctColor : incorrectColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Kamu memilih: ${result.selectedAnswer}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      result.news.explanation,
                      style: const TextStyle(
                        fontSize: 15,
                        color: textSecondary,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: accentColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        '+${result.rewardXp} XP',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      label: 'Kembali ke Dashboard',
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/dashboard',
                        (route) => false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
