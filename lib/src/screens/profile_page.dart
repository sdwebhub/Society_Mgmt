part of '../society_app.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.data,
    required this.currentUser,
    required this.onOpenSettings,
    required this.onOpenEvents,
    required this.onOpenMembers,
    required this.onLogout,
  });

  final SocietyData data;
  final AppUser currentUser;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenEvents;
  final VoidCallback onOpenMembers;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final isAdmin = currentUser.role == UserRole.admin;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 42),
          decoration: const BoxDecoration(
            color: AppColors.primary,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  currentUser.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                currentUser.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${isAdmin ? 'Society Admin' : currentUser.memberType.label}  •  ${currentUser.flat}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.72),
                ),
              ),
              const SizedBox(height: 10),
              StatusBadge(
                label: data.society.name,
                textColor: Colors.white,
                background: Colors.white.withOpacity(0.16),
                borderColor: Colors.white.withOpacity(0.22),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                _SurfaceCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: _MiniMetric(
                          value: isAdmin
                              ? '${data.society.memberCount}'
                              : currentUser.flat,
                          label: isAdmin ? 'Members' : 'Flat',
                          accent: AppColors.primary,
                        ),
                      ),
                      Expanded(
                        child: _MiniMetric(
                          value: isAdmin
                              ? '${data.society.openIssuesCount}'
                              : '${data.complaints.where((c) => c.reporterId == currentUser.id).length}',
                          label: isAdmin ? 'Open Issues' : 'Complaints',
                          accent: AppColors.warning,
                        ),
                      ),
                      Expanded(
                        child: _MiniMetric(
                          value: isAdmin
                              ? '${data.society.collectionRate}%'
                              : formatAmount(data.society.dueAmount),
                          label: isAdmin ? 'Collection' : 'Due',
                          accent: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SurfaceCard(
                  child: Column(
                    children: [
                      _ProfileInfoRow(
                        label: 'Mobile',
                        value: currentUser.phone,
                      ),
                      _ProfileInfoRow(
                        label: 'Email',
                        value: currentUser.email,
                      ),
                      _ProfileInfoRow(
                        label: 'Flat',
                        value: '${currentUser.flat}, ${currentUser.wing} Wing',
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SurfaceCard(
                  child: Column(
                    children: [
                      _MenuTile(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: onOpenSettings,
                      ),
                      _MenuTile(
                        icon: Icons.event_outlined,
                        title: 'Events',
                        onTap: onOpenEvents,
                      ),
                      _MenuTile(
                        icon: Icons.groups_outlined,
                        title: 'Member Directory',
                        onTap: onOpenMembers,
                      ),
                      _MenuTile(
                        icon: Icons.logout_rounded,
                        title: 'Log Out',
                        iconColor: AppColors.danger,
                        textColor: AppColors.danger,
                        onTap: onLogout,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

