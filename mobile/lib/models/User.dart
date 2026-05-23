class Stat {
  final String statId;
  final String name;
  final int correct;
  final int total;

  Stat({
    required this.statId,
    required this.name,
    required this.correct,
    required this.total,
  });

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      statId: json['stat_id'] as String,
      name: json['name'] as String,
      correct: json['correct'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stat_id': statId,
      'name': name,
      'correct': correct,
      'total': total,
    };
  }
}

class CampaignProgress {
  final String campaignId;
  final bool isCompleted;
  final List<String> levelsCompleted;

  CampaignProgress({
    required this.campaignId,
    required this.isCompleted,
    required this.levelsCompleted,
  });

  factory CampaignProgress.fromJson(Map<String, dynamic> json) {
    return CampaignProgress(
      campaignId: json['campaign_id'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      levelsCompleted: List<String>.from(
        json['levelsCompleted'] as List? ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campaign_id': campaignId,
      'isCompleted': isCompleted,
      'levelsCompleted': levelsCompleted,
    };
  }
}

class PostHistoryItem {
  final String postId;
  final bool isCorrect;

  PostHistoryItem({required this.postId, required this.isCorrect});

  factory PostHistoryItem.fromJson(Map<String, dynamic> json) {
    return PostHistoryItem(
      postId: json['post_id'] as String,
      isCorrect: json['is_correct'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'post_id': postId, 'is_correct': isCorrect};
  }
}

class Consumable {
  final String itemId;
  int amount;

  Consumable({required this.itemId, required this.amount});

  factory Consumable.fromJson(Map<String, dynamic> json) {
    return Consumable(
      itemId: json['itemId'] as String,
      amount: json['amount'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {'itemId': itemId, 'amount': amount};
  }
}

class Inventory {
  final List<String> themes;
  final List<Consumable> consumables;

  Inventory({required this.themes, required this.consumables});

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      themes: List<String>.from(json['themes'] as List? ?? ['theme_green']),
      consumables: (json['consumables'] as List? ?? [])
          .map((e) => Consumable.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themes': themes,
      'consumables': consumables.map((e) => e.toJson()).toList(),
    };
  }
}

class User {
  final String id;
  final String username;
  final String email;
  final bool isVerified;
  final int totalExp;
  final int totalCoins;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastPlayedDate;
  final int postsProcessed;
  final int postsCorrect;
  final List<PostHistoryItem> postsHistory;
  final List<Stat> stats;
  final List<CampaignProgress> campaignProgress;
  final String activeTheme;
  final Inventory inventory;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.isVerified,
    required this.totalExp,
    required this.totalCoins,
    required this.currentStreak,
    required this.bestStreak,
    required this.lastPlayedDate,
    required this.postsProcessed,
    required this.postsCorrect,
    required this.postsHistory,
    required this.stats,
    required this.campaignProgress,
    required this.activeTheme,
    required this.inventory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
      totalExp: json['totalExp'] as int? ?? 0,
      totalCoins: json['totalCoins'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      lastPlayedDate: json['lastPlayedDate'] != null
          ? DateTime.parse(json['lastPlayedDate'] as String)
          : null,
      postsProcessed: json['postsProcessed'] as int? ?? 0,
      postsCorrect: json['postsCorrect'] as int? ?? 0,
      postsHistory: (json['postsHistory'] as List? ?? [])
          .map((e) => PostHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: (json['stats'] as List? ?? [])
          .map((e) => Stat.fromJson(e as Map<String, dynamic>))
          .toList(),
      campaignProgress: (json['campaign_progress'] as List? ?? [])
          .map((e) => CampaignProgress.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeTheme: json['activeTheme'] as String? ?? 'theme_green',
      inventory: json['inventory'] != null
          ? Inventory.fromJson(json['inventory'] as Map<String, dynamic>)
          : Inventory(themes: ['theme_green'], consumables: []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'isVerified': isVerified,
      'totalExp': totalExp,
      'totalCoins': totalCoins,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastPlayedDate': lastPlayedDate?.toIso8601String(),
      'postsProcessed': postsProcessed,
      'postsCorrect': postsCorrect,
      'postsHistory': postsHistory.map((e) => e.toJson()).toList(),
      'stats': stats.map((e) => e.toJson()).toList(),
      'campaign_progress': campaignProgress.map((e) => e.toJson()).toList(),
      'activeTheme': activeTheme,
      'inventory': inventory.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
