enum UserRole {
  admin,
  member,
}

UserRole userRoleFromString(String value) {
  switch (value.toLowerCase()) {
    case 'admin':
      return UserRole.admin;
    case 'member':
      return UserRole.member;
    default:
      throw ArgumentError('Unknown user role: $value');
  }
}

extension UserRoleX on UserRole {
  String get label => this == UserRole.admin ? 'Admin' : 'Member';
}

enum MemberType {
  admin,
  owner,
  tenant,
  familyMember,
}

MemberType memberTypeFromString(String value) {
  switch (value.toLowerCase()) {
    case 'admin':
      return MemberType.admin;
    case 'owner':
      return MemberType.owner;
    case 'tenant':
      return MemberType.tenant;
    case 'familymember':
    case 'family_member':
    case 'family member':
      return MemberType.familyMember;
    default:
      throw ArgumentError('Unknown member type: $value');
  }
}

extension MemberTypeX on MemberType {
  String get label {
    switch (this) {
      case MemberType.admin:
        return 'Admin';
      case MemberType.owner:
        return 'Owner';
      case MemberType.tenant:
        return 'Tenant';
      case MemberType.familyMember:
        return 'Family Member';
    }
  }
}

enum ComplaintPriority {
  urgent,
  high,
  medium,
  low,
}

ComplaintPriority complaintPriorityFromString(String value) {
  switch (value.toLowerCase()) {
    case 'urgent':
      return ComplaintPriority.urgent;
    case 'high':
      return ComplaintPriority.high;
    case 'medium':
      return ComplaintPriority.medium;
    case 'low':
      return ComplaintPriority.low;
    default:
      throw ArgumentError('Unknown complaint priority: $value');
  }
}

extension ComplaintPriorityX on ComplaintPriority {
  String get label {
    switch (this) {
      case ComplaintPriority.urgent:
        return 'Urgent';
      case ComplaintPriority.high:
        return 'High';
      case ComplaintPriority.medium:
        return 'Medium';
      case ComplaintPriority.low:
        return 'Low';
    }
  }
}

enum ComplaintStatus {
  open,
  inProgress,
  resolved,
}

ComplaintStatus complaintStatusFromString(String value) {
  switch (value.toLowerCase()) {
    case 'open':
      return ComplaintStatus.open;
    case 'inprogress':
    case 'in_progress':
    case 'in progress':
      return ComplaintStatus.inProgress;
    case 'resolved':
      return ComplaintStatus.resolved;
    default:
      throw ArgumentError('Unknown complaint status: $value');
  }
}

extension ComplaintStatusX on ComplaintStatus {
  String get label {
    switch (this) {
      case ComplaintStatus.open:
        return 'Open';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
    }
  }
}

enum BillStatus {
  overdue,
  pending,
  paid,
}

BillStatus billStatusFromString(String value) {
  switch (value.toLowerCase()) {
    case 'overdue':
      return BillStatus.overdue;
    case 'pending':
      return BillStatus.pending;
    case 'paid':
      return BillStatus.paid;
    default:
      throw ArgumentError('Unknown bill status: $value');
  }
}

extension BillStatusX on BillStatus {
  String get label {
    switch (this) {
      case BillStatus.overdue:
        return 'Overdue';
      case BillStatus.pending:
        return 'Pending';
      case BillStatus.paid:
        return 'Paid';
    }
  }
}

enum NoticeCategory {
  important,
  urgent,
  maintenance,
  general,
  circular,
}

NoticeCategory noticeCategoryFromString(String value) {
  switch (value.toLowerCase()) {
    case 'important':
      return NoticeCategory.important;
    case 'urgent':
      return NoticeCategory.urgent;
    case 'maintenance':
      return NoticeCategory.maintenance;
    case 'general':
      return NoticeCategory.general;
    case 'circular':
      return NoticeCategory.circular;
    default:
      throw ArgumentError('Unknown notice category: $value');
  }
}

extension NoticeCategoryX on NoticeCategory {
  String get label {
    switch (this) {
      case NoticeCategory.important:
        return 'Important';
      case NoticeCategory.urgent:
        return 'Urgent';
      case NoticeCategory.maintenance:
        return 'Maintenance';
      case NoticeCategory.general:
        return 'General';
      case NoticeCategory.circular:
        return 'Circular';
    }
  }
}

enum EventStatus {
  upcoming,
  completed,
}

EventStatus eventStatusFromString(String value) {
  switch (value.toLowerCase()) {
    case 'upcoming':
      return EventStatus.upcoming;
    case 'completed':
      return EventStatus.completed;
    default:
      throw ArgumentError('Unknown event status: $value');
  }
}

