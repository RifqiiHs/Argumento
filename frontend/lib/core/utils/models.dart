// ============ POST MODEL ============
class PostModel {
  final String id;
  final String headline;
  final String content;
  final String type; // 'slop' | 'safe'
  final String? slopReason;
  final String? category;
  final List<String> reasons;
  final String origin; // 'human' | 'ai'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PostModel({
    required this.id,
    required this.headline,
    required this.content,
    required this.type,
    this.slopReason,
    this.category,
    required this.reasons,
    required this.origin,
    this.createdAt,
    this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'] ?? json['id'] ?? '',
      headline: json['headline'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? 'safe',
      slopReason: json['slop_reason'],
      category: json['category'],
      reasons: List<String>.from(json['reasons'] ?? []),
      origin: json['origin'] ?? 'ai',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'headline': headline,
    'content': content,
    'type': type,
    'slop_reason': slopReason,
    'category': category,
    'reasons': reasons,
    'origin': origin,
  };
}

// ============ USER MODEL ============
class StatModel {
  final String statId;
  final String name;
  final int correct;
  final int total;

  StatModel({
    required this.statId,
    required this.name,
    required this.correct,
    required this.total,
  });

  factory StatModel.fromJson(Map<String, dynamic> json) => StatModel(
    statId: json['stat_id'] ?? '',
    name: json['name'] ?? '',
    correct: json['correct'] ?? 0,
    total: json['total'] ?? 0,
  );
}

class CampaignProgressModel {
  final String campaignId;
  final bool isCompleted;
  final List<String> levelsCompleted;

  CampaignProgressModel({
    required this.campaignId,
    required this.isCompleted,
    required this.levelsCompleted,
  });

  factory CampaignProgressModel.fromJson(Map<String, dynamic> json) => CampaignProgressModel(
    campaignId: json['campaign_id'] ?? '',
    isCompleted: json['isCompleted'] ?? false,
    levelsCompleted: List<String>.from(json['levelsCompleted'] ?? []),
  );
}

class PostHistoryModel {
  final String postId;
  final bool isCorrect;
  final PostModel? post;

  PostHistoryModel({
    required this.postId,
    required this.isCorrect,
    this.post,
  });

  factory PostHistoryModel.fromJson(Map<String, dynamic> json) => PostHistoryModel(
    postId: json['post_id'] ?? '',
    isCorrect: json['is_correct'] ?? false,
    post: json['post'] != null ? PostModel.fromJson(json['post']) : null,
  );
}

class InventoryModel {
  final List<String> themes;
  final List<ConsumableModel> consumables;

  InventoryModel({required this.themes, required this.consumables});

  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
    themes: List<String>.from(json['themes'] ?? []),
    consumables: (json['consumables'] as List<dynamic>? ?? [])
        .map((c) => ConsumableModel.fromJson(c))
        .toList(),
  );
}

class ConsumableModel {
  final String itemId;
  final int amount;

  ConsumableModel({required this.itemId, required this.amount});

  factory ConsumableModel.fromJson(Map<String, dynamic> json) => ConsumableModel(
    itemId: json['itemId'] ?? '',
    amount: json['amount'] ?? 0,
  );
}

class UserModel {
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
  final List<PostHistoryModel> postsHistory;
  final List<StatModel> stats;
  final List<CampaignProgressModel> campaignProgress;
  final String activeTheme;
  final InventoryModel inventory;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.isVerified,
    required this.totalExp,
    required this.totalCoins,
    required this.currentStreak,
    required this.bestStreak,
    this.lastPlayedDate,
    required this.postsProcessed,
    required this.postsCorrect,
    required this.postsHistory,
    required this.stats,
    required this.campaignProgress,
    required this.activeTheme,
    required this.inventory,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['_id'] ?? '',
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    isVerified: json['isVerified'] ?? false,
    totalExp: json['totalExp'] ?? 0,
    totalCoins: json['totalCoins'] ?? 0,
    currentStreak: json['currentStreak'] ?? 0,
    bestStreak: json['bestStreak'] ?? 0,
    lastPlayedDate: json['lastPlayedDate'] != null ? DateTime.parse(json['lastPlayedDate']) : null,
    postsProcessed: json['postsProcessed'] ?? 0,
    postsCorrect: json['postsCorrect'] ?? 0,
    postsHistory: (json['postsHistory'] as List<dynamic>? ?? [])
        .map((h) => PostHistoryModel.fromJson(h))
        .toList(),
    stats: (json['stats'] as List<dynamic>? ?? [])
        .map((s) => StatModel.fromJson(s))
        .toList(),
    campaignProgress: (json['campaign_progress'] as List<dynamic>? ?? [])
        .map((cp) => CampaignProgressModel.fromJson(cp))
        .toList(),
    activeTheme: json['activeTheme'] ?? 'theme_green',
    inventory: json['inventory'] != null
        ? InventoryModel.fromJson(json['inventory'])
        : InventoryModel(themes: ['theme_green'], consumables: []),
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
  );

  bool get hasPlayedToday {
    if (lastPlayedDate == null) return false;
    final now = DateTime.now();
    return lastPlayedDate!.day == now.day &&
        lastPlayedDate!.month == now.month &&
        lastPlayedDate!.year == now.year;
  }

  double get accuracy {
    if (postsHistory.isEmpty) return 0.0;
    return (postsCorrect / postsHistory.length) * 100;
  }
}

