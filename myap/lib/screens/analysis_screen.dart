import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/dummy_data.dart';
import '../widgets/custom_button.dart';
import '../widgets/news_card.dart';

/// News analysis screen with Real/Fake action buttons.
/// Routes selected answer to the Result screen.
/// Modern dark theme with neon green accents.
class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsIndex = ModalRoute.of(context)?.settings.arguments as int? ?? 0;
    final newsItem = DummyData.sampleNews[newsIndex];

    const Color darkBg = Color(0xFF09090b);
    const Color accentColor = Color(0xFF22c55e); // Neon green
    const Color textPrimary = Color(0xFFffffff); // White
    const Color textSecondary = Color(0xFFd4d4d8); // Light gray

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Analysis',
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tentukan apakah berita berikut nyata atau hoax.',
                style: TextStyle(
                  fontSize: 16,
                  color: textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              NewsCard(news: newsItem),
              const SizedBox(height: 24),
              const Text(
                'Pilih jawabanmu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              CustomButton(
                label: 'Real',
                onPressed: () {
                  final isCorrect = newsItem.correctAnswer == 'Real';
                  Navigator.pushNamed(
                    context,
                    '/result',
                    arguments: AnalysisResult(
                      news: newsItem,
                      isCorrect: isCorrect,
                      selectedAnswer: 'Real',
                      rewardXp: isCorrect ? 70 : 20,
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              CustomButton(
                label: 'Fake',
                onPressed: () {
                  final isCorrect = newsItem.correctAnswer == 'Fake';
                  Navigator.pushNamed(
                    context,
                    '/result',
                    arguments: AnalysisResult(
                      news: newsItem,
                      isCorrect: isCorrect,
                      selectedAnswer: 'Fake',
                      rewardXp: isCorrect ? 70 : 20,
                    ),
                  );
                },
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
