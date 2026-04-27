part of '../society_app.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({
    super.key,
    required this.data,
    required this.onBillTap,
  });

  final SocietyData data;
  final ValueChanged<Bill> onBillTap;

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  String _selectedFilter = 'All';

  List<Bill> get _filteredBills {
    switch (_selectedFilter) {
      case 'Pending':
        return widget.data.bills
            .where((entry) => entry.status == BillStatus.pending)
            .toList();
      case 'Paid':
        return widget.data.bills
            .where((entry) => entry.status == BillStatus.paid)
            .toList();
      case 'Overdue':
        return widget.data.bills
            .where((entry) => entry.status == BillStatus.overdue)
            .toList();
      default:
        return widget.data.bills;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShellHeader(title: 'Bills & Payments'),
        Container(
          width: double.infinity,
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Outstanding',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatAmount(widget.data.society.dueAmount),
                  style: const TextStyle(
                    color: Color(0xFFFFD54F),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: widget.data.society.collectionRate / 100,
                    minHeight: 7,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFD54F),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.2),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.data.society.collectionRate}% collected this month',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
        _FilterRow(
          labels: const ['All', 'Pending', 'Paid', 'Overdue'],
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
              final bill = _filteredBills[index];
              return _BillTile(
                bill: bill,
                onTap: () => widget.onBillTap(bill),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: _filteredBills.length,
          ),
        ),
      ],
    );
  }
}

