import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../models/issue_model.dart';

class AdminIssueCard extends StatelessWidget {
  final IssueModel issue;
  final Function(String)? onStatusChange;
  final VoidCallback? onTap;

  const AdminIssueCard({
    super.key,
    required this.issue,
    this.onStatusChange,
    this.onTap,
  });

  String _getPriorityLabel(double score) {
    if (score >= 0.7) return 'CRITICAL';
    if (score >= 0.5) return 'HIGH';
    if (score >= 0.3) return 'MEDIUM';
    return 'LOW';
  }

  Color _getPriorityColor(double score) {
    if (score >= 0.7) return AppColors.critical;
    if (score >= 0.5) return AppColors.high;
    if (score >= 0.3) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Helpers.getCardColor(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(issue.priorityScore)
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Helpers.getCategoryIcon(issue.category),
                      color: _getPriorityColor(issue.priorityScore),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                issue.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(issue.priorityScore)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getPriorityLabel(issue.priorityScore),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _getPriorityColor(issue.priorityScore),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          issue.description,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              issue.zone,
                              style: TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              Helpers.timeAgo(issue.createdAt),
                              style: TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkCard
                    : AppColors.background,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildStatusChip(
                              'Pending', issue.status == 'pending'),
                          const SizedBox(width: 6),
                          _buildStatusChip(
                              'In Progress', issue.status == 'in_progress'),
                          const SizedBox(width: 6),
                          _buildStatusChip(
                              'Resolved', issue.status == 'resolved'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded,
                        color: AppColors.textSecondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onSelected: onStatusChange,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'pending',
                        child: Row(
                          children: [
                            Icon(Icons.hourglass_empty_rounded, size: 18),
                            SizedBox(width: 8),
                            Text('Mark Pending'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'in_progress',
                        child: Row(
                          children: [
                            Icon(Icons.engineering_rounded, size: 18),
                            SizedBox(width: 8),
                            Text('Mark In Progress'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'resolved',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_rounded, size: 18),
                            SizedBox(width: 8),
                            Text('Mark Resolved'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, bool isActive) {
    Color chipColor;
    if (label == 'Pending') {
      chipColor = AppColors.warning;
    } else if (label == 'In Progress') {
      chipColor = AppColors.powderBlue;
    } else {
      chipColor = AppColors.success;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? chipColor : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? chipColor : AppColors.textTertiary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : AppColors.textTertiary,
        ),
      ),
    );
  }
}
