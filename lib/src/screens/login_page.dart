part of '../society_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.data,
    required this.onLogin,
    required this.onOpenRegister,
  });

  final SocietyData data;
  final Future<void> Function(
    UserRole role,
    String identifier,
    String password,
  ) onLogin;
  final VoidCallback onOpenRegister;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRole _selectedRole = UserRole.admin;
  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _applyDemoCredentials();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _applyDemoCredentials() {
    final demoUser = widget.data.demoUserForRole(_selectedRole);
    _identifierController.text = demoUser.email;
    _passwordController.text = demoUser.password;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onLogin(
        _selectedRole,
        _identifierController.text.trim(),
        _passwordController.text.trim(),
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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 72, 24, 42),
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to your account',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              transform: Matrix4.translationValues(0, -18, 0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Choose your role',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _RoleCard(
                              icon: Icons.admin_panel_settings_outlined,
                              title: 'Admin',
                              selected: _selectedRole == UserRole.admin,
                              onTap: () {
                                setState(() {
                                  _selectedRole = UserRole.admin;
                                  _applyDemoCredentials();
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _RoleCard(
                              icon: Icons.person_outline_rounded,
                              title: 'Member',
                              selected: _selectedRole == UserRole.member,
                              onTap: () {
                                setState(() {
                                  _selectedRole = UserRole.member;
                                  _applyDemoCredentials();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      const _FieldLabel('Email / Mobile Number'),
                      TextFormField(
                        controller: _identifierController,
                        keyboardType: TextInputType.emailAddress,
                        validator: validateIdentifier,
                      ),
                      const SizedBox(height: 12),
                      const _FieldLabel('Password'),
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
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            showAppMessage(
                              context,
                              'Password reset is mocked for now. We can connect a real API later.',
                            );
                          },
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                              : const Text('Sign In'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: widget.onOpenRegister,
                          child: const Text('New society? Register here'),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _DemoCredentialsCard(
                        adminUser: widget.data.adminUser,
                        memberUser: widget.data.memberUser,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

