class User {
  final String id;
  final String username;
  final String fullName;
  final String profilePicture;
  final String bio;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final bool isVerified;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profilePicture,
    this.bio = '',
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.isVerified = false,
  });
}