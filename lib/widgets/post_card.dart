import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../providers/feed_provider.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  // Animations
  late AnimationController _heartController;
  late Animation<double> _heartScaleAnim;
  late Animation<double> _heartOpacityAnim;

  late AnimationController _likeButtonController;
  late Animation<double> _likeButtonScale;

  // Pinch-to-zoom state
  double _scale = 1.0;
  double _baseScale = 1.0;
  bool _isPinching = false;
  late AnimationController _zoomResetController;
  late Animation<double> _zoomResetAnim;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heartScaleAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 0.3),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 0.3),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 0.2),
    ]).animate(CurvedAnimation(parent: _heartController, curve: Curves.easeOut));

    _heartOpacityAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 0.375),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 0.25),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 0.375),
    ]).animate(CurvedAnimation(parent: _heartController, curve: Curves.linear));

    _likeButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeButtonScale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _likeButtonController, curve: Curves.easeOut),
    );

    _zoomResetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _zoomResetAnim = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _zoomResetController, curve: Curves.elasticOut),
    );
    _zoomResetController.addListener(() {
      if (mounted) setState(() => _scale = _zoomResetAnim.value);
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    _likeButtonController.dispose();
    _zoomResetController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _handleDoubleTap(BuildContext context) {
    final provider = Provider.of<FeedProvider>(context, listen: false);
    if (!widget.post.isLiked) {
      provider.toggleLike(widget.post.id);
      _likeButtonController.forward().then((_) => _likeButtonController.reverse());
    }
    _heartController.forward(from: 0);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = _scale;
    setState(() => _isPinching = true);
    HapticFeedback.lightImpact(); // Premium 2026 feel
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (!_isPinching) return;
    setState(() {
      _scale = (_baseScale * details.scale).clamp(1.0, 4.0);
    });
    // Trigger subtle vibration when hitting boundaries
    if (_scale == 4.0 || _scale == 1.0) {
      HapticFeedback.selectionClick();
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    setState(() => _isPinching = false);
    _zoomResetAnim = Tween<double>(begin: _scale, end: 1.0).animate(
      CurvedAnimation(parent: _zoomResetController, curve: Curves.easeOutBack),
    );
    _zoomResetController.forward(from: 0);
  }

  void _showFeatureSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        elevation: 0,
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  // Exact Mirror SVGs from User
  final String _likeIconSvg = '''
<svg aria-label="Like" fill="currentColor" height="24" role="img" viewBox="0 0 24 24" width="24"><title>Like</title><path d="M16.792 3.904A4.989 4.989 0 0 1 21.5 9.122c0 3.072-2.652 4.959-5.197 7.222-2.512 2.243-3.865 3.469-4.303 3.752-.477-.309-2.143-1.823-4.303-3.752C5.141 14.072 2.5 12.167 2.5 9.122a4.989 4.989 0 0 1 4.708-5.218 4.21 4.21 0 0 1 3.675 1.941c.84 1.175.98 1.763 1.12 1.763s.278-.588 1.11-1.766a4.17 4.17 0 0 1 3.679-1.938m0-2a6.04 6.04 0 0 0-4.797 2.127 6.052 6.052 0 0 0-4.787-2.127A6.985 6.985 0 0 0 .5 9.122c0 3.61 2.55 5.827 5.015 7.97.283.246.569.494.853.747l1.027.918a44.998 44.998 0 0 0 3.518 3.018 2 2 0 0 0 2.174 0 45.263 45.263 0 0 0 3.626-3.115l.922-.824c.293-.26.59-.519.885-.774 2.334-2.025 4.98-4.32 4.98-7.94a6.985 6.985 0 0 0-6.708-7.218Z"></path></svg>''';

  final String _likeIconFilledSvg = '''
<svg aria-label="Unlike" fill="#ed4956" height="24" role="img" viewBox="0 0 48 48" width="24"><title>Unlike</title><path d="M34.6 3.1c-4.5 0-7.9 1.8-10.6 5.6-2.7-3.7-6.1-5.5-10.6-5.5C6 3.1 0 9.6 0 17.6c0 7.3 5.4 12 10.6 16.5.6.5 1.3 1.1 1.9 1.7l2.3 2c4.4 3.9 6.6 5.9 7.6 6.5.5.3 1.1.5 1.6.5s1.1-.2 1.6-.5c1-.6 2.8-2.2 7.8-6.8l2-1.8c.7-.6 1.3-1.2 2-1.7C42.7 29.6 48 25 48 17.6c0-8-6-14.5-13.4-14.5z"></path></svg>''';

  final String _commentIconSvg = '''
<svg aria-label="Comment" fill="currentColor" height="24" role="img" viewBox="0 0 24 24" width="24"><title>Comment</title><path d="M20.656 17.008a9.993 9.993 0 1 0-3.59 3.615L22 22Z" fill="none" stroke="currentColor" stroke-linejoin="round" stroke-width="2"></path></svg>''';

  final String _shareIconSvg = '''
<svg aria-label="Share" fill="currentColor" height="24" role="img" viewBox="0 0 24 24" width="24"><title>Share</title><path d="M13.973 20.046 21.77 6.928C22.8 5.195 21.55 3 19.535 3H4.466C2.138 3 .984 5.825 2.646 7.456l4.842 4.752 1.723 7.121c.548 2.266 3.571 2.721 4.762.717Z" fill="none" stroke="currentColor" stroke-linejoin="round" stroke-width="2"></path><line fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" x1="7.488" x2="15.515" y1="12.208" y2="7.641"></line></svg>''';

  final String _saveIconSvg = '''
<svg aria-label="Save" fill="currentColor" height="24" role="img" viewBox="0 0 24 24" width="24"><title>Save</title><polygon fill="none" points="20 21 12 13.44 4 21 4 3 20 3 20 21" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"></polygon></svg>''';

  final String _saveIconFilledSvg = '''
<svg aria-label="Remove" fill="currentColor" height="24" role="img" viewBox="0 0 24 24" width="24"><title>Remove</title><polygon points="20 21 12 13.44 4 21 4 3 20 3 20 21"></polygon></svg>''';

  final String _repostIconSvg = '''
<svg aria-label="Repost" fill="none" height="24" role="img" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" viewBox="0 0 24 24" width="24"><title>Repost</title><path d="m17 2 4 4-4 4"></path><path d="M3 11v-1a4 4 0 0 1 4-4h14"></path><path d="m7 22-4-4 4-4"></path><path d="M21 13v1a4 4 0 0 1-4 4H3"></path></svg>''';

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (context, provider, _) {
        final post = widget.post;
        return RepaintBoundary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, post),
              _buildMediaSection(context, post),
              _buildCarouselDots(post),
              _buildActionBar(context, post, provider),
              _buildSocialProof(context, post),
              _buildCaption(context, post),
              // Precise 8px spacing between posts for 2026 aesthetic
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, PostModel post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12), // Refined 2026 spacing
      child: Row(
        children: [
          // Profile Pic with Ring
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEFEFEF), width: 1),
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEFEFEF),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: post.profileImageUrl,
                  fit: BoxFit.cover,
                  width: 32,
                  height: 32,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF262626),
                          letterSpacing: -0.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (post.isVerified) ...[
                      const SizedBox(width: 4),
                      SvgPicture.string(
                        '''<svg aria-label="Verified" fill="rgb(0, 149, 246)" height="12" role="img" viewBox="0 0 40 40" width="12"><title>Verified</title><path d="M19.998 3.094 14.638 0l-2.972 5.15H5.432v6.354L0 14.64l3.094 5.36L0 25.359l5.432 3.137v6.354h6.234l2.972 5.15 5.36-3.094 5.36 3.094 2.972-5.15h6.234v-6.354L40 25.359l-3.094-5.36L40 14.64l-5.432-3.137V5.15h-6.234l-2.972-5.15-5.364 3.094Zm-4.63 15.53 3.664 3.549 8.32-8.194 2.26 2.222-10.58 10.416-5.917-5.733 2.253-2.26Z" fill-rule="evenodd"></path></svg>''',
                        width: 12,
                        height: 12,
                      ),
                    ],
                    if (!post.isFollowing) ...[
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 14)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Follow',
                          style: TextStyle(
                            color: Color(0xFF0095F6),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (post.audioStatus.isNotEmpty)
                  Text(
                    post.audioStatus,
                    style: const TextStyle(
                      color: Color(0xFF8E8E8E),
                      fontSize: 12,
                      letterSpacing: -0.1,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(CupertinoIcons.ellipsis, size: 20, color: Color(0xFF262626)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection(BuildContext context, PostModel post) {
    final hasMultiple = post.images.length > 1;

    return Column(
      children: [
        GestureDetector(
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onScaleEnd: _onScaleEnd,
          child: GestureDetector(
            onDoubleTap: () => _handleDoubleTap(context),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none, // Allow zoomed image to overlap everything
              children: [
                // Dark Backdrop when pinching
                if (_isPinching)
                  Positioned.fill(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: (_scale - 1.0).clamp(0.0, 0.7),
                      child: Container(color: Colors.black),
                    ),
                  ),
                Transform.scale(
                  scale: _scale,
                  child: AspectRatio(
                    aspectRatio: 4 / 5, // Immersive 2026 Ratio
                    child: hasMultiple
                        ? PageView.builder(
                            controller: _pageController,
                            itemCount: post.images.length,
                            onPageChanged: (idx) => setState(() => _currentImageIndex = idx),
                            itemBuilder: (ctx, i) => _buildImage(post.images[i]),
                          )
                        : _buildImage(post.images[0]),
                  ),
                ),
                // Double-tap heart
                AnimatedBuilder(
                  animation: _heartController,
                  builder: (_, __) {
                    return Opacity(
                      opacity: _heartOpacityAnim.value,
                      child: Transform.scale(
                        scale: _heartScaleAnim.value,
                        child: const Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.white,
                          size: 100,
                          shadows: [Shadow(color: Colors.black26, blurRadius: 30)],
                        ),
                      ),
                    );
                  },
                ),
                // Carousel Count - Top Right Glassmorphic
                if (hasMultiple)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          color: Colors.black.withOpacity(0.4),
                          child: Text(
                            '${_currentImageIndex + 1}/${post.images.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (ctx, url) => Container(color: const Color(0xFFEFEFEF)),
      errorWidget: (ctx, url, err) => const Center(child: Icon(CupertinoIcons.photo_fill, color: Colors.grey)),
    );
  }

  Widget _buildActionBar(BuildContext context, PostModel post, FeedProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          // Like
          GestureDetector(
            onTap: () => provider.toggleLike(post.id),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _likeButtonScale,
                  child: SvgPicture.string(
                    post.isLiked ? _likeIconFilledSvg : _likeIconSvg,
                    colorFilter: ColorFilter.mode(
                      post.isLiked ? const Color(0xFFED4956) : const Color(0xFF262626),
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  post.likeCount >= 10000 
                      ? '${(post.likeCount / 1000).toStringAsFixed(1)}K' 
                      : (post.likeCount >= 1000 ? '${(post.likeCount / 1000).toStringAsFixed(1)}K' : '${post.likeCount}'),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF262626), letterSpacing: -0.1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Comment
          GestureDetector(
            onTap: () => _showFeatureSnackbar(context, 'Comments'),
            child: Row(
              children: [
                SvgPicture.string(_commentIconSvg, width: 22, height: 22, colorFilter: const ColorFilter.mode(Color(0xFF262626), BlendMode.srcIn)),
                const SizedBox(width: 5),
                Text(
                  '${post.commentCount}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF262626), letterSpacing: -0.1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Repost (Loop)
          GestureDetector(
            onTap: () => _showFeatureSnackbar(context, 'Repost'),
            child: Row(
              children: [
                SvgPicture.string(_repostIconSvg, width: 22, height: 22, colorFilter: const ColorFilter.mode(Color(0xFF262626), BlendMode.srcIn)),
                const SizedBox(width: 5),
                const Text(
                  '24',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF262626), letterSpacing: -0.1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Share
          GestureDetector(
            onTap: () => _showFeatureSnackbar(context, 'Share'),
            child: Row(
              children: [
                SvgPicture.string(_shareIconSvg, width: 22, height: 22, colorFilter: const ColorFilter.mode(Color(0xFF262626), BlendMode.srcIn)),
                const SizedBox(width: 4),
                const Text(
                  '6',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF262626), letterSpacing: -0.1),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => provider.toggleSave(post.id),
            child: SvgPicture.string(
              post.isSaved ? _saveIconFilledSvg : _saveIconSvg,
              colorFilter: const ColorFilter.mode(Color(0xFF262626), BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselDots(PostModel post) {
    if (post.images.length <= 1) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          post.images.length,
          (index) => Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentImageIndex == index ? const Color(0xFF0095F6) : const Color(0xFFDBDBDB),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialProof(BuildContext context, PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Color(0xFF262626), fontSize: 14, letterSpacing: -0.1),
          children: [
            const TextSpan(text: 'Liked by '),
            TextSpan(text: '${post.username} ', style: const TextStyle(fontWeight: FontWeight.w600)),
            const TextSpan(text: 'and '),
            const TextSpan(text: 'others', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }


  Widget _buildCaption(BuildContext context, PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Color(0xFF262626), fontSize: 14, height: 1.35, letterSpacing: -0.1),
              children: [
                TextSpan(text: '${post.username} ', style: const TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: post.caption),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showFeatureSnackbar(context, 'Comments'),
            child: Text(
              'View all ${post.commentCount} comments',
              style: const TextStyle(color: Color(0xFF8E8E8E), fontSize: 14, letterSpacing: -0.1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            post.timeAgo.toUpperCase(),
            style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 10, letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }
}