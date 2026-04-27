import 'package:flutter/material.dart';

import 'mock_api_service.dart';
import 'models.dart';

part 'screens/splash_screen.dart';
part 'screens/auth_flow_page.dart';
part 'screens/login_page.dart';
part 'screens/register_page.dart';
part 'screens/home_shell.dart';
part 'screens/admin_dashboard_page.dart';
part 'screens/member_dashboard_page.dart';
part 'screens/complaints_page.dart';
part 'screens/bills_page.dart';
part 'screens/notices_page.dart';
part 'screens/profile_page.dart';
part 'screens/create_complaint_page.dart';
part 'screens/complaint_detail_page.dart';
part 'screens/bill_detail_page.dart';
part 'screens/payment_page.dart';
part 'screens/notice_detail_page.dart';
part 'screens/event_list_page.dart';
part 'screens/event_detail_page.dart';
part 'screens/member_directory_page.dart';
part 'screens/add_member_page.dart';
part 'screens/settings_page.dart';


class SocietyApp extends StatelessWidget {
  const SocietyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SocietyApp',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        scaffoldBackgroundColor: AppColors.pageBackground,
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.borderSoft),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.danger),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.danger),
          ),
        ),
      ),
      home: const _Bootstrapper(),
    );
  }
}

class _Bootstrapper extends StatefulWidget {
  const _Bootstrapper();

  @override
  State<_Bootstrapper> createState() => _BootstrapperState();
}

class _BootstrapperState extends State<_Bootstrapper> {
  final MockSocietyApi _api = MockSocietyApi();
  late final Future<SocietyData> _loadFuture = _api.load();

  bool _showSplash = true;
  AppUser? _currentUser;

