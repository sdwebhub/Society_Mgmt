import 'dart:convert';

import 'package:flutter/services.dart';

import 'models.dart';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class MockSocietyApi {
  static const String _assetPath = 'assets/mock/society_demo_data.json';

  SocietyData? _data;

  Future<SocietyData> load() async {
    if (_data != null) {
      return _data!;
    }

    final jsonString = await rootBundle.loadString(_assetPath);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _data = SocietyData.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
    return _data!;
  }

  SocietyData get data {
    final currentData = _data;
    if (currentData == null) {
      throw StateError(
        'MockSocietyApi.load() must complete before reading data.',
      );
    }
    return currentData;
  }

  // Future<AppUser> login({
  //   required UserRole role,
  //   required String identifier,
  //   required String password,
  // }) async {
  //   await _latency();

  //   final normalizedIdentifier = identifier.trim().toLowerCase();
  //   final user = _findUserByRole(role);

  //   final matchesEmail = user.email.toLowerCase() == normalizedIdentifier;
  //   final matchesPhone = _digitsOnly(user.phone) == _digitsOnly(identifier);
  //   if (!matchesEmail && !matchesPhone) {
  //     throw ApiException('No ${role.label.toLowerCase()} account matches that email or mobile number.');
  //   }
  //   if (user.password != password.trim()) {
  //     throw ApiException('Incorrect password. Use the demo credentials shown in the form.');
  //   }

  //   return user;
  // }

  Future<AppUser> login({
    required UserRole role,
    required String identifier,
    required String password,
  }) async {
    final url = Uri.parse(
      'http://localhost:5226/api/Auth/login',
    ); // ⚠️ not localhost

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": identifier, "password": password}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      if (result['success'] == true) {
        final data = result['data'];

        // 🔹 Map API → AppUser
        final user = AppUser(
          id: data['userId'].toString(),
          role: role,
          memberType: MemberType.owner, // ✅ FIX (choose default)
          name: data['firstName'],
          email: data['email'],
          phone: '',
          password: '',
          flat: '',
          wing: '',
          initials: data['firstName'][0].toUpperCase(),
          title: role.label,
        );

        // 👉 You should store token here
        final token = data['token'];
        print("TOKEN: $token");

        return user;
      } else {
        throw ApiException(result['message']);
      }
    } else {
      throw ApiException("Server error: ${response.statusCode}");
    }
  }

  Future<AppUser> registerSociety(RegisterSocietyRequest request) async {
    await _latency();

    final currentData = data;
    currentData.society
      ..name = request.societyName.trim()
      ..location = request.address.trim()
      ..address = request.address.trim()
      ..registrationNumber = request.registrationNumber.trim()
      ..totalUnits = request.totalUnits
      ..memberCount = request.totalUnits;

    final admin = currentData.adminUser;
    admin
      ..name = request.adminName.trim()
      ..email = request.adminEmail.trim()
      ..phone = request.adminPhone.trim()
      ..password = request.password
      ..initials = initialsFromName(request.adminName)
      ..title = 'Society Admin';

    return admin;
  }

  Future<Complaint> submitComplaint({
    required AppUser reporter,
    required CreateComplaintRequest request,
  }) async {
    await _latency();

    final complaint = Complaint(
      id: 'CMP-${DateTime.now().millisecondsSinceEpoch}',
      title: request.title.trim(),
      flatNumber: request.flatNumber.trim(),
      reporterId: reporter.id,
      reporterName: reporter.name,
      dateLabel: _formatDateLabel(DateTime.now()),
      relativeLabel: 'Just now',
      description: request.description.trim(),
      shortDescription: request.description.trim(),
      category: request.category.trim(),
      priority: request.priority,
      status: ComplaintStatus.open,
      assignedToName: reporter.role == UserRole.admin ? 'Maintenance Team' : '',
      assignedToRole: reporter.role == UserRole.admin ? 'Facility Desk' : '',
      activities: <ComplaintActivity>[
        ComplaintActivity(
          title: 'Complaint Filed',
          subtitle: '${_formatDateLabel(DateTime.now())} - by ${reporter.name}',
          accent: 'green',
        ),
      ],
    );

    data.complaints.insert(0, complaint);
    data.society.openIssuesCount += 1;
    return complaint;
  }

  Future<AppUser> addMember(AddMemberRequest request) async {
    await _latency();

    final wing = request.flatNumber.trim().split('-').first;
    final member = AppUser(
      id: 'member-${DateTime.now().millisecondsSinceEpoch}',
      role: UserRole.member,
      memberType: request.memberType,
      name: request.fullName.trim(),
      email: request.emailAddress.trim(),
      phone: request.mobileNumber.trim(),
      flat: request.flatNumber.trim(),
      wing: wing,
      password: 'InvitePending123',
      dateOfBirth: request.dateOfBirth.trim(),
      moveInDate: request.moveInDate.trim(),
      vehicleNumber: request.vehicleNumber.trim(),
      title: request.memberType.label,
    );

    data.users.add(member);
    data.society.memberCount += 1;
    return member;
  }

  Future<Bill> payBill(PaymentRequest request) async {
    await _latency();

    final bill = data.bills.firstWhere(
      (entry) => entry.id == request.billId,
      orElse: () => throw ApiException('Unable to find the selected bill.'),
    );

    if (bill.status == BillStatus.paid) {
      return bill;
    }

    bill
      ..status = BillStatus.paid
      ..paidDateLabel = 'Paid on ${_formatDateLabel(DateTime.now())}'
      ..summaryLabel = 'Payment received successfully'
      ..overdueLabel = '';

    final updatedDueAmount = data.society.dueAmount - bill.amount;
    data.society.dueAmount = updatedDueAmount < 0 ? 0 : updatedDueAmount;
    if (data.society.pendingBillsCount > 0) {
      data.society.pendingBillsCount -= 1;
    }

    return bill;
  }

  Future<void> updateSetting({required String key, required bool value}) async {
    await _latency();

    final settings = data.settings;
    switch (key) {
      case 'pushNotifications':
        settings.pushNotifications = value;
        break;
      case 'emailAlerts':
        settings.emailAlerts = value;
        break;
      case 'smsAlerts':
        settings.smsAlerts = value;
        break;
      case 'eventReminders':
        settings.eventReminders = value;
        break;
      case 'biometricLogin':
        settings.biometricLogin = value;
        break;
      case 'twoFactorAuth':
        settings.twoFactorAuth = value;
        break;
      case 'profileVisibility':
        settings.profileVisibility = value;
        break;
      case 'darkMode':
        settings.darkMode = value;
        break;
      default:
        throw ApiException('Unknown setting key: $key');
    }
  }

  Future<EventItem> confirmAttendance({
    required EventItem event,
    required AppUser attendee,
  }) async {
    await _latency();

    final alreadyJoined = event.attendees.any(
      (entry) => entry.name.toLowerCase() == attendee.name.toLowerCase(),
    );
    if (!alreadyJoined) {
      event.attendees.add(
        EventAttendee(
          name: attendee.name,
          initials: attendee.initials,
          accent: 'blue',
        ),
      );
    }
    return event;
  }

  AppUser _findUserByRole(UserRole role) {
    return data.users.firstWhere((user) => user.role == role);
  }

  Future<void> _latency() {
    return Future<void>.delayed(const Duration(milliseconds: 450));
  }

  String _digitsOnly(String input) => input.replaceAll(RegExp(r'[^0-9]'), '');

  String _formatDateLabel(DateTime date) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
