part of '../society_app.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({
    super.key,
    required this.api,
    required this.currentUser,
  });

  final MockSocietyApi api;
  final AppUser currentUser;

  Future<void> _openEvent(BuildContext context, EventItem event) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventDetailPage(
          api: api,
          event: event,
          currentUser: currentUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDetailAppBar(context, title: 'Events'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final event = api.data.events[index];
          return _EventCard(
            event: event,
            onTap: () => _openEvent(context, event),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: api.data.events.length,
      ),
    );
  }
}

