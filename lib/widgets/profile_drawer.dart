import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../services/user_service.dart';
import '../routes/app_router.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = context.watch<UserService>();
    final user = userService.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Helpers.getPrimaryColor(context);

    return Drawer(
      backgroundColor: Helpers.getCardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppColors.darkPrimaryGradient
                    : AppColors.primaryGradient,
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'G',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'Guest',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'guest@civicmind.app',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user?.role.toUpperCase() ?? 'GUEST',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatItem(
                      context, '${user?.issuesReported ?? 0}', 'Reported'),
                  _buildStatItem(
                      context, '${user?.issuesResolved ?? 0}', 'Resolved'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildMenuItem(context, Icons.home_rounded, 'Home', () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRouter.home);
            }),
            _buildMenuItem(context, Icons.map_rounded, 'Smart Map', () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.smartMap);
            }),
            _buildMenuItem(context, Icons.spa_rounded, 'Calm Zones', () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.calmZone);
            }),
            _buildMenuItem(context, Icons.psychology_rounded, 'Cognitive Load',
                () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.cognitiveLoad);
            }),
            if (userService.isAdmin)
              _buildMenuItem(
                  context, Icons.admin_panel_settings_rounded, 'Admin', () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRouter.adminDashboard);
              }),
            _buildMenuItem(context, Icons.settings_rounded, 'Settings', () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.settings);
            }),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await userService.logout();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, AppRouter.login);
                    }
                  },
                  icon: Icon(Icons.logout_rounded, color: AppColors.critical),
                  label: Text(
                    'Sign Out',
                    style: TextStyle(color: AppColors.critical),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.critical),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Helpers.getBackgroundColor(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Helpers.getPrimaryColor(context),
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final primaryColor = Helpers.getPrimaryColor(context);

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textTertiary,
      ),
      onTap: onTap,
    );
  }
}
