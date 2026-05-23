import 'package:flutter/material.dart';
import '../services/dummy_data.dart';
import '../widgets/reward_card.dart';

/// Shop screen displaying reward items that can be redeemed with coins.
/// Modern dark theme with neon green accents.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF09090b);
    const Color accentColor = Color(0xFF22c55e); // Neon green
    const Color textPrimary = Color(0xFFffffff); // White

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop',
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
                'Reward Store',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.builder(
                  itemCount: DummyData.rewardItems.length,
                  itemBuilder: (context, index) {
                    final item = DummyData.rewardItems[index];
                    return Column(
                      children: [
                        RewardCard(
                          name: item['name']!,
                          description: item['description']!,
                          cost: item['cost']!,
                        ),
                        const SizedBox(height: 10),
                      ],
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
