import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../core/constants/app_constants.dart';
import '../models/issue_model.dart';
import '../services/issue_service.dart';
import '../services/admin_service.dart';
import '../widgets/elevated_card.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/admin_issue_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final issueService = context.watch<IssueService>();
    final adminService = context.watch<AdminService>();
    final stats = adminService.getStatistics(issueService.issues);
    final filteredIssues = adminService.applyFilters(issueService.issues);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Helpers.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAppBar(context),
                        const SizedBox(height: 24),
                        _buildStatsRow(context, stats),
                        const SizedBox(height: 24),
                        _buildChartSection(context, issueService),
                        const SizedBox(height: 24),
                        _buildFilters(context, adminService),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.softTeal,
                      unselectedLabelColor: AppColors.textTertiary,
                      indicatorColor: AppColors.softTeal,
                      tabs: [
                        Tab(text: 'All (${filteredIssues.length})'),
                        Tab(text: 'Pending (${stats['pending']})'),
                        Tab(text: 'Resolved (${stats['resolved']})'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildIssueList(context, filteredIssues, issueService),
                _buildIssueList(
                    context,
                    filteredIssues
                        .where((i) => i.status == IssueStatus.pending)
                        .toList(),
                    issueService),
                _buildIssueList(
                    context,
                    filteredIssues
                        .where((i) => i.status == IssueStatus.resolved)
                        .toList(),
                    issueService),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Dashboard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Manage civic issues',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, Map<String, dynamic> stats) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard(context, 'Total', stats['total'].toString(),
              Icons.list_alt_rounded, AppColors.softTeal),
          const SizedBox(width: 12),
          _buildStatCard(context, 'Critical', stats['critical'].toString(),
              Icons.warning_rounded, AppColors.critical),
          const SizedBox(width: 12),
          _buildStatCard(context, 'In Progress', stats['inProgress'].toString(),
              Icons.pending_rounded, AppColors.warning),
          const SizedBox(width: 12),
          _buildStatCard(context, 'Resolution', '${stats['resolutionRate']}%',
              Icons.check_circle_rounded, AppColors.success),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Helpers.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Helpers.getTextPrimary(context),
                ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Helpers.getTextSecondary(context),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(BuildContext context, IssueService issueService) {
    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Issue Distribution',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: PieChartWidget(
              data: issueService.getStatusDistribution(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, AdminService adminService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Filters & Sort',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => adminService.clearFilters(),
              child: Text(
                'Clear All',
                style: TextStyle(color: AppColors.softTeal),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(
                context,
                'Zone',
                adminService.selectedZoneFilter,
                AppConstants.zones,
                (value) => adminService.setZoneFilter(value),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                'Category',
                adminService.selectedCategoryFilter,
                AppConstants.issueCategories,
                (value) => adminService.setCategoryFilter(value),
              ),
              const SizedBox(width: 8),
              _buildSortChip(context, adminService),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label,
      String? selectedValue, List<String> options, Function(String?) onSelect) {
    return PopupMenuButton<String>(
      onSelected: (value) => onSelect(value == 'all' ? null : value),
      itemBuilder: (context) => [
        PopupMenuItem(value: 'all', child: Text('All $label')),
        ...options
            .map((option) => PopupMenuItem(value: option, child: Text(option))),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selectedValue != null
              ? AppColors.softTeal.withOpacity(0.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedValue != null
                ? AppColors.softTeal
                : AppColors.textTertiary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedValue ?? label,
              style: TextStyle(
                color: selectedValue != null
                    ? AppColors.softTeal
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: selectedValue != null
                  ? AppColors.softTeal
                  : AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(BuildContext context, AdminService adminService) {
    return GestureDetector(
      onTap: () => adminService.toggleSortOrder(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Helpers.getCardColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.textTertiary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Priority',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              adminService.sortDescending
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueList(BuildContext context, List<IssueModel> issues,
      IssueService issueService) {
    if (issues.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No issues found',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AdminIssueCard(
            issue: issues[index],
            onStatusChange: (status) {
              final issueStatus = IssueStatus.values.firstWhere(
                (e) => e.name == status || e.name == status.replaceAll('_', ''),
                orElse: () => IssueStatus.pending,
              );
              issueService.updateIssueStatus(issues[index].id, issueStatus);
            },
          ),
        );
      },
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Helpers.getBackgroundColor(context),
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
