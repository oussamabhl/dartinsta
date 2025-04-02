import 'user.dart';

class Story {
  final String id;
  final User user;
  final String mediaUrl;
  final DateTime createdAt;
  final bool isViewed;

  Story({
    required this.id,
    required this.user,
    required this.mediaUrl,
    required this.createdAt,
    this.isViewed = false,
  });
}