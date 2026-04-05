import '../models/news.dart';
import '../models/user.dart';

class DummyData {
  static const userProfile = UserProfile(
    name: 'Aria Putri',
    email: 'aria.putri@example.com',
    xp: 1240,
    coins: 380,
    progress: 0.72,
    bio: 'Belajar mengenali hoax dan meningkatkan literasi informasi setiap hari.',
  );

  static const sampleNews = [
    NewsItem(
      title: 'Kampus X Buka Beasiswa 100% Untuk Semua Mahasiswa',
      source: 'EduNews',
      snippet: 'Pihak kampus mengumumkan secara resmi pemberian beasiswa penuh tanpa syarat.',
      correctAnswer: 'Fake',
      explanation: 'Berita ini berisi klaim yang terlalu luas dan tidak ada konfirmasi resmi dari pihak kampus.',
      category: 'Education',
    ),
    NewsItem(
      title: 'Penelitian Baru Mengungkap 8 Kebiasaan Sehat untuk Otak',
      source: 'Daily Health',
      snippet: 'Studi terbaru menemukan bahwa tidur cukup, membaca, dan olahraga ringan mendukung fungsi otak.',
      correctAnswer: 'Real',
      explanation: 'Sumber terpercaya dan pernyataan yang masuk akal membuat berita ini kredibel.',
      category: 'Health',
    ),
    NewsItem(
      title: 'Akun Resmi Pemerintah Akan Meminta Data Pribadi Lewat DM',
      source: 'InfoOnline',
      snippet: 'Beredar pesan dari akun resmi yang meminta semua warga mengirimkan KTP lewat direct message.',
      correctAnswer: 'Fake',
      explanation: 'Instansi resmi tidak akan meminta data pribadi melalui pesan langsung media sosial.',
      category: 'Safety',
    ),
  ];

  static const campaignItems = [
    'Pelatihan Cek Fakta',
    'Kampanye Anti-Hoax',
    'Kompetisi Debat Literasi Digital',
  ];

  static const rewardItems = [
    {
      'name': 'Lencana Cek Fakta',
      'description': 'Tambahkan lencana khusus ke profil kamu.',
      'cost': '120 coins',
    },
    {
      'name': 'Tema Dark Mode',
      'description': 'Ubah tampilan aplikasi dengan tema gelap modern.',
      'cost': '250 coins',
    },
    {
      'name': 'Power-Up XP +50',
      'description': 'Dapatkan bonus pengalaman ekstra setelah analisis.',
      'cost': '320 coins',
    },
  ];

  static const leaderboard = [
    {'name': 'Dinda', 'xp': '1,680 XP'},
    {'name': 'Rafi', 'xp': '1,520 XP'},
    {'name': 'Aria Putri', 'xp': '1,240 XP'},
    {'name': 'Nadia', 'xp': '1,100 XP'},
  ];
}
