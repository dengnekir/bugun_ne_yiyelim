import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bugun_ne_yiyelim/models/food.dart';
import 'package:bugun_ne_yiyelim/viewmodels/food_viewmodel.dart';
import 'package:bugun_ne_yiyelim/viewmodels/user_preferences_viewmodel.dart';
import 'package:bugun_ne_yiyelim/viewmodels/theme_viewmodel.dart';
import 'package:bugun_ne_yiyelim/views/food_detail_view.dart';
import 'package:bugun_ne_yiyelim/constants/app_theme.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  String _searchQuery = '';
  String _sortBy = 'name'; // 'name', 'calories', 'preparationTime'

  @override
  Widget build(BuildContext context) {
    final userPrefsVM = context.watch<UserPreferencesViewModel>();
    final foodVM = context.watch<FoodViewModel>();
    final themeVM = context.watch<ThemeViewModel>();
    final favoriteFoods = foodVM.getFavoriteFoods(userPrefsVM.favoriteIds);

    final filteredFoods = _filterAndSortFoods(favoriteFoods);

    return Column(
      children: [
        _buildSearchBar(themeVM.currentModeColor),
        if (favoriteFoods.isNotEmpty) _buildSortBar(themeVM.currentModeColor),
        Expanded(
          child: favoriteFoods.isEmpty
              ? _buildEmptyState(themeVM.currentModeColor)
              : _buildFoodList(filteredFoods, themeVM.currentModeColor),
        ),
      ],
    );
  }

  Widget _buildSearchBar(Color currentModeColor) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: currentModeColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Favori yemeklerinizde arayın...',
            prefixIcon: Icon(Icons.search, color: currentModeColor),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
        ),
      ),
    );
  }

  Widget _buildSortBar(Color currentModeColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Text(
            'Sıralama:',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.sp,
            ),
          ),
          SizedBox(width: 8.w),
          _buildSortChip('İsim', 'name', currentModeColor),
          SizedBox(width: 8.w),
          _buildSortChip('Kalori', 'calories', currentModeColor),
          SizedBox(width: 8.w),
          _buildSortChip('Hazırlama', 'preparationTime', currentModeColor),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value, Color currentModeColor) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () => setState(() => _sortBy = value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? currentModeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? currentModeColor : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color currentModeColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.sp,
            color: currentModeColor.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'Henüz favori yemeğiniz yok',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Beğendiğiniz yemekleri favorilere ekleyebilirsiniz',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList(List<Food> foods, Color currentModeColor) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return _buildFoodCard(food, currentModeColor);
      },
    );
  }

  Widget _buildFoodCard(Food food, Color currentModeColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GestureDetector(
        onTap: () => _navigateToFoodDetail(food, currentModeColor),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: currentModeColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: currentModeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.restaurant,
                            color: currentModeColor,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.name,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                food.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoChip(
                          Icons.timer,
                          '${food.preparationTime} dk',
                          currentModeColor,
                        ),
                        _buildInfoChip(
                          Icons.local_fire_department,
                          '${food.calories} kcal',
                          currentModeColor,
                        ),
                        _buildRemoveButton(food),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color currentModeColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: currentModeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: currentModeColor,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: currentModeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveButton(Food food) {
    return Consumer<UserPreferencesViewModel>(
      builder: (context, userPrefsVM, child) {
        return IconButton(
          icon: const Icon(Icons.favorite, color: AppTheme.errorColor),
          onPressed: () {
            userPrefsVM.toggleFavorite(food.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Favorilerden kaldırıldı'),
                action: SnackBarAction(
                  label: 'Geri Al',
                  onPressed: () => userPrefsVM.toggleFavorite(food.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Food> _filterAndSortFoods(List<Food> foods) {
    var filteredFoods = foods;

    // Arama filtreleme
    if (_searchQuery.isNotEmpty) {
      filteredFoods = foods.where((food) {
        return food.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            food.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Sıralama
    filteredFoods.sort((a, b) {
      switch (_sortBy) {
        case 'name':
          return a.name.compareTo(b.name);
        case 'calories':
          return a.calories.compareTo(b.calories);
        case 'preparationTime':
          return a.preparationTime.compareTo(b.preparationTime);
        default:
          return 0;
      }
    });

    return filteredFoods;
  }

  void _navigateToFoodDetail(Food food, Color currentModeColor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailView(
          food: food,
          modeColor: currentModeColor,
        ),
      ),
    );
  }
}
