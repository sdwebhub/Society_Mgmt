part of '../society_app.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.api,
    required this.currentUser,
    required this.onLogout,
  });

  final MockSocietyApi api;
  final AppUser currentUser;
  final VoidCallback onLogout;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  SocietyData get data => widget.api.data;

  Future<void> _openCreateComplaint() async {
    final createdComplaint = await Navigator.of(context).push<Complaint>(
      MaterialPageRoute(
        builder: (_) => CreateComplaintPage(
          api: widget.api,
          currentUser: widget.currentUser,
        ),
      ),
    );

    if (!mounted || createdComplaint == null) {
      return;
    }

    setState(() {});
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ComplaintDetailPage(complaint: createdComplaint),
      ),
    );
  }

  Future<void> _openComplaintDetail(Complaint complaint) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ComplaintDetailPage(complaint: complaint),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openBillDetail(Bill bill) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BillDetailPage(
          api: widget.api,
          bill: bill,
          currentUser: widget.currentUser,
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openNoticeDetail(Notice notice) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoticeDetailPage(notice: notice),
      ),
    );
  }

  Future<void> _openEventList() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventListPage(
          api: widget.api,
          currentUser: widget.currentUser,
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openMemberDirectory() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MemberDirectoryPage(api: widget.api),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsPage(api: widget.api),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return widget.currentUser.role == UserRole.admin
            ? AdminDashboardPage(
                data: data,
                currentUser: widget.currentUser,
                onOpenProfile: () => setState(() => _selectedIndex = 4),
                onOpenComplaints: () => setState(() => _selectedIndex = 1),
                onOpenBills: () => setState(() => _selectedIndex = 2),
                onOpenNotices: () => setState(() => _selectedIndex = 3),
                onOpenMembers: () {
                  _openMemberDirectory();
                },
                onComplaintTap: (complaint) {
                  _openComplaintDetail(complaint);
                },
              )
            : MemberDashboardPage(
                data: data,
                currentUser: widget.currentUser,
                onOpenProfile: () => setState(() => _selectedIndex = 4),
                onOpenComplaints: () => setState(() => _selectedIndex = 1),
                onOpenBills: () => setState(() => _selectedIndex = 2),
                onOpenNotice: (notice) {
                  _openNoticeDetail(notice);
                },
              );
      case 1:
        return ComplaintsPage(
          complaints: data.complaints,
          onCreateComplaint: () {
            _openCreateComplaint();
          },
          onComplaintTap: (complaint) {
            _openComplaintDetail(complaint);
          },
        );
      case 2:
        return BillsPage(
          data: data,
          onBillTap: (bill) {
            _openBillDetail(bill);
          },
        );
      case 3:
        return NoticesPage(
          notices: effectiveNoticeList(data.notices),
          onNoticeTap: (notice) {
            _openNoticeDetail(notice);
          },
        );
      case 4:
        return ProfilePage(
          data: data,
          currentUser: widget.currentUser,
          onOpenSettings: () {
            _openSettings();
          },
          onOpenEvents: () {
            _openEventList();
          },
          onOpenMembers: () {
            _openMemberDirectory();
          },
          onLogout: widget.onLogout,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(bottom: false, child: _buildCurrentPage()),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: AppColors.primaryLight,
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (states) => TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: states.contains(MaterialState.selected)
                  ? AppColors.primary
                  : AppColors.textMuted,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.report_problem_outlined),
              selectedIcon: Icon(Icons.report_problem_rounded),
              label: 'Issues',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'Bills',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_none_rounded),
              selectedIcon: Icon(Icons.notifications_rounded),
              label: 'Notices',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

