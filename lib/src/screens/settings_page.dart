part of '../society_app.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.api,
  });

  final MockSocietyApi api;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _busy = false;

  Future<void> _toggle(String key, bool value) async {
    setState(() {
      _busy = true;
    });

    try {
      await widget.api.updateSetting(key: key, value: value);
      if (mounted) {
        setState(() {});
      }
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      showAppMessage(context, error.message);
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.api.data.settings;
    return Scaffold(
      appBar: buildDetailAppBar(context, title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader('Notifications', padded: false),
          _SettingsCard(
            children: [
              _SettingsSwitchTile(
                title: 'Push Notifications',
                subtitle: 'Complaints, bills, notices',
                value: settings.pushNotifications,
                onChanged: (value) => _toggle('pushNotifications', value),
              ),
              _SettingsSwitchTile(
                title: 'Email Alerts',
                subtitle: 'Important notices and dues',
                value: settings.emailAlerts,
                onChanged: (value) => _toggle('emailAlerts', value),
              ),
              _SettingsSwitchTile(
                title: 'SMS Alerts',
                subtitle: 'Payment reminders',
                value: settings.smsAlerts,
                onChanged: (value) => _toggle('smsAlerts', value),
              ),
              _SettingsSwitchTile(
                title: 'Event Reminders',
                subtitle: '1 day before events',
                value: settings.eventReminders,
                onChanged: (value) => _toggle('eventReminders', value),
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _SectionHeader('Privacy & Security', padded: false),
          _SettingsCard(
            children: [
              _SettingsSwitchTile(
                title: 'Biometric Login',
                subtitle: 'Fingerprint or Face ID',
                value: settings.biometricLogin,
                onChanged: (value) => _toggle('biometricLogin', value),
              ),
              _SettingsSwitchTile(
                title: 'Two-Factor Auth',
                subtitle: 'OTP via SMS',
                value: settings.twoFactorAuth,
                onChanged: (value) => _toggle('twoFactorAuth', value),
              ),
              _SettingsSwitchTile(
                title: 'Profile Visibility',
                subtitle: 'Visible to society members',
                value: settings.profileVisibility,
                onChanged: (value) => _toggle('profileVisibility', value),
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _SectionHeader('App', padded: false),
          _SettingsCard(
            children: [
              _StaticSettingsTile(
                title: 'Language',
                subtitle: settings.language,
              ),
              _SettingsSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Follow system default',
                value: settings.darkMode,
                onChanged: (value) => _toggle('darkMode', value),
              ),
              _StaticSettingsTile(
                title: 'App Version',
                subtitle:
                    '${widget.api.data.society.version} (Build ${widget.api.data.society.buildNumber})',
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              _StaticSettingsTile(
                title: 'Delete Account',
                subtitle: 'Contact support before continuing',
                titleColor: AppColors.danger,
                iconColor: AppColors.danger,
                isLast: true,
              ),
            ],
          ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

