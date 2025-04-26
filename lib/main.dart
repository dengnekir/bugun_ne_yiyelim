import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';
import 'package:bugun_ne_yiyelim/constants/app_theme.dart';
import 'package:bugun_ne_yiyelim/views/splash_view.dart';
import 'package:bugun_ne_yiyelim/viewmodels/user_preferences_viewmodel.dart';
import 'package:bugun_ne_yiyelim/viewmodels/food_viewmodel.dart';
import 'package:bugun_ne_yiyelim/viewmodels/theme_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X boyutları baz alındı
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => UserPreferencesViewModel(),
            ),
            ChangeNotifierProvider(
              create: (_) => FoodViewModel(),
            ),
            ChangeNotifierProvider(
              create: (_) => ThemeViewModel(),
            ),
          ],
          child: MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const SplashView(),
          ),
        );
      },
    );
  }
}
