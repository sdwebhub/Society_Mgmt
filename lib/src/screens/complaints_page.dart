part of '../society_app.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({
    super.key,
    required this.complaints,
    required this.onCreateComplaint,
    required this.onComplaintTap,
  });

  final List<Complaint> complaints;
  final VoidCallback onCreateComplaint;
  final ValueChanged<Complaint> onComplaintTap;

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  String _selectedFilter = 'All';

  List<Complaint> get _filteredComplaints {
    switch (_selectedFilter) {
      case 'Open':
        return widget.complaints
            .where((entry) => entry.status == ComplaintStatus.open)
            .toList();
      case 'In Progress':
        return widget.complaints
            .where((entry) => entry.status == ComplaintStatus.inProgress)
            .toList();
      case 'Resolved':
        return widget.complaints
            .where((entry) => entry.status == ComplaintStatus.resolved)
            .toList();
      case 'Urgent':
        return widget.complaints
            .where((entry) => entry.priority == ComplaintPriority.urgent)
            .toList();
      default:
        return widget.complaints;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShellHeader(
          title: 'Complaints',
          actionIcon: Icons.add_rounded,
          onAction: widget.onCreateComplaint,
        ),
        _FilterRow(
          labels: [
            'All',
            'Open',
            'In Progress',
            'Resolved',
            'Urgent',
          ],
          selected: _selectedFilter,
          onSelected: (value) {
            setState(() {
              _selectedFilter = value;
            });
          },
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
            itemBuilder: (context, index) {
              final complaint = _filteredComplaints[index];
              return _SurfaceCard(
                child: _ComplaintRow(
                  complaint: complaint,
                  expanded: true,
                  onTap: () => widget.onComplaintTap(complaint),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: _filteredComplaints.length,
          ),
        ),
      ],
    );
  }
}

