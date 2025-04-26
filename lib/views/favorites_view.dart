import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bugun_ne_yiyelim/constants/app_theme.dart';
import 'package:bugun_ne_yiyelim/viewmodels/user_preferences_viewmodel.dart';
import 'package:bugun_ne_yiyelim/viewmodels/food_viewmodel.dart';
import 'package:bugun_ne_yiyelim/models/food.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final userPrefsVM = context.watch<UserPreferencesViewModel>();
    final foodVM = context.watch<FoodViewModel>();
    final favoriteFoods =
        foodVM.getFavorites(userPrefsVM.userPreferences?.favoriteFoodIds ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorilerim'),
      ),
      body: favoriteFoods.isEmpty
          ? _buildEmptyState()
          : _buildFavoritesList(favoriteFoods),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64.sp,
            color: AppTheme.textLightColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'Henüz favori yemeğiniz yok',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppTheme.textLightColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<Food> favorites) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final food = favorites[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16.h),
          child: ListTile(
            contentPadding: EdgeInsets.all(16.w),
            title: Text(
              food.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(
                  food.description,
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 16.sp,
                      color: AppTheme.textLightColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${food.preparationTime} dakika',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textLightColor,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.local_fire_department,
                      size: 16.sp,
                      color: AppTheme.textLightColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${food.calories} kcal',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textLightColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: AppTheme.errorColor),
              onPressed: () {
                context
                    .read<UserPreferencesViewModel>()
                    .toggleFavorite(food.id);
              },
            ),
          ),
        );
      },
    );
  }
}
