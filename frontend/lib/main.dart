import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_state.dart';
import 'core/utils/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A0F0A),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const ArgumentoApp());
}

class ArgumentoApp extends StatelessWidget {
  const ArgumentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit()..loadUser()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          context.read<ThemeCubit>().syncFromUser(userState.user);
          return BlocBuilder<ThemeCubit, String>(
            builder: (context, themeId) {
              return MaterialApp.router(
                title: 'Argumento',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.getTheme(themeId),
                routerConfig: appRouter,
              );
            },
          );
        },
      ),
    );
  }
}
