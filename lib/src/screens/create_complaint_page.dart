part of '../society_app.dart';

class CreateComplaintPage extends StatefulWidget {
  const CreateComplaintPage({
    super.key,
    required this.api,
    required this.currentUser,
  });

  final MockSocietyApi api;
  final AppUser currentUser;

  @override
  State<CreateComplaintPage> createState() => _CreateComplaintPageState();
}

class _CreateComplaintPageState extends State<CreateComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(
    text: 'Water Leakage in Bathroom',
  );
  final _descriptionController = TextEditingController(
    text:
        'There is a water leak from the ceiling of the bathroom in my flat. It started yesterday and is getting worse.',
  );
  final _flatController = TextEditingController(text: 'B-204');

  String _category = 'Plumbing';
  ComplaintPriority _priority = ComplaintPriority.urgent;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _flatController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final complaint = await widget.api.submitComplaint(
        reporter: widget.currentUser,
        request: CreateComplaintRequest(
          title: _titleController.text.trim(),
          category: _category,
          priority: _priority,
          description: _descriptionController.text.trim(),
          flatNumber: _flatController.text.trim(),
        ),
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(complaint);
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
      appBar: buildDetailAppBar(context, title: 'New Complaint'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Complaint Title'),
                    TextFormField(
                      controller: _titleController,
                      validator: validateRequired,
                    ),
                    const SizedBox(height: 12),
                    const _FieldLabel('Category'),
                    DropdownButtonFormField<String>(
                      value: _category,
                      items: const [
                        DropdownMenuItem(value: 'Plumbing', child: Text('Plumbing')),
                        DropdownMenuItem(value: 'Electrical', child: Text('Electrical')),
                        DropdownMenuItem(value: 'Lift', child: Text('Lift / Elevator')),
                        DropdownMenuItem(value: 'Parking', child: Text('Parking')),
                        DropdownMenuItem(value: 'Housekeeping', child: Text('Housekeeping')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _category = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    const _FieldLabel('Priority Level'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ComplaintPriority.values
                          .where(
                            (priority) => priority != ComplaintPriority.low,
                          )
                          .map(
                            (priority) => ChoiceChip(
                              label: Text(priority.label),
                              selected: _priority == priority,
                              onSelected: (_) {
                                setState(() {
                                  _priority = priority;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    const _FieldLabel('Description'),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      validator: (value) => validateMinLength(
                        value,
                        minLength: 20,
                        label: 'Description',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _FieldLabel('Flat Number'),
                    TextFormField(
                      controller: _flatController,
                      validator: validateFlatValue,
                    ),
                    const SizedBox(height: 14),
                    const _FieldLabel('Attach Photo (optional)'),
                    InkWell(
                      onTap: () {
                        showAppMessage(
                          context,
                          'Photo upload is mocked for now. We can connect media APIs next.',
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.border,
                            style: BorderStyle.solid,
                          ),
                          color: AppColors.pageBackground,
                        ),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.add_a_photo_outlined,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap to upload photo',
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                          ],
                        ),
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
                      : const Text('Submit Complaint'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

