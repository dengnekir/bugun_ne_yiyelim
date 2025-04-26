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

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _pages = [
    const FoodSuggestionView(),
    const FavoritesView(),
    const SettingsView(),
  ];

  final List<String> _titles = [
    'Ne Yesem?',
    'Favorilerim',
    'Ayarlar',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = context.watch<ThemeViewModel>();

    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: themeVM.currentModeColor,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: themeVM.currentModeColor,
            ),
      ),
      child: Scaffold(
        appBar: _buildAppBar(themeVM.currentModeColor),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar:
            _buildBottomNavigationBar(themeVM.currentModeColor),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Color currentModeColor) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              currentModeColor,
              currentModeColor.withOpacity(0.8),
            ],
          ),
        ),
      ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.3),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Text(
          _titles[_selectedIndex],
          key: ValueKey<String>(_titles[_selectedIndex]),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        if (_selectedIndex == 0)
          IconButton(
            icon: const Icon(Icons.casino, color: Colors.white),
            onPressed: () {
              // Zar atma sayfasına git
            },
          ),
        if (_selectedIndex == 1)
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.white),
            onPressed: () {
              // Sıralama seçeneklerini göster
            },
          ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(Color currentModeColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: currentModeColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                  0, Icons.restaurant_menu, 'Ne Yesem?', currentModeColor),
              _buildNavItem(1, Icons.favorite, 'Favorilerim', currentModeColor),
              _buildNavItem(2, Icons.settings, 'Ayarlar', currentModeColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, String label, Color currentModeColor) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? currentModeColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? currentModeColor : Colors.grey[400],
              size: 24.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? currentModeColor : Colors.grey[400],
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController
        ..reset()
        ..forward();
    }
  }
}
