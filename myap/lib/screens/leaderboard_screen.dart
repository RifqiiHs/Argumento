import 'package:flutter/material.dart';
import '../services/dummy_data.dart';

/// Leaderboard screen displaying the top users by XP.
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Top Players', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: DummyData.leaderboard.length,
                itemBuilder: (context, index) {
                  final entry = DummyData.leaderboard[index];
                  final rank = index + 1;
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade50,
                        child: Text(rank.toString(), style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(entry['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(entry['xp']!, style: const TextStyle(color: Colors.indigo)),
                    ),
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
