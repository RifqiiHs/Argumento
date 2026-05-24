import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/models.dart';
import '../utils/api_service.dart';

// ============ USER CUBIT ============
class UserState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const UserState({this.user, this.isLoading = false, this.error});

  UserState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserCubit extends Cubit<UserState> {
  final ApiService _api = ApiService();

  UserCubit() : super(const UserState());

  Future<void> loadUser() async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await _api.getMe();
      emit(UserState(user: user, isLoading: false));
    } catch (e) {
      emit(UserState(error: e.toString(), isLoading: false));
    }
  }

  Future<void> invalidateUser() async {
    await loadUser();
  }

  Future<void> logout() async {
    await _api.logout();
    emit(const UserState());
  }
}

// ============ THEME CUBIT ============
class ThemeCubit extends Cubit<String> {
  ThemeCubit() : super('theme_green');

  void setTheme(String themeId) => emit(themeId);

  void syncFromUser(UserModel? user) {
    if (user != null) {
      emit(user.activeTheme);
    }
  }
}
