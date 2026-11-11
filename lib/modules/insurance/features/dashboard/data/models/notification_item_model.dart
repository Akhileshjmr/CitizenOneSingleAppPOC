import '../../domain/entities/notification_item.dart';

class NotificationItemModel extends NotificationItem {
  NotificationItemModel({
    required super.id,
    required super.title,
    required super.message,
    required super.createdAt,
    required String kind,
    super.isRead,
  }) : super(kind: _kindFromString(kind));

  static NotificationKind _kindFromString(String s) =>
      NotificationKind.values.firstWhere(
        (k) => k.name == s,
        orElse: () => NotificationKind.system,
      );

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) =>
      NotificationItemModel(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        kind: json['kind'] as String,
        isRead: json['isRead'] as bool? ?? false,
      );
}
