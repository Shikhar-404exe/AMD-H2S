import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../models/issue_model.dart';
import '../services/issue_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/mock_map_widget.dart';
import '../widgets/real_map_widget.dart';

class SmartMapScreen extends StatefulWidget {
  const SmartMapScreen({super.key});

  @override
  State<SmartMapScreen> createState() => _SmartMapScreenState();
}

class _SmartMapScreenState extends State<SmartMapScreen> {
  bool get _useMockData {
    final useMock = dotenv.env['USE_MOCK_DATA']?.toLowerCase();
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    return useMock == 'true' ||
        apiKey == null ||
        apiKey.isEmpty ||
        apiKey == 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
  }

  @override
  Widget build(BuildContext context) {
    final issueService = context.watch<IssueService>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Helpers.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: _useMockData
                        ? MockMapWidget(
                            issues: issueService.issues,
                            onMarkerTap: (issue) {
                              _showIssueBottomSheet(issue);
                            },
                          )
                        : RealMapWidget(
                            issues: issueService.issues,
                            onIssueSelected: (issue) {
                              _showIssueBottomSheet(issue);
                            },
                          ),
                  ),
                ],
              ),
              Positioned(
                top: 100,
                right: 20,
                child: _buildMapLegend(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
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
                  'Smart Map',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'View all reported issues',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLegend() {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          _buildLegendItem(AppColors.critical, 'Critical'),
          _buildLegendItem(AppColors.high, 'High'),
          _buildLegendItem(AppColors.medium, 'Medium'),
          _buildLegendItem(AppColors.resolved, 'Resolved'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Helpers.getTextPrimary(context),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showIssueBottomSheet(IssueModel issue) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Helpers.getCardColor(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textTertiary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Helpers.getPriorityColor(issue.priorityScore)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Helpers.getCategoryIcon(issue.category),
                          color: Helpers.getPriorityColor(issue.priorityScore),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              issue.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              issue.category,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Helpers.getPriorityColor(issue.priorityScore)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          Helpers.getPriorityLabel(issue.priorityScore),
                          style: TextStyle(
                            color:
                                Helpers.getPriorityColor(issue.priorityScore),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    issue.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(Icons.location_on_rounded, issue.zone),
                  _buildInfoRow(Icons.access_time_rounded,
                      Helpers.timeAgo(issue.createdAt)),
                  _buildInfoRow(
                      Icons.person_rounded, 'Reported by ${issue.reportedBy}'),
                  _buildInfoRow(
                    Icons.circle,
                    issue.status.name.toUpperCase(),
                    color: issue.status == IssueStatus.resolved
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Mark Resolved'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color ?? AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: color ?? AppColors.textSecondary,
              fontWeight: color != null ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
