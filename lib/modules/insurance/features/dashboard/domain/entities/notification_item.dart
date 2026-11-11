import 'package:equatable/equatable.dart';

enum NotificationKind { transaction, security, promo, system }

class NotificationItem extends Equatable {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.kind,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final NotificationKind kind;
  final bool isRead;

  @override
  List<Object?> get props => [id, title, message, createdAt, kind, isRead];
}
