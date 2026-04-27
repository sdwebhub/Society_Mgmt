part of '../society_app.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    required this.onBackToLogin,
    required this.onRegister,
  });

  final VoidCallback onBackToLogin;
  final Future<void> Function(RegisterSocietyRequest request) onRegister;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _societyNameController = TextEditingController(
    text: 'Green Pines Residency',
  );
  final _registrationController = TextEditingController(
    text: 'MH/2019/04521',
  );
  final _addressController = TextEditingController(
    text: 'Plot 12, Baner, Pune 411045',
  );
  final _unitsController = TextEditingController(text: '120');
  final _adminNameController = TextEditingController(text: 'Rajesh Sharma');
  final _adminEmailController = TextEditingController(
    text: 'admin@greenpines.com',
  );
  final _adminPhoneController = TextEditingController(
    text: '+91 98765 43210',
  );
  final _passwordController = TextEditingController(text: 'Admin@123');

  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _societyNameController.dispose();
    _registrationController.dispose();
    _addressController.dispose();
    _unitsController.dispose();
    _adminNameController.dispose();
    _adminEmailController.dispose();
    _adminPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final totalUnits = int.tryParse(_unitsController.text.trim());
    if (totalUnits == null || totalUnits <= 0) {
      showAppMessage(context, 'Enter a valid number of society units.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onRegister(
        RegisterSocietyRequest(
          societyName: _societyNameController.text.trim(),
          registrationNumber: _registrationController.text.trim(),
          address: _addressController.text.trim(),
          totalUnits: totalUnits,
          adminName: _adminNameController.text.trim(),
          adminEmail: _adminEmailController.text.trim(),
          adminPhone: _adminPhoneController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
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
      appBar: buildDetailAppBar(
        context,
        title: 'Register Society',
        onBack: widget.onBackToLogin,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _FormSection(
                title: 'Society Details',
                icon: Icons.apartment_rounded,
                children: [
                  const _FieldLabel('Society Name'),
                  TextFormField(
                    controller: _societyNameController,
                    validator: validateRequired,
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Registration Number'),
                  TextFormField(
                    controller: _registrationController,
                    validator: validateRequired,
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Address'),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    validator: (value) =>
                        validateMinLength(value, minLength: 10, label: 'Address'),
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Total Flats / Units'),
                  TextFormField(
                    controller: _unitsController,
                    keyboardType: TextInputType.number,
                    validator: validateUnitCount,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _FormSection(
                title: 'Admin Details',
                icon: Icons.person_outline_rounded,
                children: [
                  const _FieldLabel('Full Name'),
                  TextFormField(
                    controller: _adminNameController,
                    validator: validateRequired,
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Email Address'),
                  TextFormField(
                    controller: _adminEmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Mobile Number'),
                  TextFormField(
                    controller: _adminPhoneController,
                    keyboardType: TextInputType.phone,
                    validator: validatePhone,
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Create Password'),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: validatePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
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
                      : const Text('Register & Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