// ============ CAMPAIGN MODEL ============
class CampaignPostModel {
  final String id;
  final String headline;
  final String content;
  final String type;
  final List<String> slopReasons;
  final String category;

  CampaignPostModel({
    required this.id,
    required this.headline,
    required this.content,
    required this.type,
    required this.slopReasons,
    required this.category,
  });

  factory CampaignPostModel.fromJson(Map<String, dynamic> json) => CampaignPostModel(
    id: json['id'] ?? '',
    headline: json['headline'] ?? '',
    content: json['content'] ?? '',
    type: json['type'] ?? 'safe',
    slopReasons: List<String>.from(json['slop_reasons'] ?? []),
    category: json['category'] ?? 'safe',
  );
}

class CampaignLevelModel {
  final String title;
  final String briefing;
  final List<CampaignPostModel> posts;

  CampaignLevelModel({
    required this.title,
    required this.briefing,
    required this.posts,
  });

  factory CampaignLevelModel.fromJson(Map<String, dynamic> json) => CampaignLevelModel(
    title: json['title'] ?? '',
    briefing: json['briefing'] ?? '',
    posts: (json['posts'] as List<dynamic>? ?? [])
        .map((p) => CampaignPostModel.fromJson(p))
        .toList(),
  );
}

class CampaignModel {
  final String id;
  final String title;
  final String description;
  final String requirement;
  final Map<String, CampaignLevelModel> levels;

  CampaignModel({
    required this.id,
    required this.title,
    required this.description,
    required this.requirement,
    required this.levels,
  });

  factory CampaignModel.fromJson(String id, Map<String, dynamic> json) => CampaignModel(
    id: id,
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    requirement: json['requirement'] ?? '',
    levels: (json['levels'] as Map<String, dynamic>? ?? {}).map(
      (key, value) => MapEntry(key, CampaignLevelModel.fromJson(value)),
    ),
  );
}

// ============ SHOP MODEL ============
class ShopThemeModel {
  final String id;
  final String name;
  final String description;
  final int price;
  final String hex;

  ShopThemeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.hex,
  });

  factory ShopThemeModel.fromJson(Map<String, dynamic> json) => ShopThemeModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    price: json['price'] ?? 0,
    hex: json['hex'] ?? '#22c55e',
  );
}

// ============ LEADERBOARD MODEL ============
class LeaderboardEntryModel {
  final String id;
  final String username;
  final int totalExp;
  final int bestStreak;
  final int currentStreak;
  final int postsProcessed;
  final int postsCorrect;

  LeaderboardEntryModel({
    required this.id,
    required this.username,
    required this.totalExp,
    required this.bestStreak,
    required this.currentStreak,
    required this.postsProcessed,
    required this.postsCorrect,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) => LeaderboardEntryModel(
    id: json['_id'] ?? '',
    username: json['username'] ?? '',
    totalExp: json['totalExp'] ?? 0,
    bestStreak: json['bestStreak'] ?? 0,
    currentStreak: json['currentStreak'] ?? 0,
    postsProcessed: json['postsProcessed'] ?? 0,
    postsCorrect: json['postsCorrect'] ?? 0,
  );

  int getValueByField(String field) {
    switch (field) {
      case 'totalExp': return totalExp;
      case 'bestStreak': return bestStreak;
      case 'currentStreak': return currentStreak;
      case 'postsProcessed': return postsProcessed;
      case 'postsCorrect': return postsCorrect;
      default: return totalExp;
    }
  }
}

// ============ POST LOG / VERDICT ============
class PostLogModel {
  final String postId;
  final bool isCorrect;

  PostLogModel({required this.postId, required this.isCorrect});

  Map<String, dynamic> toJson() => {'post_id': postId, 'is_correct': isCorrect};
}

class PostVerdictModel {
  final bool isCorrect;
  final String message;

  PostVerdictModel({required this.isCorrect, required this.message});
}
