import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';
import 'package:bugun_ne_yiyelim/constants/app_theme.dart';
import 'package:bugun_ne_yiyelim/viewmodels/user_preferences_viewmodel.dart';
import 'package:bugun_ne_yiyelim/viewmodels/theme_viewmodel.dart';
import 'package:bugun_ne_yiyelim/views/food_suggestion_view.dart';
import 'package:bugun_ne_yiyelim/views/favorites_view.dart';
import 'package:bugun_ne_yiyelim/views/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const FoodSuggestionView(),
    const FavoritesView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeVM = context.watch<ThemeViewModel>();

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: themeVM.currentModeColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            selectedItemColor: themeVM.currentModeColor,
            unselectedItemColor: Colors.grey[400],
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12.sp,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu),
                label: 'Ne Yesem?',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favoriler',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Ayarlar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
