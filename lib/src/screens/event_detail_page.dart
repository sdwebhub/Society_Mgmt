part of '../society_app.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({
    super.key,
    required this.api,
    required this.event,
    required this.currentUser,
  });

  final MockSocietyApi api;
  final EventItem event;
  final AppUser currentUser;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  late EventItem _event = widget.event;
  bool _isSubmitting = false;

  Future<void> _confirmAttendance() async {
    if (_event.status == EventStatus.completed) {
      showAppMessage(context, 'This event has already been completed.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final event = await widget.api.confirmAttendance(
        event: _event,
        attendee: widget.currentUser,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _event = event;
      });
      showAppMessage(context, 'Attendance confirmed for ${_event.title}.');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      showAppMessage(context, error.message);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDetailAppBar(context, title: 'Event Details'),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 150,
            color: accentForName(_event.accent),
            child: Center(
              child: Icon(
                iconForEvent(_event.emoji),
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _event.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Green Pines Residency',
                                  style: TextStyle(color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          StatusBadge(
                            label: _event.status.label,
                            background: backgroundForEventStatus(_event.status),
                            textColor: textColorForEventStatus(_event.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _DetailMetric(
                              label: 'Date',
                              value: _event.dateLabel,
                            ),
                          ),
                          Expanded(
                            child: _DetailMetric(
                              label: 'Time',
                              value: _event.timeLabel,
                            ),
                          ),
                          Expanded(
                            child: _DetailMetric(
                              label: 'Venue',
                              value: _event.venue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SurfaceCard(
                  child: _TitledBody(
                    title: 'About this Event',
                    child: Text(
                      _event.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _SurfaceCard(
                  child: _TitledBody(
                    title: 'Attendees (${_event.attendees.length} confirmed)',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _event.attendees
                          .map(
                            (attendee) => Container(
                              padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
                              decoration: BoxDecoration(
                                color: AppColors.pageBackground,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PersonAvatar(
                                    initials: attendee.initials,
                                    accent: accentForName(attendee.accent),
                                    size: 24,
                                    fontSize: 10,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    attendee.name,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: filledButtonStyle(),
                    onPressed: _isSubmitting ? null : _confirmAttendance,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Confirm Attendance'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: outlinedButtonStyle(),
                    onPressed: () {
                      showAppMessage(
                        context,
                        'Calendar integration is mocked for now.',
                      );
                    },
                    child: const Text('Add to Calendar'),
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