extension EventStatusX on EventStatus {
  String get label => this == EventStatus.upcoming ? 'Upcoming' : 'Completed';
}

enum PaymentMethod {
  card,
  upi,
  netBanking,
}

PaymentMethod paymentMethodFromString(String value) {
  switch (value.toLowerCase()) {
    case 'card':
      return PaymentMethod.card;
    case 'upi':
      return PaymentMethod.upi;
    case 'netbanking':
    case 'net_banking':
    case 'net banking':
      return PaymentMethod.netBanking;
    default:
      throw ArgumentError('Unknown payment method: $value');
  }
}

extension PaymentMethodX on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.card:
        return 'Credit / Debit Card';
      case PaymentMethod.upi:
        return 'UPI Payment';
      case PaymentMethod.netBanking:
        return 'Net Banking';
    }
  }
}

String initialsFromName(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) {
    return 'NA';
  }
  if (parts.length == 1) {
    final single = parts.first;
    return single.substring(0, single.length >= 2 ? 2 : 1).toUpperCase();
  }
  return (parts.first[0] + parts.last[0]).toUpperCase();
}

class SocietyInfo {
  SocietyInfo({
    required this.name,
    required this.location,
    required this.address,
    required this.registrationNumber,
    required this.totalUnits,
    required this.occupiedUnits,
    required this.vacantUnits,
    required this.pendingBillsCount,
    required this.openIssuesCount,
    required this.memberCount,
    required this.activeNoticesCount,
    required this.monthlyCollectionLabel,
    required this.collectionRate,
    required this.dueAmount,
    required this.version,
    required this.buildNumber,
  });

  factory SocietyInfo.fromJson(Map<String, dynamic> json) {
    return SocietyInfo(
      name: json['name'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      registrationNumber: json['registrationNumber'] as String,
      totalUnits: json['totalUnits'] as int,
      occupiedUnits: json['occupiedUnits'] as int,
      vacantUnits: json['vacantUnits'] as int,
      pendingBillsCount: json['pendingBillsCount'] as int,
      openIssuesCount: json['openIssuesCount'] as int,
      memberCount: json['memberCount'] as int,
      activeNoticesCount: json['activeNoticesCount'] as int,
      monthlyCollectionLabel: json['monthlyCollectionLabel'] as String,
      collectionRate: json['collectionRate'] as int,
      dueAmount: json['dueAmount'] as int,
      version: json['version'] as String,
      buildNumber: json['buildNumber'] as int,
    );
  }

  String name;
  String location;
  String address;
  String registrationNumber;
  int totalUnits;
  int occupiedUnits;
  int vacantUnits;
  int pendingBillsCount;
  int openIssuesCount;
  int memberCount;
  int activeNoticesCount;
  String monthlyCollectionLabel;
  int collectionRate;
  int dueAmount;
  String version;
  int buildNumber;
}

class AppUser {
  AppUser({
    required this.id,
    required this.role,
    required this.memberType,
    required this.name,
    required this.email,
    required this.phone,
    required this.flat,
    required this.wing,
    required this.password,
    this.dateOfBirth = '',
    this.moveInDate = '',
    this.vehicleNumber = '',
    this.title = '',
    String? initials,
  }) : initials = initials ?? initialsFromName(name);

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      role: userRoleFromString(json['role'] as String),
      memberType: memberTypeFromString(json['memberType'] as String),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      flat: json['flat'] as String,
      wing: json['wing'] as String,
      password: json['password'] as String,
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      moveInDate: json['moveInDate'] as String? ?? '',
      vehicleNumber: json['vehicleNumber'] as String? ?? '',
      title: json['title'] as String? ?? '',
      initials: json['initials'] as String?,
    );
  }

  final String id;
  UserRole role;
  MemberType memberType;
  String name;
  String email;
  String phone;
  String flat;
  String wing;
  String password;
  String dateOfBirth;
  String moveInDate;
  String vehicleNumber;
  String title;
  String initials;
}

class ComplaintActivity {
  ComplaintActivity({
    required this.title,
    required this.subtitle,
    this.note = '',
    this.accent = 'blue',
  });

  factory ComplaintActivity.fromJson(Map<String, dynamic> json) {
    return ComplaintActivity(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      note: json['note'] as String? ?? '',
      accent: json['accent'] as String? ?? 'blue',
    );
  }

  String title;
  String subtitle;
  String note;
  String accent;
}

