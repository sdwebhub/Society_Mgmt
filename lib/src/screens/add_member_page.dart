part of '../society_app.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({
    super.key,
    required this.api,
  });

  final MockSocietyApi api;

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _flatController = TextEditingController();
  final _moveInController = TextEditingController();
  final _vehicleController = TextEditingController();

  MemberType _memberType = MemberType.owner;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _flatController.dispose();
    _moveInController.dispose();
    _vehicleController.dispose();
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
      final member = await widget.api.addMember(
        AddMemberRequest(
          fullName: _nameController.text.trim(),
          mobileNumber: _mobileController.text.trim(),
          emailAddress: _emailController.text.trim(),
          dateOfBirth: _dobController.text.trim(),
          flatNumber: _flatController.text.trim(),
          memberType: _memberType,
          moveInDate: _moveInController.text.trim(),
          vehicleNumber: _vehicleController.text.trim(),
        ),
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(member);
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
      appBar: buildDetailAppBar(context, title: 'Add Member'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _FormSection(
                title: 'Personal Info',
                icon: Icons.person_outline_rounded,
                children: [
                  const _FieldLabel('Full Name'),
                  TextFormField(
                    controller: _nameController,
                    validator: validateRequired,
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Mobile Number'),
                  TextFormField(
                    controller: _mobileController,
                    validator: validatePhone,
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Email Address'),
                  TextFormField(
                    controller: _emailController,
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Date of Birth'),
                  TextFormField(
                    controller: _dobController,
                    validator: validateDateText,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _FormSection(
                title: 'Flat Details',
                icon: Icons.home_work_outlined,
                children: [
                  const _FieldLabel('Flat Number'),
                  TextFormField(
                    controller: _flatController,
                    validator: validateFlatValue,
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Member Type'),
                  DropdownButtonFormField<MemberType>(
                    value: _memberType,
                    items: MemberType.values
                        .where((type) => type != MemberType.admin)
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _memberType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Move-in Date'),
                  TextFormField(
                    controller: _moveInController,
                    validator: validateDateText,
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Vehicle Number (optional)'),
                  TextFormField(controller: _vehicleController),
                ],
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
                      : const Text('Add Member'),
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
                      'SMS invite is mocked for now. We can connect SMS delivery later.',
                    );
                  },
                  child: const Text('Send Invite via SMS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

