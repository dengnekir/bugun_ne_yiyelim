import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bugun_ne_yiyelim/constants/app_theme.dart';
import 'package:bugun_ne_yiyelim/viewmodels/user_preferences_viewmodel.dart';
import 'package:bugun_ne_yiyelim/viewmodels/food_viewmodel.dart';
import 'package:bugun_ne_yiyelim/views/food_detail_view.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final userPrefsVM = context.watch<UserPreferencesViewModel>();
    final foodVM = context.watch<FoodViewModel>();
    final favoriteFoods = foodVM.getFavoriteFoods(userPrefsVM.favoriteFoodIds);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorilerim',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: favoriteFoods.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: favoriteFoods.length,
              itemBuilder: (context, index) {
                final food = favoriteFoods[index];
                final modeColor =
                    AppTheme.modeColors[food.mode] ?? AppTheme.primaryColor;

                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Hero(
                    tag: 'food_card_${food.id}',
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailView(
                              food: food,
                              modeColor: modeColor,
                            ),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                modeColor.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Row(
                              children: [
                                Container(
                                  width: 80.w,
                                  height: 80.w,
                                  decoration: BoxDecoration(
                                    color: modeColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.restaurant,
                                    size: 40.sp,
                                    color: modeColor,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.name,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: modeColor,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        food.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.timer,
                                            size: 16.sp,
                                            color: modeColor,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            '${food.preparationTime} dk',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: modeColor,
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          Icon(
                                            Icons.local_fire_department,
                                            size: 16.sp,
                                            color: modeColor,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            '${food.calories} kcal',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: modeColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.favorite,
                                      color: AppTheme.errorColor),
                                  onPressed: () =>
                                      userPrefsVM.toggleFavorite(food.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.sp,
            color: Colors.grey[400],
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
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
