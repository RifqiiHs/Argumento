import 'package:flutter/material.dart';
import '../services/dummy_data.dart';
import '../widgets/progress_bar.dart';

/// Profile screen showing user stats, progress, and bio.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = DummyData.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
          ),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.indigo.shade100,
                  child: const Icon(Icons.person, color: Colors.indigo, size: 36),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(profile.email, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Progress', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ProgressBar(progress: profile.progress),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('XP', style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 6),
                            Text('${profile.xp}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Coins', style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 6),
                            Text('${profile.coins}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Tentang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Text(profile.bio, style: const TextStyle(color: Colors.black87, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
