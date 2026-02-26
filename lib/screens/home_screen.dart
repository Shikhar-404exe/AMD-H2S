import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../routes/app_router.dart';
import '../services/issue_service.dart';
import '../services/crowd_service.dart';
import '../services/health_service.dart';
import '../services/user_service.dart';
import '../engines/cognitive_load_engine.dart';
import '../widgets/elevated_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/circular_meter.dart';
import '../widgets/live_iot_widget.dart';
import '../widgets/profile_drawer.dart';
import '../widgets/quick_action_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final issueService = context.watch<IssueService>();
    final crowdService = context.watch<CrowdService>();
    final healthService = context.watch<HealthService>();
    final cognitiveEngine = context.read<CognitiveLoadEngine>();
    final userService = context.watch<UserService>();

    final cognitiveLoad = cognitiveEngine.calculateCognitiveLoadScore(
      crowdDensity: crowdService.getAverageDensity(),
      heartRate: healthService.currentData?.heartRate,
    );

    return Scaffold(
      key: _scaffoldKey,
      drawer: const ProfileDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: Helpers.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, userService),
                      const SizedBox(height: 24),
                      _buildStatCards(issueService),
                      const SizedBox(height: 24),
                      _buildQuickActions(context),
                      const SizedBox(height: 24),
                      _buildDashboardMetrics(cognitiveLoad, crowdService),
                      const SizedBox(height: 24),
                      _buildChartSection(issueService),
                      const SizedBox(height: 24),
                      const LiveIoTWidget(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRouter.reportIssue),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Report Issue'),
        backgroundColor: AppColors.softTeal,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserService userService) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${userService.currentUser?.name.split(' ').first ?? 'User'}!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome to CivicMind',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.settings),
              icon: Icon(
                Icons.settings_outlined,
                color: AppColors.textSecondary,
              ),
            ),
            GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.softTeal.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCards(IssueService issueService) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Active Issues',
            value: issueService.activeIssues.length.toString(),
            icon: Icons.warning_amber_rounded,
            color: AppColors.warmPeach,
            trend: '+3 today',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Critical',
            value: issueService.criticalIssues.length.toString(),
            icon: Icons.priority_high_rounded,
            color: AppColors.critical,
            trend: 'Needs attention',
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              QuickActionButton(
                icon: Icons.map_rounded,
                label: 'Smart Map',
                color: AppColors.softTeal,
                onTap: () => Navigator.pushNamed(context, AppRouter.smartMap),
              ),
              QuickActionButton(
                icon: Icons.spa_rounded,
                label: 'Calm Zones',
                color: AppColors.mintGreen,
                onTap: () => Navigator.pushNamed(context, AppRouter.calmZone),
              ),
              QuickActionButton(
                icon: Icons.psychology_rounded,
                label: 'Cognitive',
                color: AppColors.mutedLavender,
                onTap: () =>
                    Navigator.pushNamed(context, AppRouter.cognitiveLoad),
              ),
              QuickActionButton(
                icon: Icons.groups_rounded,
                label: 'Crowd',
                color: AppColors.warmPeach,
                onTap: () =>
                    Navigator.pushNamed(context, AppRouter.crowdDensity),
              ),
              QuickActionButton(
                icon: Icons.eco_rounded,
                label: 'Environment',
                color: AppColors.powderBlue,
                onTap: () =>
                    Navigator.pushNamed(context, AppRouter.environmental),
              ),
              QuickActionButton(
                icon: Icons.admin_panel_settings_rounded,
                label: 'Admin',
                color: AppColors.softTeal,
                onTap: () =>
                    Navigator.pushNamed(context, AppRouter.adminDashboard),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardMetrics(
      double cognitiveLoad, CrowdService crowdService) {
    return Row(
      children: [
        Expanded(
          child: ElevatedCard(
            child: Column(
              children: [
                Text(
                  'Cognitive Load',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                CircularMeter(
                  value: cognitiveLoad,
                  size: 100,
                  label: 'Stress',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedCard(
            child: Column(
              children: [
                Text(
                  'Crowd Density',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                CircularMeter(
                  value: crowdService.getAverageDensity(),
                  size: 100,
                  label: 'Density',
                  color: AppColors.warmPeach,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection(IssueService issueService) {
    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Issues by Category',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChartWidget(
              data: issueService.getCategoryDistribution(),
            ),
          ),
        ],
      ),
    );
  }
}
