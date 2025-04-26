import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bugun_ne_yiyelim/constants/app_theme.dart';
import 'package:bugun_ne_yiyelim/viewmodels/user_preferences_viewmodel.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userPrefsVM = context.watch<UserPreferencesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _buildNotificationSettings(context, userPrefsVM),
          SizedBox(height: 16.h),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(
    BuildContext context,
    UserPreferencesViewModel userPrefsVM,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bildirimler',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            SwitchListTile(
              title: Text(
                'Günlük Yemek Önerileri',
                style: TextStyle(fontSize: 16.sp),
              ),
              subtitle: Text(
                'Her gün yeni bir yemek önerisi al',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textLightColor,
                ),
              ),
              value: userPrefsVM.userPreferences?.notificationsEnabled ?? false,
              onChanged: (bool value) {
                userPrefsVM.updatePreferences(notifications: value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hakkında',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            ListTile(
              title: Text(
                'Uygulama Versiyonu',
                style: TextStyle(fontSize: 16.sp),
              ),
              trailing: Text(
                '1.0.0',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppTheme.textLightColor,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Gizlilik Politikası',
                style: TextStyle(fontSize: 16.sp),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Gizlilik politikası sayfasına yönlendir
              },
            ),
            ListTile(
              title: Text(
                'Kullanım Koşulları',
                style: TextStyle(fontSize: 16.sp),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Kullanım koşulları sayfasına yönlendir
              },
            ),
          ],
        ),
      ),
    );
  }
}
