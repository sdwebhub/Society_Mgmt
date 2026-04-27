part of '../society_app.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.api,
    required this.bill,
    required this.currentUser,
  });

  final MockSocietyApi api;
  final Bill bill;
  final AppUser currentUser;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController(text: '4532 1234 5678 9012');
  final _expiryController = TextEditingController(text: '08/27');
  final _cvvController = TextEditingController(text: '123');
  final _upiController = TextEditingController(text: 'priya.nair@upi');
  final _bankController = TextEditingController(text: 'HDFC Bank');

  PaymentMethod _method = PaymentMethod.card;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _upiController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  String? _validatePaymentField(String? _) {
    switch (_method) {
      case PaymentMethod.card:
        final cardDigits = _cardNumberController.text.replaceAll(' ', '');
        if (cardDigits.length != 16 || int.tryParse(cardDigits) == null) {
          return 'Enter a valid 16-digit card number.';
        }
        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(_expiryController.text.trim())) {
          return 'Use MM/YY format for expiry.';
        }
        if (!RegExp(r'^\d{3}$').hasMatch(_cvvController.text.trim())) {
          return 'CVV must be 3 digits.';
        }
        return null;
      case PaymentMethod.upi:
        if (!RegExp(r'^[\w.\-]{2,}@[A-Za-z]{2,}$').hasMatch(_upiController.text.trim())) {
          return 'Enter a valid UPI ID.';
        }
        return null;
      case PaymentMethod.netBanking:
        if (_bankController.text.trim().length < 3) {
          return 'Enter the bank name.';
        }
        return null;
    }
  }

  String get _paymentReference {
    switch (_method) {
      case PaymentMethod.card:
        return _cardNumberController.text.trim();
      case PaymentMethod.upi:
        return _upiController.text.trim();
      case PaymentMethod.netBanking:
        return _bankController.text.trim();
    }
  }

  Future<void> _submit() async {
    if (_validatePaymentField(null) != null) {
      _formKey.currentState!.validate();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final updatedBill = await widget.api.payBill(
        PaymentRequest(
          billId: widget.bill.id,
          method: _method,
          reference: _paymentReference,
        ),
      );
      if (!mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Successful'),
          content: Text(
            '${formatAmount(updatedBill.amount)} was paid successfully using ${_method.label}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(updatedBill);
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
      appBar: buildDetailAppBar(context, title: 'Pay Bill'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SurfaceCard(
                child: Column(
                  children: [
                    const Text(
                      'Total Payable',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatAmount(widget.bill.amount),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.bill.title}  •  Flat ${widget.bill.flatNumber}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _PaymentMethodTile(
                method: PaymentMethod.card,
                selected: _method == PaymentMethod.card,
                icon: Icons.credit_card_outlined,
                subtitle: 'Visa, Mastercard, RuPay',
                onTap: () => setState(() => _method = PaymentMethod.card),
              ),
              const SizedBox(height: 10),
              _PaymentMethodTile(
                method: PaymentMethod.upi,
                selected: _method == PaymentMethod.upi,
                icon: Icons.account_balance_wallet_outlined,
                subtitle: 'GPay, PhonePe, Paytm, BHIM',
                onTap: () => setState(() => _method = PaymentMethod.upi),
              ),
              const SizedBox(height: 10),
              _PaymentMethodTile(
                method: PaymentMethod.netBanking,
                selected: _method == PaymentMethod.netBanking,
                icon: Icons.account_balance_outlined,
                subtitle: 'All major banks supported',
                onTap: () => setState(() => _method = PaymentMethod.netBanking),
              ),
              const SizedBox(height: 10),
              _SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_method == PaymentMethod.card) ...[
                      const _FieldLabel('Card Number'),
                      TextFormField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        validator: _validatePaymentField,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FieldLabel('Expiry'),
                                TextFormField(
                                  controller: _expiryController,
                                  keyboardType: TextInputType.number,
                                  validator: _validatePaymentField,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FieldLabel('CVV'),
                                TextFormField(
                                  controller: _cvvController,
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  validator: _validatePaymentField,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ] else if (_method == PaymentMethod.upi) ...[
                      const _FieldLabel('UPI ID'),
                      TextFormField(
                        controller: _upiController,
                        validator: _validatePaymentField,
                      ),
                    ] else ...[
                      const _FieldLabel('Bank Name'),
                      TextFormField(
                        controller: _bankController,
                        validator: _validatePaymentField,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: filledButtonStyle(),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Pay ${formatAmount(widget.bill.amount)} Securely'),
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '256-bit SSL secured payment',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
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