class Complaint {
  Complaint({
    required this.id,
    required this.title,
    required this.flatNumber,
    required this.reporterId,
    required this.reporterName,
    required this.dateLabel,
    required this.relativeLabel,
    required this.description,
    required this.shortDescription,
    required this.category,
    required this.priority,
    required this.status,
    this.assignedToName = '',
    this.assignedToRole = '',
    List<ComplaintActivity>? activities,
  }) : activities = activities ?? <ComplaintActivity>[];

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'] as String,
      title: json['title'] as String,
      flatNumber: json['flatNumber'] as String,
      reporterId: json['reporterId'] as String,
      reporterName: json['reporterName'] as String,
      dateLabel: json['dateLabel'] as String,
      relativeLabel: json['relativeLabel'] as String? ?? '',
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String? ?? '',
      category: json['category'] as String,
      priority: complaintPriorityFromString(json['priority'] as String),
      status: complaintStatusFromString(json['status'] as String),
      assignedToName: json['assignedToName'] as String? ?? '',
      assignedToRole: json['assignedToRole'] as String? ?? '',
      activities: (json['activities'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => ComplaintActivity.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  String id;
  String title;
  String flatNumber;
  String reporterId;
  String reporterName;
  String dateLabel;
  String relativeLabel;
  String description;
  String shortDescription;
  String category;
  ComplaintPriority priority;
  ComplaintStatus status;
  String assignedToName;
  String assignedToRole;
  List<ComplaintActivity> activities;
}

class BillLineItem {
  BillLineItem({
    required this.label,
    required this.amount,
    this.highlight = false,
  });

  factory BillLineItem.fromJson(Map<String, dynamic> json) {
    return BillLineItem(
      label: json['label'] as String,
      amount: json['amount'] as int,
      highlight: json['highlight'] as bool? ?? false,
    );
  }

  String label;
  int amount;
  bool highlight;
}

class Bill {
  Bill({
    required this.id,
    required this.title,
    required this.period,
    required this.flatNumber,
    required this.amount,
    required this.dueDateLabel,
    required this.billDateLabel,
    required this.status,
    required this.summaryLabel,
    this.paidDateLabel = '',
    this.overdueLabel = '',
    List<BillLineItem>? lineItems,
  }) : lineItems = lineItems ?? <BillLineItem>[];

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] as String,
      title: json['title'] as String,
      period: json['period'] as String,
      flatNumber: json['flatNumber'] as String,
      amount: json['amount'] as int,
      dueDateLabel: json['dueDateLabel'] as String,
      billDateLabel: json['billDateLabel'] as String,
      status: billStatusFromString(json['status'] as String),
      summaryLabel: json['summaryLabel'] as String,
      paidDateLabel: json['paidDateLabel'] as String? ?? '',
      overdueLabel: json['overdueLabel'] as String? ?? '',
      lineItems: (json['lineItems'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => BillLineItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  String id;
  String title;
  String period;
  String flatNumber;
  int amount;
  String dueDateLabel;
  String billDateLabel;
  BillStatus status;
  String summaryLabel;
  String paidDateLabel;
  String overdueLabel;
  List<BillLineItem> lineItems;
}

class Notice {
  Notice({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.dateLabel,
    required this.authorName,
    required this.authorRole,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      category: noticeCategoryFromString(json['category'] as String),
      dateLabel: json['dateLabel'] as String,
      authorName: json['authorName'] as String,
      authorRole: json['authorRole'] as String,
    );
  }

  String id;
  String title;
  String summary;
  String content;
  NoticeCategory category;
  String dateLabel;
  String authorName;
  String authorRole;
}

class EventAttendee {
  EventAttendee({
    required this.name,
    required this.initials,
    this.accent = 'blue',
  });

  factory EventAttendee.fromJson(Map<String, dynamic> json) {
    return EventAttendee(
      name: json['name'] as String,
      initials: json['initials'] as String,
      accent: json['accent'] as String? ?? 'blue',
    );
  }

  String name;
  String initials;
  String accent;
}

class EventItem {
  EventItem({
    required this.id,
    required this.title,
    required this.venue,
    required this.dateLabel,
    required this.timeLabel,
    required this.description,
    required this.status,
    required this.emoji,
    required this.accent,
    List<EventAttendee>? attendees,
  }) : attendees = attendees ?? <EventAttendee>[];

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['id'] as String,
      title: json['title'] as String,
      venue: json['venue'] as String,
      dateLabel: json['dateLabel'] as String,
      timeLabel: json['timeLabel'] as String,
      description: json['description'] as String,
      status: eventStatusFromString(json['status'] as String),
      emoji: json['emoji'] as String,
      accent: json['accent'] as String? ?? 'blue',
      attendees: (json['attendees'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => EventAttendee.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  String id;
  String title;
  String venue;
  String dateLabel;
  String timeLabel;
  String description;
  EventStatus status;
  String emoji;
  String accent;
  List<EventAttendee> attendees;
}

class AppSettingsModel {
  AppSettingsModel({
    required this.pushNotifications,
    required this.emailAlerts,
    required this.smsAlerts,
    required this.eventReminders,
    required this.biometricLogin,
    required this.twoFactorAuth,
    required this.profileVisibility,
    required this.darkMode,
    required this.language,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      pushNotifications: json['pushNotifications'] as bool,
      emailAlerts: json['emailAlerts'] as bool,
      smsAlerts: json['smsAlerts'] as bool,
      eventReminders: json['eventReminders'] as bool,
      biometricLogin: json['biometricLogin'] as bool,
      twoFactorAuth: json['twoFactorAuth'] as bool,
      profileVisibility: json['profileVisibility'] as bool,
      darkMode: json['darkMode'] as bool,
      language: json['language'] as String,
    );
  }

  bool pushNotifications;
  bool emailAlerts;
  bool smsAlerts;
  bool eventReminders;
  bool biometricLogin;
  bool twoFactorAuth;
  bool profileVisibility;
  bool darkMode;
  String language;
}

class SocietyData {
  SocietyData({
    required this.society,
    required this.adminUserId,
    required this.memberUserId,
    required this.users,
    required this.complaints,
    required this.bills,
    required this.notices,
    required this.events,
    required this.settings,
  });

  factory SocietyData.fromJson(Map<String, dynamic> json) {
    return SocietyData(
      society: SocietyInfo.fromJson(json['society'] as Map<String, dynamic>),
      adminUserId: json['adminUserId'] as String,
      memberUserId: json['memberUserId'] as String,
      users: (json['users'] as List<dynamic>)
          .map((item) => AppUser.fromJson(item as Map<String, dynamic>))
          .toList(),
      complaints: (json['complaints'] as List<dynamic>)
          .map((item) => Complaint.fromJson(item as Map<String, dynamic>))
          .toList(),
      bills: (json['bills'] as List<dynamic>)
          .map((item) => Bill.fromJson(item as Map<String, dynamic>))
          .toList(),
      notices: (json['notices'] as List<dynamic>)
          .map((item) => Notice.fromJson(item as Map<String, dynamic>))
          .toList(),
      events: (json['events'] as List<dynamic>)
          .map((item) => EventItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      settings: AppSettingsModel.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
    );
  }

  SocietyInfo society;
  String adminUserId;
  String memberUserId;
  List<AppUser> users;
  List<Complaint> complaints;
  List<Bill> bills;
  List<Notice> notices;
  List<EventItem> events;
  AppSettingsModel settings;

  AppUser get adminUser => users.firstWhere((user) => user.id == adminUserId);

  AppUser get memberUser => users.firstWhere((user) => user.id == memberUserId);

  AppUser demoUserForRole(UserRole role) {
    return role == UserRole.admin ? adminUser : memberUser;
  }
}

class RegisterSocietyRequest {
  RegisterSocietyRequest({
    required this.societyName,
    required this.registrationNumber,
    required this.address,
    required this.totalUnits,
    required this.adminName,
    required this.adminEmail,
    required this.adminPhone,
    required this.password,
  });

  final String societyName;
  final String registrationNumber;
  final String address;
  final int totalUnits;
  final String adminName;
  final String adminEmail;
  final String adminPhone;
  final String password;
}

class CreateComplaintRequest {
  CreateComplaintRequest({
    required this.title,
    required this.category,
    required this.priority,
    required this.description,
    required this.flatNumber,
  });

  final String title;
  final String category;
  final ComplaintPriority priority;
  final String description;
  final String flatNumber;
}

class AddMemberRequest {
  AddMemberRequest({
    required this.fullName,
    required this.mobileNumber,
    required this.emailAddress,
    required this.dateOfBirth,
    required this.flatNumber,
    required this.memberType,
    required this.moveInDate,
    required this.vehicleNumber,
  });

  final String fullName;
  final String mobileNumber;
  final String emailAddress;
  final String dateOfBirth;
  final String flatNumber;
  final MemberType memberType;
  final String moveInDate;
  final String vehicleNumber;
}

class PaymentRequest {
  PaymentRequest({
    required this.billId,
    required this.method,
    required this.reference,
  });

  final String billId;
  final PaymentMethod method;
  final String reference;
}
