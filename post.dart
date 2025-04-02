import 'user.dart';

enum MediaType { image, video }

class Post {
  final String id;
  final User user;
  final String mediaUrl;
  final MediaType mediaType;
  final String caption;
  final String location;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final int mediaCount;

  Post({
    required this.id,
    required this.user,
    required this.mediaUrl,
    required this.mediaType,
    required this.caption,
    this.location = '',
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.mediaCount = 1,
  });
}