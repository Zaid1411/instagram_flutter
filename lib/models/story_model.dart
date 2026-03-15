class StoryModel {
  final String id;
  final String username;
  final String avatarUrl;
  final bool isMe;
  final bool hasStory;
  final bool isVerified;

  const StoryModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    this.isMe = false,
    this.hasStory = true,
    this.isVerified = false,
  });
}
