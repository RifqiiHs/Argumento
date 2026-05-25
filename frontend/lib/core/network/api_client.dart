import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Android Emulator: 10.0.2.2 maps to host machine's localhost
const String kBaseUrl = 'http://10.0.2.2:3000/api';
// Physical device: use your computer's LAN IP instead
// const String kBaseUrl = 'http://192.168.x.x:3000/api';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Dio get dio {
    final dio = Dio(BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    // Auth token interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await _storage.read(key: 'auth_token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            // Storage read failed - continue without token
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Log error details for debugging
          // ignore: avoid_print
          print('[API ERROR] ${error.requestOptions.method} ${error.requestOptions.path}');
          // ignore: avoid_print
          print('[API ERROR] Status: ${error.response?.statusCode}');
          // ignore: avoid_print
          print('[API ERROR] Data: ${error.response?.data}');
          // ignore: avoid_print
          print('[API ERROR] Message: ${error.message}');
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<bool> hasToken() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }
}
