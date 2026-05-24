import 'package:dio/dio.dart';
import '../network/api_client.dart';
import 'models.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final _client = ApiClient();

  Dio get _dio => _client.dio;

  // ============ AUTH ============
  Future<String> login(String username, String password) async {
    final res = await _dio.post('/auth/login', data: {'username': username, 'password': password});
    final token = res.data['token'] as String;
    await _client.saveToken(token);
    return token;
  }

  Future<String> register(String username, String password, String email) async {
    final res = await _dio.post('/auth/register', data: {
      'username': username,
      'password': password,
      'email': email,
    });
    final token = res.data['token'] as String;
    await _client.saveToken(token);
    return token;
  }

  Future<UserModel?> getMe() async {
    try {
      final res = await _dio.get('/auth');
      if (res.data['user'] != null) {
        return UserModel.fromJson(res.data['user']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> sendVerifyEmail(String email) async {
    await _dio.post('/auth/verify', data: {'email': email});
  }

  Future<void> verifyEmail(String id) async {
    await _dio.put('/auth/verify/$id');
  }

  Future<void> generateResetToken(String email) async {
    await _dio.post('/auth/reset', data: {'email': email});
  }

  Future<void> resetPassword(String id, String newPassword) async {
    await _dio.put('/auth/reset/$id', data: {'newPassword': newPassword});
  }

  Future<void> deleteAccount() async {
    await _dio.delete('/auth');
    await _client.deleteToken();
  }

  Future<void> logout() async {
    await _client.deleteToken();
  }

  // ============ SHIFTS ============
  Future<List<PostModel>> generateDailyShift(
      int postLength, Map<String, List<String>> types) async {
    final res = await _dio.post('/shifts/generate', data: {
      'postLength': postLength,
      'types': types,
    });
    return (res.data['posts'] as List).map((p) => PostModel.fromJson(p)).toList();
  }

  Future<List<PostModel>> generatePracticeShift(
      int postLength, Map<String, List<String>> types) async {
    final res = await _dio.post('/shifts/practice', data: {
      'postLength': postLength,
      'types': types,
    });
    return (res.data['posts'] as List).map((p) => PostModel.fromJson(p)).toList();
  }

  Future<void> completeShift(List<PostLogModel> history) async {
    await _dio.put('/shifts/complete', data: {
      'history': history.map((h) => h.toJson()).toList(),
    });
  }

  // ============ JUDGE ============
  Future<PostVerdictModel> judge(
      String headline, String content, List<String> slopReasons, String userReason) async {
    final res = await _dio.post('/judge', data: {
      'headline': headline,
      'content': content,
      'slop_reasons': slopReasons,
      'user_reason': userReason,
    });
    final response = res.data['response'];
    return PostVerdictModel(
      isCorrect: response['is_correct'] ?? false,
      message: response['feedback_message'] ?? '',
    );
  }

  // ============ CAMPAIGN ============
  Future<List<CampaignModel>> getCampaign() async {
    final res = await _dio.get('/campaign');
    final campaignMap = res.data['campaign'] as Map<String, dynamic>;
    return campaignMap.entries
        .map((e) => CampaignModel.fromJson(e.key, e.value))
        .toList();
  }

  Future<CampaignLevelModel> getLevel(String level, String id) async {
    final res = await _dio.get('/campaign/$level/$id');
    return CampaignLevelModel.fromJson(res.data['part']);
  }

  Future<void> completeCampaignLevel(String level, String id) async {
    await _dio.post('/campaign/complete/$level/$id');
  }

  // ============ LEADERBOARD ============
  Future<List<LeaderboardEntryModel>> getLeaderboard(String type) async {
    final res = await _dio.get('/leaderboard/$type');
    return (res.data['data'] as List)
        .map((e) => LeaderboardEntryModel.fromJson(e))
        .toList();
  }

  // ============ SHOP ============
  Future<List<ShopThemeModel>> getShopThemes() async {
    final res = await _dio.get('/shops');
    return (res.data['shop']['themes'] as List)
        .map((t) => ShopThemeModel.fromJson(t))
        .toList();
  }

  Future<void> buyShopItem(String type, String itemId) async {
    await _dio.put('/shops', data: {'type': type, 'itemId': itemId});
  }

  Future<void> equipTheme(String itemId) async {
    await _dio.put('/users/theme', data: {'itemId': itemId});
  }

  // ============ USER ============
  Future<UserModel?> getUserById(String userId) async {
    try {
      final res = await _dio.get('/users/$userId');
      return UserModel.fromJson(res.data['user']);
    } catch (e) {
      return null;
    }
  }

  Future<void> refreshStreak() async {
    await _dio.put('/users/streak');
  }

  // ============ POSTS ============
  Future<PostModel> getPost(String postId) async {
    final res = await _dio.get('/posts/$postId');
    return PostModel.fromJson(res.data['post']);
  }

  // ============ FEEDBACK ============
  Future<void> submitFeedback(Map<String, dynamic> feedback) async {
    await _dio.post('/feedback', data: feedback);
  }
}
