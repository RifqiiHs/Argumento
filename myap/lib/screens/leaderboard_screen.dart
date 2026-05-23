import 'package:flutter/material.dart';
import '../services/dummy_data.dart';

/// Leaderboard screen displaying the top users by XP.
/// Modern dark theme with neon green accents.
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF09090b);
    const Color accentColor = Color(0xFF22c55e); // Neon green
    const Color textPrimary = Color(0xFFffffff); // White
    const Color textSecondary = Color(0xFFd4d4d8); // Light gray
    const Color cardBg = Color(0xFF1a1a1e);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
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
                'Top Players',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.builder(
                  itemCount: DummyData.leaderboard.length,
                  itemBuilder: (context, index) {
                    final entry = DummyData.leaderboard[index];
                    final rank = index + 1;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: accentColor.withOpacity(0.2),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    accentColor.withOpacity(0.3),
                                    accentColor.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  rank.toString(),
                                  style: const TextStyle(
                                    color: accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                entry['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              entry['xp']!,
                              style: const TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
