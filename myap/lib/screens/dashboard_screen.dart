import 'package:flutter/material.dart';
import '../services/dummy_data.dart';
import '../widgets/news_card.dart';
import '../widgets/progress_bar.dart';

/// Main dashboard screen displaying user XP, progress, and featured news.
/// Links to analysis and secondary feature screens.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = DummyData.userProfile;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.indigo,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.indigo),
            onSelected: (value) {
              switch (value) {
                case 'login':
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  break;
                case 'register':
                  Navigator.pushNamed(context, '/signup');
                  break;
                case 'logout':
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'login', child: Text('Login')),
              PopupMenuItem(value: 'register', child: Text('Register')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello, ${profile.name}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('Selamat datang di Argumento!', style: TextStyle(fontSize: 14, color: Colors.black54)),
                  ],
                ),
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.indigo.shade100,
                  child: const Icon(Icons.school, color: Colors.indigo, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              color: Colors.indigo,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('XP Kamu', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    Text('${profile.xp} XP', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ProgressBar(progress: profile.progress),
                    const SizedBox(height: 14),
                    Text('Koin: ${profile.coins}', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FeatureButton(label: 'Campaign', icon: Icons.flag, onTap: () => Navigator.pushNamed(context, '/campaign')),
                _FeatureButton(label: 'Shop', icon: Icons.storefront, onTap: () => Navigator.pushNamed(context, '/shop')),
                _FeatureButton(label: 'Leaderboard', icon: Icons.emoji_events, onTap: () => Navigator.pushNamed(context, '/leaderboard')),
                _FeatureButton(label: 'Profile', icon: Icons.person, onTap: () => Navigator.pushNamed(context, '/profile')),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Berita Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...DummyData.sampleNews.map((news) {
              return NewsCard(
                news: news,
                onAnalyze: () {
                  final index = DummyData.sampleNews.indexOf(news);
                  Navigator.pushNamed(context, '/analysis', arguments: index);
                },
              );
            }),
            const SizedBox(height: 20),
            Text('Misi harian kamu siap! Coba analisis berita sekarang.', style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

class _FeatureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.indigo, size: 24),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
