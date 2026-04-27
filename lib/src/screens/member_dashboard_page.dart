part of '../society_app.dart';

class MemberDashboardPage extends StatelessWidget {
  const MemberDashboardPage({
    super.key,
    required this.data,
    required this.currentUser,
    required this.onOpenProfile,
    required this.onOpenComplaints,
    required this.onOpenBills,
    required this.onOpenNotice,
  });

  final SocietyData data;
  final AppUser currentUser;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenComplaints;
  final VoidCallback onOpenBills;
  final ValueChanged<Notice> onOpenNotice;

  @override
  Widget build(BuildContext context) {
    final notices = effectiveNoticeList(data.notices).take(2).toList();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _DashboardHero(
          greeting: 'Good morning,',
          title: currentUser.name,
          subtitle: '${currentUser.flat}  •  ${currentUser.memberType.label}',
          trailingText: currentUser.initials,
          onAvatarTap: onOpenProfile,
          highlightCard: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.22)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flat No.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentUser.flat,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Due Amount',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatAmount(data.society.dueAmount),
                      style: const TextStyle(
                        color: Color(0xFFFFD54F),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.warning.withOpacity(0.2)),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Maintenance Due - April 2025',
                        style: TextStyle(
                          color: Color(0xFFE65100),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Due by Apr 10  •  ${formatAmount(data.society.dueAmount)}',
                        style: const TextStyle(
                          color: AppColors.warning,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onOpenBills,
                  child: const Text('Pay Now'),
                ),
              ],
            ),
          ),
        ),
        const _SectionHeader('My Overview'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: 1.22,
            children: [
              _MetricCard(
                title: 'My Complaints',
                value:
                    '${data.complaints.where((entry) => entry.reporterId == currentUser.id).length}',
                icon: Icons.error_outline_rounded,
                accent: AppColors.warning,
                onTap: onOpenComplaints,
              ),
              _MetricCard(
                title: 'Pending Bill',
                value: data.society.dueAmount > 0 ? '1' : '0',
                icon: Icons.receipt_long_outlined,
                accent: AppColors.danger,
                onTap: onOpenBills,
              ),
            ],
          ),
        ),
        const _SectionHeader('Recent Notices'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: notices
                .map(
                  (notice) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _NoticeTile(
                      notice: notice,
                      onTap: () => onOpenNotice(notice),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

