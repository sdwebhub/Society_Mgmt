part of '../society_app.dart';

class NoticesPage extends StatefulWidget {
  const NoticesPage({
    super.key,
    required this.notices,
    required this.onNoticeTap,
  });

  final List<Notice> notices;
  final ValueChanged<Notice> onNoticeTap;

  @override
  State<NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  String _selectedFilter = 'All';

  List<Notice> get _sourceNotices => effectiveNoticeList(widget.notices);

  List<Notice> get _filteredNotices {
    switch (_selectedFilter) {
      case 'Important':
        return _sourceNotices
            .where((entry) => entry.category == NoticeCategory.important)
            .toList();
      case 'Maintenance':
        return _sourceNotices
            .where((entry) => entry.category == NoticeCategory.maintenance)
            .toList();
      case 'General':
        return _sourceNotices
            .where((entry) => entry.category == NoticeCategory.general)
            .toList();
      case 'Circular':
        return _sourceNotices
            .where((entry) => entry.category == NoticeCategory.circular)
            .toList();
      default:
        return _sourceNotices;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotices = _filteredNotices;

    return Column(
      children: [
        const ShellHeader(title: 'Notices'),
        _FilterRow(
          labels: const ['All', 'Important', 'Maintenance', 'General', 'Circular'],
          selected: _selectedFilter,
          onSelected: (value) {
            setState(() {
              _selectedFilter = value;
            });
          },
        ),
        Expanded(
          child: filteredNotices.isEmpty
              ? const _NoticeEmptyState()
              : ListView.separated(
                  key: ValueKey<String>(_selectedFilter),
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
                  itemBuilder: (context, index) {
                    final notice = filteredNotices[index];
                    return _NoticeTile(
                      notice: notice,
                      onTap: () => widget.onNoticeTap(notice),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemCount: filteredNotices.length,
                ),
        ),
      ],
    );
  }
}

class _NoticeEmptyState extends StatelessWidget {
  const _NoticeEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _SurfaceCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.notifications_off_outlined,
                size: 40,
                color: AppColors.textMuted,
              ),
              SizedBox(height: 12),
              Text(
                'No notices available for this filter.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Try a different filter or add more notice records to the mock data.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

