import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../widgets/elevated_card.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _biometricsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Helpers.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                const SizedBox(height: 24),
                _buildGeneralSettings(context, themeService),
                const SizedBox(height: 24),
                _buildPrivacySettings(context),
                const SizedBox(height: 24),
                _buildApiSettings(context),
                const SizedBox(height: 24),
                _buildAboutSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Helpers.getCardColor(context),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildGeneralSettings(
      BuildContext context, ThemeService themeService) {
    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Notifications',
            'Receive alerts about issues and updates',
            Icons.notifications_outlined,
            _notificationsEnabled,
            (value) => setState(() => _notificationsEnabled = value),
          ),
          _buildSwitchTile(
            'Location Services',
            'Enable for better recommendations',
            Icons.location_on_outlined,
            _locationEnabled,
            (value) => setState(() => _locationEnabled = value),
          ),
          _buildSwitchTile(
            'Dark Mode',
            'AMD-themed dark interface',
            Icons.dark_mode_outlined,
            themeService.isDarkMode,
            (value) => themeService.toggleTheme(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings(BuildContext context) {
    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy & Security',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Biometric Authentication',
            'Use fingerprint or face ID',
            Icons.fingerprint,
            _biometricsEnabled,
            (value) => setState(() => _biometricsEnabled = value),
          ),
          const SizedBox(height: 8),
          _buildActionTile(
            'Clear Cache',
            'Free up storage space',
            Icons.cleaning_services_outlined,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
              );
            },
          ),
          _buildActionTile(
            'Export Data',
            'Download your data',
            Icons.download_outlined,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildApiSettings(BuildContext context) {
    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'API Configuration',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Dev Mode',
                  style: TextStyle(
                    color: AppColors.mintGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Environment variables for future integrations',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          _buildEnvField(
              'GOOGLE_MAPS_API_KEY', dotenv.env['GOOGLE_MAPS_API_KEY']),
          const SizedBox(height: 12),
          _buildEnvField('FIREBASE_URL', dotenv.env['FIREBASE_URL']),
          const SizedBox(height: 12),
          _buildEnvField('SPOTIFY_API_KEY', dotenv.env['SPOTIFY_API_KEY']),
          const SizedBox(height: 12),
          _buildEnvField('HEALTH_API_KEY', dotenv.env['HEALTH_API_KEY']),
          const SizedBox(height: 16),
          Text(
            'Note: The app runs on mock data when keys are not configured.',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvField(String label, String? value) {
    final isConfigured = value != null && value.isNotEmpty;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  isConfigured
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 16,
                  color:
                      isConfigured ? AppColors.success : AppColors.textTertiary,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildInfoTile('App Version', '1.0.0'),
          _buildInfoTile('Build', '2024.02.001'),
          _buildInfoTile('Developer', 'CivicMind Team'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('Terms'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.softTeal,
                    side: BorderSide(color: AppColors.softTeal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.privacy_tip_outlined),
                  label: const Text('Privacy'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.softTeal,
                    side: BorderSide(color: AppColors.softTeal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon,
      bool value, Function(bool) onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.amdRed : AppColors.softTeal;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.amdRed : AppColors.softTeal;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color:
                  isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
