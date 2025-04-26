import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';
import 'package:bugun_ne_yiyelim/constants/app_theme.dart';
import 'package:bugun_ne_yiyelim/viewmodels/user_preferences_viewmodel.dart';
import 'package:bugun_ne_yiyelim/views/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final userPrefsVM = context.read<UserPreferencesViewModel>();
    await userPrefsVM.initialize();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 100.sp,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: 20.h),
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 40.h),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
