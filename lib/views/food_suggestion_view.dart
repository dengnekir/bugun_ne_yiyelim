import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';
import 'package:bugun_ne_yiyelim/constants/app_theme.dart';
import 'package:bugun_ne_yiyelim/viewmodels/user_preferences_viewmodel.dart';
import 'package:bugun_ne_yiyelim/viewmodels/food_viewmodel.dart';
import 'package:bugun_ne_yiyelim/models/food.dart';
import 'package:bugun_ne_yiyelim/viewmodels/theme_viewmodel.dart';

class FoodSuggestionView extends StatefulWidget {
  const FoodSuggestionView({super.key});

  @override
  State<FoodSuggestionView> createState() => _FoodSuggestionViewState();
}

class _FoodSuggestionViewState extends State<FoodSuggestionView>
    with TickerProviderStateMixin {
  String _selectedEnvironment = AppConstants.environmentHome;
  String _selectedMealType = AppConstants.mealTypeLunch;
  String _selectedMode = AppConstants.modeNormal;
  Food? _suggestedFood;

  // Menü durumları
  int _currentStep = 0; // 0: Ortam, 1: Öğün, 2: Mod
  bool get _showEnvironment => _currentStep >= 0;
  bool get _showMealType => _currentStep >= 1;
  bool get _showMode => _currentStep >= 2;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _menuAnimationController;
  late Animation<double> _mealTypeAnimation;
  late Animation<double> _modeAnimation;

  Color get _currentModeColor =>
      AppTheme.modeColors[_selectedMode] ?? AppTheme.primaryColor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _menuAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _mealTypeAnimation = CurvedAnimation(
      parent: _menuAnimationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
    );

    _modeAnimation = CurvedAnimation(
      parent: _menuAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _menuAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: _currentModeColor,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: _currentModeColor,
            ),
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text(
                    'Ne Yesem?',
                    style: TextStyle(
                      color: _currentModeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (_currentStep > 0)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _currentStep > 0 ? 1.0 : 0.0,
                      child: Text(
                        _getStepTitle(),
                        style: TextStyle(
                          color: _currentModeColor.withOpacity(0.7),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                ],
              ),
              leading: _currentStep > 0
                  ? AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _currentStep > 0 ? 1.0 : 0.0,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: _currentModeColor),
                        onPressed: _handleBack,
                      ),
                    )
                  : null,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStepIndicator(),
                    SizedBox(height: 24.h),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.05, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _buildCurrentStep(),
                    ),
                    if (_suggestedFood != null) ...[
                      SizedBox(height: 24.h),
                      _buildSuggestedFood(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 1:
        return 'Seçilen: ${_getEnvironmentLabel(_selectedEnvironment)}';
      case 2:
        return 'Seçilen: ${_getMealTypeLabel(_selectedMealType)}';
      default:
        return '';
    }
  }

  String _getEnvironmentLabel(String value) {
    switch (value) {
      case AppConstants.environmentHome:
        return 'Evde';
      case AppConstants.environmentWork:
        return 'İşte';
      case AppConstants.environmentOutside:
        return 'Dışarıda';
      default:
        return '';
    }
  }

  String _getMealTypeLabel(String value) {
    switch (value) {
      case AppConstants.mealTypeBreakfast:
        return 'Kahvaltı';
      case AppConstants.mealTypeLunch:
        return 'Öğle';
      case AppConstants.mealTypeDinner:
        return 'Akşam';
      case AppConstants.mealTypeSnack:
        return 'Atıştırmalık';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildEnvironmentSelector();
      case 1:
        return _buildMealTypeSelector();
      case 2:
        return _buildModeSelector();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStepDot(0, 'Ortam'),
        _buildStepLine(0),
        _buildStepDot(1, 'Öğün'),
        _buildStepLine(1),
        _buildStepDot(2, 'Mod'),
      ],
    );
  }

  Widget _buildStepDot(int step, String label) {
    final isActive = _currentStep >= step;
    final isCurrent = _currentStep == step;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? _currentModeColor : Colors.grey[300],
              border: isCurrent
                  ? Border.all(color: _currentModeColor, width: 3)
                  : null,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: _currentModeColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Icon(
                step == 0
                    ? Icons.place
                    : step == 1
                        ? Icons.restaurant
                        : Icons.style,
                size: 16.sp,
                color: isActive ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? _currentModeColor : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step) {
    final isActive = _currentStep > step;
    return Container(
      width: 40.w,
      height: 2.h,
      color: isActive ? _currentModeColor : Colors.grey[300],
    );
  }

  void _handleBack() {
    setState(() {
      _currentStep--;
      if (_currentStep < 0) _currentStep = 0;

      // Geri gidince seçimleri sıfırla ve animasyonları tetikle
      if (_currentStep < 2) {
        _suggestedFood = null;
        _animationController.reverse();
      }
      if (_currentStep < 1) {
        _selectedMealType = AppConstants.mealTypeLunch;
        _menuAnimationController.reverse();
      }
    });
  }

  void _handleEnvironmentSelection(String environment) {
    setState(() {
      _selectedEnvironment = environment;
      _currentStep = 1;
    });
    _menuAnimationController
      ..reset()
      ..forward();
  }

  void _handleMealTypeSelection(String mealType) {
    setState(() {
      _selectedMealType = mealType;
      _currentStep = 2;
    });
    _menuAnimationController
      ..reset()
      ..forward();
  }

  void _handleModeSelection(String mode) {
    final themeVM = context.read<ThemeViewModel>();
    setState(() {
      _selectedMode = mode;
      themeVM.updateMode(mode);
    });
  }

  Widget _buildEnvironmentSelector() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _showEnvironment ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showEnvironment ? Offset.zero : const Offset(-0.05, 0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  _currentModeColor.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Neredesiniz?',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: _currentModeColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      _buildEnvironmentOption(
                        AppConstants.environmentHome,
                        'Evde',
                        Icons.home,
                      ),
                      SizedBox(height: 8.h),
                      _buildEnvironmentOption(
                        AppConstants.environmentWork,
                        'İşte',
                        Icons.work,
                      ),
                      SizedBox(height: 8.h),
                      _buildEnvironmentOption(
                        AppConstants.environmentOutside,
                        'Dışarıda',
                        Icons.restaurant,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnvironmentOption(String value, String label, IconData icon) {
    final isSelected = _selectedEnvironment == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleEnvironmentSelection(value),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isSelected
                ? _currentModeColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:
                  isSelected ? _currentModeColor : Colors.grey.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? _currentModeColor : Colors.grey,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? _currentModeColor : Colors.grey[700],
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                Icon(
                  Icons.check_circle,
                  color: _currentModeColor,
                  size: 24.sp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeSelector() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _showMealType ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showMealType ? Offset.zero : const Offset(-0.05, 0),
        child: Transform.translate(
          offset: const Offset(0, 0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    _currentModeColor.withOpacity(0.1),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      'Hangi Öğün?',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: _currentModeColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        _buildMealTypeOption(
                          AppConstants.mealTypeBreakfast,
                          'Kahvaltı',
                          Icons.wb_sunny,
                        ),
                        SizedBox(height: 8.h),
                        _buildMealTypeOption(
                          AppConstants.mealTypeLunch,
                          'Öğle',
                          Icons.sunny,
                        ),
                        SizedBox(height: 8.h),
                        _buildMealTypeOption(
                          AppConstants.mealTypeDinner,
                          'Akşam',
                          Icons.nights_stay,
                        ),
                        SizedBox(height: 8.h),
                        _buildMealTypeOption(
                          AppConstants.mealTypeSnack,
                          'Atıştırmalık',
                          Icons.cookie,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeOption(String value, String label, IconData icon) {
    final isSelected = _selectedMealType == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleMealTypeSelection(value),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isSelected
                ? _currentModeColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:
                  isSelected ? _currentModeColor : Colors.grey.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? _currentModeColor : Colors.grey,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? _currentModeColor : Colors.grey[700],
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                Icon(
                  Icons.check_circle,
                  color: _currentModeColor,
                  size: 24.sp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _showMode ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showMode ? Offset.zero : const Offset(-0.05, 0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      _currentModeColor.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        'Mod Seçin',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: _currentModeColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          _buildModeOption(
                            AppConstants.modeNormal,
                            'Normal',
                            Icons.restaurant_menu,
                            AppTheme.modeColors[AppConstants.modeNormal]!,
                          ),
                          SizedBox(height: 8.h),
                          _buildModeOption(
                            AppConstants.modeSports,
                            'Spor',
                            Icons.fitness_center,
                            AppTheme.modeColors[AppConstants.modeSports]!,
                          ),
                          SizedBox(height: 8.h),
                          _buildModeOption(
                            AppConstants.modeDiet,
                            'Diyet',
                            Icons.spa,
                            AppTheme.modeColors[AppConstants.modeDiet]!,
                          ),
                          SizedBox(height: 8.h),
                          _buildModeOption(
                            AppConstants.modeCulture,
                            'Kültür',
                            Icons.public,
                            AppTheme.modeColors[AppConstants.modeCulture]!,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            _buildSuggestButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(
      String value, String label, IconData icon, Color modeColor) {
    final isSelected = _selectedMode == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _handleModeSelection(value);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isSelected ? modeColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? modeColor : Colors.grey.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? modeColor : Colors.grey,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? modeColor : Colors.grey[700],
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                Icon(
                  Icons.check_circle,
                  color: modeColor,
                  size: 24.sp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Container(
            height: 56.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _currentModeColor,
                  _currentModeColor.withOpacity(0.8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: _currentModeColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _suggestFood();
                  _animationController.reset();
                  _animationController.forward();
                },
                borderRadius: BorderRadius.circular(28.r),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Yemek Öner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestedFood() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    _currentModeColor.withOpacity(0.1),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: 'food_icon',
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: _currentModeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: _currentModeColor.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.restaurant,
                              color: _currentModeColor,
                              size: 32.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _suggestedFood!.name,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: _currentModeColor,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _suggestedFood!.description,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Malzemeler',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: _currentModeColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: _suggestedFood!.ingredients.map((ingredient) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 400),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Chip(
                                label: Text(
                                  ingredient,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor:
                                    _currentModeColor.withOpacity(0.8),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard(
                          icon: Icons.timer,
                          title: 'Hazırlama',
                          value: '${_suggestedFood!.preparationTime} dk',
                        ),
                        _buildInfoCard(
                          icon: Icons.local_fire_department,
                          title: 'Kalori',
                          value: '${_suggestedFood!.calories} kcal',
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            onPressed: () {
                              // TODO: Tarifi detaylı görüntüleme
                            },
                            icon: Icons.restaurant_menu,
                            label: 'Tarifi Gör',
                            color: _currentModeColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _buildFavoriteButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: _currentModeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: _currentModeColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: _currentModeColor,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: _currentModeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24.r),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    final userPrefsVM = context.watch<UserPreferencesViewModel>();
    final isFavorite =
        _suggestedFood != null && userPrefsVM.isFavorite(_suggestedFood!.id);

    return Container(
      width: 48.h,
      height: 48.h,
      decoration: BoxDecoration(
        color:
            isFavorite ? AppTheme.errorColor : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: (isFavorite
                    ? AppTheme.errorColor
                    : Theme.of(context).primaryColor)
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_suggestedFood != null) {
              userPrefsVM.toggleFavorite(_suggestedFood!.id);
            }
          },
          borderRadius: BorderRadius.circular(24.r),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
      ),
    );
  }

  void _suggestFood() {
    final foodVM = context.read<FoodViewModel>();
    foodVM.filterFoods(
      environment: _selectedEnvironment,
      mealType: _selectedMealType,
      mode: _selectedMode,
    );

    setState(() {
      _suggestedFood = foodVM.getRandomFood();
    });
  }
}
