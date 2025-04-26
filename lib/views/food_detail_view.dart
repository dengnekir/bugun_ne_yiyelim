import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bugun_ne_yiyelim/constants/app_theme.dart';
import 'package:bugun_ne_yiyelim/models/food.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodDetailView extends StatefulWidget {
  final Food food;

  const FoodDetailView({super.key, required this.food});

  @override
  State<FoodDetailView> createState() => _FoodDetailViewState();
}

class _FoodDetailViewState extends State<FoodDetailView> {
  bool _isIngredientsExpanded = false;
  bool _isInstructionsExpanded = false;
  bool _isNutritionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 24.h),
                  _buildExpandableSection(
                    title: 'Malzemeler',
                    isExpanded: _isIngredientsExpanded,
                    onTap: () => setState(
                        () => _isIngredientsExpanded = !_isIngredientsExpanded),
                    child: _buildIngredients(),
                  ),
                  SizedBox(height: 16.h),
                  _buildExpandableSection(
                    title: 'Hazırlanışı',
                    isExpanded: _isInstructionsExpanded,
                    onTap: () => setState(() =>
                        _isInstructionsExpanded = !_isInstructionsExpanded),
                    child: _buildInstructions(),
                  ),
                  SizedBox(height: 16.h),
                  _buildExpandableSection(
                    title: 'Besin Değerleri',
                    isExpanded: _isNutritionExpanded,
                    onTap: () => setState(
                        () => _isNutritionExpanded = !_isNutritionExpanded),
                    child: _buildNutritionInfo(),
                  ),
                  SizedBox(height: 24.h),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Favorilere ekleme fonksiyonu
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.favorite_border),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.food.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            widget.food.imageUrl.isNotEmpty
                ? Image.network(
                    widget.food.imageUrl,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: AppTheme.primaryColor,
                    child: Icon(
                      Icons.restaurant,
                      size: 64.sp,
                      color: Colors.white,
                    ),
                  ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.food.description,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppTheme.textColor,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            if (widget.food.isQuick)
              _buildTag(Icons.timer, 'Hızlı', AppTheme.primaryColor),
            if (widget.food.isHealthy)
              _buildTag(Icons.favorite, 'Sağlıklı', Colors.green),
            if (widget.food.isHighProtein)
              _buildTag(Icons.fitness_center, 'Proteinli', Colors.orange),
            if (widget.food.isLowCalorie)
              _buildTag(Icons.whatshot, 'Düşük Kalorili', Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Malzemeler',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.food.ingredients.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                children: [
                  Icon(
                    Icons.fiber_manual_record,
                    size: 8.sp,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    widget.food.ingredients[index],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.textColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < widget.food.instructions.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      widget.food.instructions[i],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.textColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutritionItem(
            Icons.timer,
            'Hazırlama',
            '${widget.food.preparationTime} dk',
          ),
          Container(
            height: 40.h,
            width: 1,
            color: Colors.grey[300],
          ),
          _buildNutritionItem(
            Icons.local_fire_department,
            'Kalori',
            '${widget.food.calories} kcal',
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppTheme.textLightColor,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                firstChild: Container(),
                secondChild: child,
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          onPressed: () => _launchYemeksepetiSearch(context, widget.food.name),
          icon: Icons.shopping_cart,
          label: 'Yemeksepeti\'nde Sipariş Ver',
          color: Colors.red,
        ),
        SizedBox(height: 8.h),
        _buildActionButton(
          onPressed: () => _launchGetirSearch(context, widget.food.name),
          icon: Icons.delivery_dining,
          label: 'Getir\'den Sipariş Ver',
          color: const Color(0xFF5D3EBC),
        ),
        SizedBox(height: 8.h),
        _buildActionButton(
          onPressed: () {
            // TODO: Tarif paylaşma fonksiyonu
          },
          icon: Icons.share,
          label: 'Tarifi Paylaş',
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
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

  Future<void> _launchYemeksepetiSearch(
      BuildContext context, String foodName) async {
    final url = Uri.parse(
        'https://www.yemeksepeti.com/arama?search=${Uri.encodeComponent(foodName)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Yemeksepeti açılamadı')),
        );
      }
    }
  }

  Future<void> _launchGetirSearch(BuildContext context, String foodName) async {
    final url =
        Uri.parse('https://getir.com/arama/${Uri.encodeComponent(foodName)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Getir açılamadı')),
        );
      }
    }
  }
}
