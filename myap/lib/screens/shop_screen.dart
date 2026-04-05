import 'package:flutter/material.dart';
import '../services/dummy_data.dart';
import '../widgets/reward_card.dart';

/// Shop screen displaying reward items that can be redeemed with coins.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reward Store', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    );
  }
}
