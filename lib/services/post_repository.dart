import '../models/post_model.dart';
import '../models/story_model.dart';

class PostRepository {
  // Exact Mirror Usernames from Reference Image
  final List<String> _usernames = [
    'sprinkles_bby19',
    'super_santi_73',
    'lil_wyatt838',
    'liam_beanz99',
    'urban_explorer',
    'ai_artist',
    'ethereal_design',
    'pixel_perfection',
    'velvet_light',
    'chrono_tech'
  ];

  final Set<String> _verifiedUsernames = {
    'sprinkles_bby19',
    'super_santi_73',
    'pixel_perfection',
  };

  final List<String> _captions = [
    'Exploring the intersection of glassmorphism and light. #NeoMinimalism 2026',
    'The future is fluid. 🌊 Captured on the edge of the metaverse.',
    'Urban geometries in the heart of Neo-Tokyo. ✨',
    'Symphony of shadows and 3D depth. Minimalism isn\'t about less, it\'s about better.',
    'Ethereal textures meeting tactile interfaces. The 2026 aesthetic is here.',
    'Golden hour in the digital garden. 🌿✨ #AIGenerated',
    'Chasing the glow of urban neon. 🌌 #NightLife',
    'Precision meets fluidity. Reimagining the daily flow.',
    'Studio light studies. Texture, depth, and glass.',
    'Where the digital meets the organic. #BioTechDesign'
  ];

  Future<List<PostModel>> fetchPosts(int page) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 1500));

    if (page > 5) return [];

    return List.generate(10, (index) {
      final globalIndex = (page - 1) * 10 + index;
      final username = _usernames[globalIndex % _usernames.length];
      final caption = _captions[globalIndex % _captions.length];
      
      final isCarousel = globalIndex % 3 == 0;
      final imageCount = isCarousel ? 3 : 1;
      
      final List<String> images = List.generate(imageCount, (i) {
        final seed = globalIndex * 10 + i;
        return 'https://picsum.photos/seed/$seed/1080/1350';
      });

      final likeCount = globalIndex % 4 == 0 ? 26600 : 1234;
      final isRemix = globalIndex % 2 == 0;
      
      return PostModel(
        id: 'post_$globalIndex',
        username: username,
        profileImageUrl: 'https://i.pravatar.cc/150?u=$username',
        images: images,
        caption: caption,
        likeCount: likeCount, // Simulated match to '26.6K' or '1.2K'
        commentCount: 57,  // Match reference
        timeAgo: '${globalIndex + 1}h',
        isLiked: false,
        isSaved: false,
        isFollowing: globalIndex % 3 == 0,
        isVerified: _verifiedUsernames.contains(username),
        audioStatus: globalIndex % 2 == 0 ? 'Audio unavailable' : 'Original audio',
      );
    });
  }

  List<StoryModel> getStories() {
    return [
      StoryModel(
        id: 'me',
        username: 'Your story',
        avatarUrl: 'https://i.pravatar.cc/150?u=me',
        isMe: true,
      ),
      StoryModel(
        id: 'story_1',
        username: 'super_santi_73',
        avatarUrl: 'https://i.pravatar.cc/150?u=super_santi_73',
        hasStory: true,
        isVerified: true,
      ),
      StoryModel(
        id: 'story_2',
        username: 'lil_wyatt838',
        avatarUrl: 'https://i.pravatar.cc/150?u=lil_wyatt838',
        hasStory: true,
        isVerified: false,
      ),
      StoryModel(
        id: 'story_3',
        username: 'liam_beanz99',
        avatarUrl: 'https://i.pravatar.cc/150?u=liam_beanz99',
        hasStory: true,
        isVerified: false,
      ),
      ...List.generate(6, (index) {
        final username = _usernames[(index + 4) % _usernames.length];
        return StoryModel(
          id: 'story_gen_$index',
          username: username,
          avatarUrl: 'https://i.pravatar.cc/150?u=$username',
          hasStory: true,
          isVerified: _verifiedUsernames.contains(username),
        );
      }),
    ];
  }
}