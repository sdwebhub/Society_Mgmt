part of '../society_app.dart';

class AuthFlowPage extends StatefulWidget {
  const AuthFlowPage({
    super.key,
    required this.data,
    required this.onLogin,
    required this.onRegister,
  });

  final SocietyData data;
  final Future<void> Function(
    UserRole role,
    String identifier,
    String password,
  ) onLogin;
  final Future<void> Function(RegisterSocietyRequest request) onRegister;

  @override
  State<AuthFlowPage> createState() => _AuthFlowPageState();
}

class _AuthFlowPageState extends State<AuthFlowPage> {
  bool _showRegister = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: _showRegister
          ? RegisterPage(
              key: const ValueKey('register'),
              onBackToLogin: () {
                setState(() {
                  _showRegister = false;
                });
              },
              onRegister: widget.onRegister,
            )
          : LoginPage(
              key: const ValueKey('login'),
              data: widget.data,
              onLogin: widget.onLogin,
              onOpenRegister: () {
                setState(() {
                  _showRegister = true;
                });
              },
            ),
    );
  }
}

