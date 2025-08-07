import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/viewModels/language/language_controller/language_controller.dart';
import 'package:mrtv_new_app_sl/viewModels/theme/theme_controller/theme_controller.dart';
import 'package:mrtv_new_app_sl/views/bookmark/bookmark_screen.dart';

class AppSettingScreen extends StatelessWidget {
  AppSettingScreen({super.key});
  final LanguageController languageController = Get.put(LanguageController());
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("setting".tr),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,

        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('general'.tr),
          _buildListTile(
            context: context,
            icon: Icons.language,

            title: 'language'.tr,

            subtitle: 'select_language'.tr,
            onTap: () => _showLanguageDialog(context),
          ),
          Obx(
            () => ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              leading: Icon(Icons.brightness_6),
              title: Text(
                'theme'.tr,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Switch(
                value: themeController.isDark.value,
                onChanged: (_) => themeController.toggleTheme(),
              ),
              onTap:
                  () =>
                      themeController.toggleTheme(), // Optional: toggle on tap
            ),
          ),
          const Divider(height: 32),

          _buildSectionTitle('info'.tr),
          _buildListTile(
            context: context,
            icon: Icons.info_outline,
            title: 'info'.tr,
            subtitle: 'version 1.0.0',
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text("App Info"),
                      content: Text(
                        "MRTV News App\nVersion 1.0.0\nDeveloped by MKKHS Team.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("OK"),
                        ),
                      ],
                    ),
              );
            }, // TODO: Show app info
          ),
          _buildListTile(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: 'privacy'.tr,
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text("Privacy Policy"),
                      content: SingleChildScrollView(
                        child: Text(
                          "We respect your privacy.\n\nYour data is not shared with third parties. "
                          "All access is limited to providing essential services only. "
                          "By using this app, you agree to this policy.",
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Close"),
                        ),
                      ],
                    ),
              );
            }, // TODO: Show privacy policy
          ),

          const Divider(height: 32),

          _buildListTile(
            context: context,
            icon: Icons.bookmark,
            title: 'bookmark'.tr,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => BookmarkScreen()));
            },
          ),
          const Divider(height: 32),

          _buildListTile(
            context: context,
            icon: Icons.logout,
            title: 'logout'.tr,
            onTap: () {
              // TODO: Handle logout logic
            },
            iconColor: Colors.redAccent,
            textColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Icon(
        icon,
        color: iconColor ?? (isDark ? Colors.white70 : Colors.black54),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor ?? Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8, top: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'select_language'.tr,
      content: Column(
        children: [
          ListTile(
            title: Text('English'),
            onTap: () {
              languageController.changeLanguage('en', 'US');
              Get.back();
            },
          ),
          ListTile(
            title: Text('မြန်မာ'),
            onTap: () {
              languageController.changeLanguage('my', 'MM');
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
