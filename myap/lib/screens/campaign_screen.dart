import 'package:flutter/material.dart';
import '../services/dummy_data.dart';
import '../widgets/custom_button.dart';

/// Campaign screen showcasing anti-hoax activities and training opportunities.
class CampaignScreen extends StatelessWidget {
  const CampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaigns'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kegiatan Anti-Hoax', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: DummyData.campaignItems.length,
                itemBuilder: (context, index) {
                  final campaign = DummyData.campaignItems[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      leading: CircleAvatar(backgroundColor: Colors.indigo.shade100, child: const Icon(Icons.campaign, color: Colors.indigo)),
                      title: Text(campaign, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Tingkatkan kemampuan cek fakta dan bagikan pengetahuan ke teman.'),
                      trailing: CustomButton(
                        label: 'Join',
                        onPressed: () {},
                        color: Colors.indigo.shade700,
                      ),
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
