part of '../society_app.dart';

class BillDetailPage extends StatefulWidget {
  const BillDetailPage({
    super.key,
    required this.api,
    required this.bill,
    required this.currentUser,
  });

  final MockSocietyApi api;
  final Bill bill;
  final AppUser currentUser;

  @override
  State<BillDetailPage> createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  late Bill _bill = widget.bill;

  Future<void> _openPayment() async {
    if (_bill.status == BillStatus.paid) {
      showAppMessage(context, 'This bill is already paid.');
      return;
    }

    final updatedBill = await Navigator.of(context).push<Bill>(
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          api: widget.api,
          bill: _bill,
          currentUser: widget.currentUser,
        ),
      ),
    );

    if (!mounted || updatedBill == null) {
      return;
    }

    setState(() {
      _bill = updatedBill;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDetailAppBar(context, title: 'Bill Details'),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 34),
            child: Column(
              children: [
                Text(
                  'Amount Due',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatAmount(_bill.amount),
                  style: const TextStyle(
                    color: Color(0xFFFFD54F),
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                StatusBadge(
                  label: _bill.status.label,
                  background: badgeBackgroundForBillStatus(_bill.status),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  _bill.overdueLabel.isNotEmpty
                      ? _bill.overdueLabel
                      : _bill.summaryLabel,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _SurfaceCard(
                  child: _TitledBody(
                    title: 'Bill Breakdown',
                    child: Column(
                      children: _bill.lineItems
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: TextStyle(
                                        color: item.highlight
                                            ? AppColors.danger
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatAmount(item.amount),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: item.highlight
                                          ? AppColors.danger
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList()
                        ..add(
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Total',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  formatAmount(_bill.amount),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _SurfaceCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: _DetailMetric(
                          label: 'Bill Period',
                          value: _bill.period,
                        ),
                      ),
                      Expanded(
                        child: _DetailMetric(
                          label: 'Flat No.',
                          value: _bill.flatNumber,
                        ),
                      ),
                      Expanded(
                        child: _DetailMetric(
                          label: 'Bill Date',
                          value: _bill.billDateLabel,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: filledButtonStyle(),
                    onPressed: _bill.status == BillStatus.paid ? null : _openPayment,
                    child: Text(
                      _bill.status == BillStatus.paid
                          ? 'Already Paid'
                          : 'Proceed to Pay ${formatAmount(_bill.amount)}',
                    ),
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

