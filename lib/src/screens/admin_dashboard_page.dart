part of '../society_app.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({
    super.key,
    required this.data,
    required this.currentUser,
    required this.onOpenProfile,
    required this.onOpenComplaints,
    required this.onOpenBills,
    required this.onOpenNotices,
    required this.onOpenMembers,
    required this.onComplaintTap,
    
  });

  final SocietyData data;
  final AppUser currentUser;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenComplaints;
  final VoidCallback onOpenBills;
  final VoidCallback onOpenNotices;
  final VoidCallback onOpenMembers;
  final ValueChanged<Complaint> onComplaintTap;

  @override
  Widget build(BuildContext context) {
    final recentComplaints = data.complaints.take(3).toList();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _DashboardHero(
          greeting: 'Good morning,',
          title: currentUser.name,
          subtitle: '${data.society.name}  •  ${data.society.location}',
          trailingText: currentUser.initials,
          onAvatarTap: onOpenProfile,
          stats: [
            _HeroMetric(
              value: '${data.society.occupiedUnits}',
              label: 'Occupied',
            ),
            _HeroMetric(
              value: '${data.society.vacantUnits}',
              label: 'Vacant',
            ),
            _HeroMetric(
              value: '${data.society.pendingBillsCount}',
              label: 'Pending Bills',
            ),
            _HeroMetric(
              value: '${data.society.openIssuesCount}',
              label: 'Open Issues',
            ),
          ],
        ),
        const _SectionHeader('Overview'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: 1.18,
            children: [
              _MetricCard(
                title: 'Total Members',
                value: '${data.society.memberCount}',
                icon: Icons.groups_2_outlined,
                accent: AppColors.primary,
                onTap: onOpenMembers,
              ),
              _MetricCard(
                title: 'Open Complaints',
                value: '${data.complaints.where((c) => c.status != ComplaintStatus.resolved).length}',
                icon: Icons.error_outline_rounded,
                accent: AppColors.warning,
                onTap: onOpenComplaints,
              ),
              _MetricCard(
                title: 'Collected (Apr)',
                value: data.society.monthlyCollectionLabel,
                icon: Icons.payments_outlined,
                accent: AppColors.success,
                onTap: onOpenBills,
              ),
              _MetricCard(
                title: 'Active Notices',
                value: '${data.society.activeNoticesCount}',
                icon: Icons.campaign_outlined,
                accent: AppColors.purple,
                onTap: onOpenNotices,
              ),
            ],
          ),
        ),
        const _SectionHeader('Recent Complaints'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: _SurfaceCard(
            child: Column(
              children: recentComplaints
                  .map(
                    (complaint) => _ComplaintRow(
                      complaint: complaint,
                      onTap: () => onComplaintTap(complaint),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const _SectionHeader('Quick Actions'),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
          child: Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.campaign_outlined,
                  label: 'Post Notice',
                  onTap: onOpenNotices,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.person_add_alt_1_outlined,
                  label: 'Add Member',
                  onTap: onOpenMembers,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

