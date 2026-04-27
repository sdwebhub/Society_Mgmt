part of '../society_app.dart';

class NoticeDetailPage extends StatelessWidget {
  const NoticeDetailPage({
    super.key,
    required this.notice,
  });

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDetailAppBar(context, title: 'Notice'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusBadge(
                      label: notice.category.label,
                      textColor: textColorForNoticeCategory(notice.category),
                      background: backgroundForNoticeCategory(notice.category),
                    ),
                    Text(
                      notice.dateLabel,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  notice.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    PersonAvatar(
                      initials: initialsFromName(notice.authorName),
                      accent: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Posted by ${notice.authorName} (${notice.authorRole})',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Text(
                  notice.content,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: outlinedButtonStyle(),
              onPressed: () {
                showAppMessage(
                  context,
                  'PDF download is mocked for now. We can hook this to a real file API later.',
                );
              },
              child: const Text('Download Notice PDF'),
            ),
          ),
        ],
      ),
    );
  }
}