  Future<void> _login(
    UserRole role,
    String identifier,
    String password,
  ) async {
    final user = await _api.login(
      role: role,
      identifier: identifier,
      password: password,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _register(RegisterSocietyRequest request) async {
    final user = await _api.registerSociety(request);
    if (!mounted) {
      return;
    }
    setState(() {
      _currentUser = user;
    });
  }

  void _logout() {
    setState(() {
      _currentUser = null;
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SocietyData>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _LoadingScreen();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.danger,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Unable to load the demo data.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final data = snapshot.data!;
        if (_showSplash) {
          return SplashScreen(
            version: data.society.version,
            onGetStarted: () {
              setState(() {
                _showSplash = false;
              });
            },
          );
        }

        if (_currentUser == null) {
          return AuthFlowPage(
            data: data,
            onLogin: _login,
            onRegister: _register,
          );
        }

        return HomeShell(
          api: _api,
          currentUser: _currentUser!,
          onLogout: _logout,
        );
      },
    );
  }
}

class ShellHeader extends StatelessWidget {
  const ShellHeader({
    super.key,
    required this.title,
    this.actionIcon,
    this.onAction,
  });

  final String title;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (actionIcon != null)
            IconButton(
              onPressed: onAction,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.16),
              ),
              icon: Icon(actionIcon, color: Colors.white),
            ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: labels
              .map(
                (label) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: selected == label,
                    onSelected: (_) => onSelected(label),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({
    required this.greeting,
    required this.title,
    required this.subtitle,
    required this.trailingText,
    required this.onAvatarTap,
    this.stats = const [],
    this.highlightCard,
  });

  final String greeting;
  final String title;
  final String subtitle;
  final String trailingText;
  final VoidCallback onAvatarTap;
  final List<_HeroMetric> stats;
  final Widget? highlightCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onAvatarTap,
                borderRadius: BorderRadius.circular(24),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    trailingText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            child: highlightCard ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: stats
                          .map(
                            (stat) => Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    stat.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    stat.label,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric {
  const _HeroMetric({required this.value, required this.label});

  final String value;
  final String label;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accent),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, {this.padded = true});

  final String title;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padded
          ? const EdgeInsets.fromLTRB(16, 16, 16, 10)
          : const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ComplaintRow extends StatelessWidget {
  const _ComplaintRow({
    required this.complaint,
    this.expanded = false,
    required this.onTap,
  });

  final Complaint complaint;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PersonAvatar(
              initials: initialsFromName(complaint.title),
              accent: badgeBackgroundForPriority(complaint.priority),
            ),
            const SizedBox(width: 10),
            Expanded(
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
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(
                        label: complaint.priority.label,
                        background:
                            badgeBackgroundForPriority(complaint.priority)
                                .withOpacity(0.14),
                        textColor: badgeBackgroundForPriority(complaint.priority),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    expanded
                        ? 'Reported by ${complaint.reporterName}  •  ${complaint.dateLabel}'
                        : 'Reported by ${complaint.reporterName}  •  ${complaint.relativeLabel}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  if (expanded && complaint.shortDescription.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      complaint.shortDescription,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  StatusBadge(
                    label: complaint.status.label,
                    background: backgroundForComplaintStatus(complaint.status),
                    textColor: textColorForComplaintStatus(complaint.status),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillTile extends StatelessWidget {
  const _BillTile({
    required this.bill,
    required this.onTap,
  });

  final Bill bill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = colorForBillStatus(bill.status);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.receipt_long_outlined, color: accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bill.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          formatAmount(bill.amount),
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bill.summaryLabel,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StatusBadge(
                      label: bill.status.label,
                      background: backgroundForBillStatus(bill.status),
                      textColor: textColorForBillStatus(bill.status),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoticeTile extends StatelessWidget {
  const _NoticeTile({
    required this.notice,
    required this.onTap,
  });

  final Notice notice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border(
            left: BorderSide(
              color: colorForNoticeCategory(notice.category),
              width: 4,
            ),
            top: const BorderSide(color: AppColors.borderSoft),
            right: const BorderSide(color: AppColors.borderSoft),
            bottom: const BorderSide(color: AppColors.borderSoft),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: notice.category.label,
                  background: backgroundForNoticeCategory(notice.category),
                  textColor: textColorForNoticeCategory(notice.category),
                ),
                const Spacer(),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    notice.dateLabel,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              notice.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              notice.summary,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.onTap,
  });

  final EventItem event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = accentForName(event.accent);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        iconForEvent(event.emoji),
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: StatusBadge(
                        label: event.status.label,
                        background: Colors.white.withOpacity(0.9),
                        textColor: accent,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${event.dateLabel}  •  ${event.timeLabel}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.venue,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.user,
  });

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final accent = accentForMemberType(user.memberType);
    return _SurfaceCard(
      child: Row(
        children: [
          PersonAvatar(
            initials: user.initials,
            accent: accent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${user.flat}  •  ${user.phone}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(
            label: user.memberType.label,
            background: accent.withOpacity(0.12),
            textColor: accent,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor = AppColors.textSecondary,
    this.textColor = AppColors.textPrimary,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color textColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: iconColor.withOpacity(0.8),
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.value,
    required this.label,
    required this.accent,
  });

  final String value;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
            color: selected ? AppColors.primaryLight : Colors.white,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoCredentialsCard extends StatelessWidget {
  const _DemoCredentialsCard({
    required this.adminUser,
    required this.memberUser,
  });

  final AppUser adminUser;
  final AppUser memberUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Demo accounts',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Admin: ${adminUser.email} / ${adminUser.password}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Member: ${memberUser.email} / ${memberUser.password}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _HeroInfoCard extends StatelessWidget {
  const _HeroInfoCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TitledBody extends StatelessWidget {
  const _TitledBody({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.activity,
    required this.isLast,
  });

  final ComplaintActivity activity;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final accent = accentForName(activity.accent);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 42,
                color: AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  activity.subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                if (activity.note.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.pageBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      activity.note,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.selected,
    required this.icon,
    required this.subtitle,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final IconData icon;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryLight : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: selected,
                onChanged: (_) => onTap(),
              ),
              Container(
                width: 42,
                height: 30,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(children: children),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

class _StaticSettingsTile extends StatelessWidget {
  const _StaticSettingsTile({
    required this.title,
    required this.subtitle,
    this.titleColor = AppColors.textPrimary,
    this.iconColor = AppColors.textMuted,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final Color titleColor;
  final Color iconColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: iconColor),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

class PersonAvatar extends StatelessWidget {
  const PersonAvatar({
    super.key,
    required this.initials,
    required this.accent,
    this.size = 38,
    this.fontSize = 12,
  });

  final String initials;
  final Color accent;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: accent,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.background,
    required this.textColor,
    this.borderColor,
  });

  final String label;
  final Color background;
  final Color textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

AppBar buildDetailAppBar(
  BuildContext context, {
  required String title,
  VoidCallback? onBack,
  List<Widget>? actions,
}) {
  return AppBar(
    leadingWidth: 92,
    leading: TextButton.icon(
      onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      icon: const Icon(Icons.chevron_left_rounded, color: Colors.white),
      label: const Text(
        'Back',
        style: TextStyle(color: Colors.white),
      ),
    ),
    title: Text(title),
    actions: actions,
  );
}

ButtonStyle filledButtonStyle() {
  return FilledButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  );
}

ButtonStyle outlinedButtonStyle() {
  return OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    side: const BorderSide(color: AppColors.primary),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  );
}

void showAppMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

List<Notice> effectiveNoticeList(List<Notice> notices) {
  if (notices.isNotEmpty) {
    return notices;
  }
  return _fallbackNotices;
}

final List<Notice> _fallbackNotices = <Notice>[
  Notice(
    id: 'fallback_agm',
    title: 'Annual General Meeting - May 5th, 2025',
    summary:
        'All residents are requested to attend the AGM at the Community Hall, Block A.',
    content:
        'Dear Residents,\n\nPlease attend the Annual General Meeting on Sunday, May 5th, 2025 at 10:00 AM in the Community Hall, Block A.\n\nRegards,\nSociety Management Committee',
    category: NoticeCategory.important,
    dateLabel: 'Apr 20, 2025',
    authorName: 'Rajesh Sharma',
    authorRole: 'Society Admin',
  ),
  Notice(
    id: 'fallback_water',
    title: 'Water Supply Interruption - Apr 22',
    summary:
        'Water supply will be shut from 10 AM to 2 PM. Please store adequate water.',
    content:
        'Scheduled maintenance of the overhead tank will temporarily interrupt the water supply between 10 AM and 2 PM on Apr 22.',
    category: NoticeCategory.maintenance,
    dateLabel: 'Apr 18, 2025',
    authorName: 'Rajesh Sharma',
    authorRole: 'Society Admin',
  ),
  Notice(
    id: 'fallback_holi',
    title: 'Holi Celebration - Rooftop Party',
    summary:
        'Join us for the Holi celebration on the rooftop terrace with music, snacks, and community games.',
    content:
        'Join the residents for our Holi celebration on the rooftop terrace. Colors, music, snacks, and family activities will be available for all age groups.',
    category: NoticeCategory.general,
    dateLabel: 'Apr 15, 2025',
    authorName: 'Cultural Committee',
    authorRole: 'Resident Group',
  ),
  Notice(
    id: 'fallback_visitor',
    title: 'New Visitor Entry Policy Effective May 1',
    summary:
        'All visitors must register at the security cabin. A QR-based entry workflow will be enabled.',
    content:
        'From May 1, all visitors must register at the security cabin before entering the premises. A QR-based visitor management system will be activated for faster approvals and improved security.',
    category: NoticeCategory.circular,
    dateLabel: 'Apr 10, 2025',
    authorName: 'Security Committee',
    authorRole: 'Facility Team',
  ),
];

String formatAmount(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final reversedIndex = digits.length - i;
    buffer.write(digits[i]);
    if (reversedIndex > 1 && reversedIndex % 3 == 1) {
      buffer.write(',');
    }
  }
  return 'Rs. ${buffer.toString()}';
}

String? validateRequired(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required.';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required.';
  }
  const emailPattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
  if (!RegExp(emailPattern).hasMatch(value.trim())) {
    return 'Enter a valid email address.';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Mobile number is required.';
  }
  final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length < 10) {
    return 'Enter a valid mobile number.';
  }
  return null;
}

String? validateIdentifier(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email or mobile number is required.';
  }
  final trimmed = value.trim();
  final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
  final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmed);
  if (!isEmail && digits.length < 10) {
    return 'Enter a valid email address or mobile number.';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Password is required.';
  }
  if (value.trim().length < 6) {
    return 'Password must be at least 6 characters.';
  }
  return null;
}

String? validateUnitCount(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Unit count is required.';
  }
  final parsed = int.tryParse(value.trim());
  if (parsed == null || parsed <= 0) {
    return 'Enter a valid unit count.';
  }
  return null;
}

String? validateMinLength(
  String? value, {
  required int minLength,
  required String label,
}) {
  if (value == null || value.trim().isEmpty) {
    return '$label is required.';
  }
  if (value.trim().length < minLength) {
    return '$label should be at least $minLength characters.';
  }
  return null;
}

String? validateFlatValue(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Flat number is required.';
  }
  if (!RegExp(r'^[A-Za-z0-9\- ]{3,}$').hasMatch(value.trim())) {
    return 'Enter a valid flat number.';
  }
  return null;
}

String? validateDateText(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This date is required.';
  }
  if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value.trim())) {
    return 'Use DD/MM/YYYY format.';
  }
  return null;
}

Color accentForName(String name) {
  switch (name.toLowerCase()) {
    case 'green':
      return AppColors.success;
    case 'orange':
      return AppColors.warning;
    case 'purple':
      return AppColors.purple;
    case 'red':
      return AppColors.danger;
    default:
      return AppColors.primary;
  }
}

Color accentForMemberType(MemberType type) {
  switch (type) {
    case MemberType.admin:
      return AppColors.primary;
    case MemberType.owner:
      return AppColors.success;
    case MemberType.tenant:
      return AppColors.warning;
    case MemberType.familyMember:
      return AppColors.purple;
  }
}

Color badgeBackgroundForPriority(ComplaintPriority priority) {
  switch (priority) {
    case ComplaintPriority.urgent:
      return AppColors.danger;
    case ComplaintPriority.high:
      return AppColors.warning;
    case ComplaintPriority.medium:
      return AppColors.textMuted;
    case ComplaintPriority.low:
      return AppColors.success;
  }
}

Color backgroundForComplaintStatus(ComplaintStatus status) {
  switch (status) {
    case ComplaintStatus.open:
      return AppColors.dangerLight;
    case ComplaintStatus.inProgress:
      return AppColors.warningLight;
    case ComplaintStatus.resolved:
      return AppColors.successLight;
  }
}

Color textColorForComplaintStatus(ComplaintStatus status) {
  switch (status) {
    case ComplaintStatus.open:
      return AppColors.danger;
    case ComplaintStatus.inProgress:
      return AppColors.warning;
    case ComplaintStatus.resolved:
      return AppColors.success;
  }
}

Color colorForBillStatus(BillStatus status) {
  switch (status) {
    case BillStatus.overdue:
      return AppColors.danger;
    case BillStatus.pending:
      return AppColors.warning;
    case BillStatus.paid:
      return AppColors.success;
  }
}

Color badgeBackgroundForBillStatus(BillStatus status) {
  switch (status) {
    case BillStatus.overdue:
      return AppColors.danger;
    case BillStatus.pending:
      return AppColors.warning;
    case BillStatus.paid:
      return AppColors.success;
  }
}

Color backgroundForBillStatus(BillStatus status) {
  switch (status) {
    case BillStatus.overdue:
      return AppColors.dangerLight;
    case BillStatus.pending:
      return AppColors.warningLight;
    case BillStatus.paid:
      return AppColors.successLight;
  }
}

Color textColorForBillStatus(BillStatus status) {
  switch (status) {
    case BillStatus.overdue:
      return AppColors.danger;
    case BillStatus.pending:
      return AppColors.warning;
    case BillStatus.paid:
      return AppColors.success;
  }
}

Color colorForNoticeCategory(NoticeCategory category) {
  switch (category) {
    case NoticeCategory.important:
      return AppColors.primary;
    case NoticeCategory.urgent:
      return AppColors.danger;
    case NoticeCategory.maintenance:
      return AppColors.warning;
    case NoticeCategory.general:
      return AppColors.success;
    case NoticeCategory.circular:
      return AppColors.purple;
  }
}

Color backgroundForNoticeCategory(NoticeCategory category) {
  switch (category) {
    case NoticeCategory.important:
      return AppColors.primaryLight;
    case NoticeCategory.urgent:
      return AppColors.dangerLight;
    case NoticeCategory.maintenance:
      return AppColors.warningLight;
    case NoticeCategory.general:
      return AppColors.successLight;
    case NoticeCategory.circular:
      return AppColors.purpleLight;
  }
}

Color textColorForNoticeCategory(NoticeCategory category) {
  switch (category) {
    case NoticeCategory.important:
      return AppColors.primaryDark;
    case NoticeCategory.urgent:
      return AppColors.danger;
    case NoticeCategory.maintenance:
      return AppColors.warning;
    case NoticeCategory.general:
      return AppColors.success;
    case NoticeCategory.circular:
      return AppColors.purple;
  }
}

Color backgroundForEventStatus(EventStatus status) {
  return status == EventStatus.upcoming
      ? AppColors.primaryLight
      : AppColors.pageBackground;
}

Color textColorForEventStatus(EventStatus status) {
  return status == EventStatus.upcoming
      ? AppColors.primaryDark
      : AppColors.textSecondary;
}

IconData iconForEvent(String emoji) {
  switch (emoji.toLowerCase()) {
    case 'eco':
      return Icons.eco_outlined;
    case 'sports':
      return Icons.sports_handball_outlined;
    default:
      return Icons.celebration_outlined;
  }
}

class AppColors {
  static const primary = Color(0xFF1976D2);
  static const primaryMid = Color(0xFF42A5F5);
  static const primaryDark = Color(0xFF0D47A1);
  static const primaryLight = Color(0xFFE3F2FD);
  static const pageBackground = Color(0xFFF5F8FC);
  static const textPrimary = Color(0xFF1A237E);
  static const textSecondary = Color(0xFF455A64);
  static const textMuted = Color(0xFF78909C);
  static const border = Color(0xFFCFD8DC);
  static const borderSoft = Color(0xFFE6ECF1);
  static const success = Color(0xFF43A047);
  static const successLight = Color(0xFFE8F5E9);
  static const warning = Color(0xFFFB8C00);
  static const warningLight = Color(0xFFFFF3E0);
  static const danger = Color(0xFFE53935);
  static const dangerLight = Color(0xFFFFEBEE);
  static const purple = Color(0xFF7B1FA2);
  static const purpleLight = Color(0xFFF3E5F5);
}

