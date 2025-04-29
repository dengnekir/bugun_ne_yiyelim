import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bugun_ne_yiyelim/viewmodels/theme_viewmodel.dart';
import 'package:bugun_ne_yiyelim/viewmodels/user_preferences_viewmodel.dart';
import 'package:bugun_ne_yiyelim/constants/app_theme.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _appVersion = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = context.watch<ThemeViewModel>();
    final userPrefsVM = context.watch<UserPreferencesViewModel>();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Tema Ayarları', themeVM.currentModeColor),
            SizedBox(height: 8.h),
            _buildThemeSettings(themeVM),
            SizedBox(height: 24.h),
            _buildSectionTitle('Bildirim Ayarları', themeVM.currentModeColor),
            SizedBox(height: 8.h),
            _buildNotificationSettings(userPrefsVM),
            SizedBox(height: 24.h),
            _buildSectionTitle('Uygulama Hakkında', themeVM.currentModeColor),
            SizedBox(height: 8.h),
            _buildAboutSection(themeVM.currentModeColor),
            SizedBox(height: 24.h),
            _buildSectionTitle('İletişim', themeVM.currentModeColor),
            SizedBox(height: 8.h),
            _buildContactSection(themeVM.currentModeColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color currentModeColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: currentModeColor,
      ),
    );
  }

  Widget _buildThemeSettings(ThemeViewModel themeVM) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildModeOption(
            AppConstants.modeNormal,
            'Normal Mod',
            Icons.restaurant_menu,
            AppTheme.modeColors[AppConstants.modeNormal]!,
            themeVM,
          ),
          _buildDivider(),
          _buildModeOption(
            AppConstants.modeSports,
            'Spor Modu',
            Icons.fitness_center,
            AppTheme.modeColors[AppConstants.modeSports]!,
            themeVM,
          ),
          _buildDivider(),
          _buildModeOption(
            AppConstants.modeDiet,
            'Diyet Modu',
            Icons.spa,
            AppTheme.modeColors[AppConstants.modeDiet]!,
            themeVM,
          ),
          _buildDivider(),
          _buildModeOption(
            AppConstants.modeCulture,
            'Kültür Modu',
            Icons.public,
            AppTheme.modeColors[AppConstants.modeCulture]!,
            themeVM,
          ),
        ],
      ),
    );
  }

  Widget _buildModeOption(
    String mode,
    String label,
    IconData icon,
    Color color,
    ThemeViewModel themeVM,
  ) {
    final isSelected = themeVM.currentMode == mode;
    return InkWell(
      onTap: () => themeVM.updateMode(mode),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : Colors.grey[700],
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings(UserPreferencesViewModel userPrefsVM) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            'Günlük Öneriler',
            'Her gün yeni yemek önerileri al',
            userPrefsVM.dailyNotifications,
            (value) => userPrefsVM.updateDailyNotifications(value),
          ),
          _buildDivider(),
          _buildSwitchTile(
            'Özel Günler',
            'Özel günlerde özel tarifler al',
            userPrefsVM.specialDayNotifications,
            (value) => userPrefsVM.updateSpecialDayNotifications(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[600],
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
    );
  }

  Widget _buildAboutSection(Color currentModeColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildInfoTile(
            'Uygulama Versiyonu',
            _isLoading ? 'Yükleniyor...' : _appVersion,
            Icons.info_outline,
            currentModeColor,
          ),
          _buildDivider(),
          _buildDivider(),
          _buildActionTile(
            'Gizlilik Politikası',
            'Gizlilik politikamızı inceleyin',
            FontAwesomeIcons.shield,
            currentModeColor,
            () => _launchURL('https://dengnekir.com/'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(Color currentModeColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildActionTile(
            'Geri Bildirim',
            'Görüşlerinizi bizimle paylaşın',
            FontAwesomeIcons.envelope,
            currentModeColor,
            () => _launchURL('mailto:usluferhat98@gmail.com'),
          ),
          _buildDivider(),
          _buildActionTile(
            'Bizi Değerlendirin',
            'Play Store\'da puanlayın',
            Icons.star_outline,
            currentModeColor,
            () => _launchURL('market://details?id=com.example.app'),
          ),
          _buildDivider(),
          _buildActionTile(
            'Sosyal Medya',
            'Bizi sosyal medyada takip edin',
            Icons.public,
            currentModeColor,
            () => _showSocialMediaDialog(currentModeColor),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    String title,
    String subtitle,
    IconData icon,
    Color currentModeColor,
  ) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: currentModeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: currentModeColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color currentModeColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: currentModeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: currentModeColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('URL açılamadı: $url');
    }
  }

  void _showSocialMediaDialog(Color currentModeColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sosyal Medya',
          style: TextStyle(
            color: currentModeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSocialMediaButton(
              'LinkedIn',
              FontAwesomeIcons.linkedin,
              currentModeColor,
              () => _launchURL('https://linkedin.com/in/ferhat-uslu'),
            ),
            SizedBox(height: 8.h),
            _buildSocialMediaButton(
              'Web Sitemiz',
              FontAwesomeIcons.globe,
              currentModeColor,
              () => _launchURL('https://dengnekir.com'),
            ),
            SizedBox(height: 8.h),
            _buildSocialMediaButton(
              'Diğer Uygulamalarımız',
              FontAwesomeIcons.mobileScreen,
              currentModeColor,
              () => _launchURL(
                  'https://play.google.com/store/apps/developer?id=Dengnekir'),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  Widget _buildSocialMediaButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 16.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
