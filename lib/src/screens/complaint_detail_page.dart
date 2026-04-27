part of '../society_app.dart';

class ComplaintDetailPage extends StatelessWidget {
  const ComplaintDetailPage({
    super.key,
    required this.complaint,
  });

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDetailAppBar(context, title: 'Complaint Detail'),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        complaint.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(
                      label: complaint.priority.label,
                      background: badgeBackgroundForPriority(complaint.priority)
                          .withOpacity(0.9),
                      textColor: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${complaint.id}  •  Filed ${complaint.dateLabel}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.76),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _HeroInfoCard(
                        label: 'Reported by',
                        value: complaint.reporterName,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _HeroInfoCard(
                        label: 'Category',
                        value: complaint.category,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _HeroInfoCard(
                        label: 'Status',
                        value: complaint.status.label,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _SurfaceCard(
                  child: _TitledBody(
                    title: 'Description',
                    child: Text(
                      complaint.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (complaint.assignedToName.isNotEmpty)
                  _SurfaceCard(
                    child: _TitledBody(
                      title: 'Assigned To',
                      child: Row(
                        children: [
                          PersonAvatar(
                            initials: initialsFromName(complaint.assignedToName),
                            accent: AppColors.success,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  complaint.assignedToName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  complaint.assignedToRole,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.call_outlined,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                _SurfaceCard(
                  child: _TitledBody(
                    title: 'Activity Timeline',
                    child: Column(
                      children: complaint.activities
                          .asMap()
                          .entries
                          .map(
                            (entry) => _TimelineTile(
                              activity: entry.value,
                              isLast: entry.key == complaint.activities.length - 1,
                            ),
                          )
                          .toList(),
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
}

