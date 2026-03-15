import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/story_model.dart';

class StoryItem extends StatelessWidget {
  final StoryModel story;
  const StoryItem({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            story.isMe ? _buildMyStory() : _buildStory(),
            const SizedBox(height: 6),
            SizedBox(
              width: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      story.isMe ? 'Your story' : story.username,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: story.isMe ? FontWeight.w400 : FontWeight.w500,
                        color: const Color(0xFF262626),
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (story.isVerified) ...[
                    const SizedBox(width: 2),
                    SvgPicture.string(
                      '''<svg aria-label="Verified" fill="rgb(0, 149, 246)" height="10" role="img" viewBox="0 0 40 40" width="10"><title>Verified</title><path d="M19.998 3.094 14.638 0l-2.972 5.15H5.432v6.354L0 14.64l3.094 5.36L0 25.359l5.432 3.137v6.354h6.234l2.972 5.15 5.36-3.094 5.36 3.094 2.972-5.15h6.234v-6.354L40 25.359l-3.094-5.36L40 14.64l-5.432-3.137V5.15h-6.234l-2.972-5.15-5.364 3.094Zm-4.63 15.53 3.664 3.549 8.32-8.194 2.26 2.222-10.58 10.416-5.917-5.733 2.253-2.26Z" fill-rule="evenodd"></path></svg>''',
                      width: 10,
                      height: 10,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStory() {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFFFCAF45),
            Color(0xFFF77737),
            Color(0xFFE1306C),
            Color(0xFFC13584),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CircleAvatar(
          radius: 32,
          backgroundColor: const Color(0xFFEFEFEF),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: story.avatarUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorWidget: (ctx, url, err) => const Icon(
                Icons.person,
                size: 32,
                color: Color(0xFFB0B0B0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyStory() {
    return Stack(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEFEFEF),
          ),
          child: const Icon(Icons.person, size: 40, color: Color(0xFFB0B0B0)),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}
