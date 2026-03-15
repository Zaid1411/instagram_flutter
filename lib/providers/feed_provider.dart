import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/story_model.dart';
import '../services/post_repository.dart';

class FeedProvider with ChangeNotifier {
  final PostRepository _repository = PostRepository();

  List<PostModel> _posts = [];
  List<StoryModel> _stories = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  int _currentPage = 0;

  List<PostModel> get posts => _posts;
  List<StoryModel> get stories => _stories;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;

  Future<void> refreshFeed() async {
    _currentPage = 0;
    _hasMore = true;
    await fetchInitialPosts();
  }

  Future<void> fetchInitialPosts() async {
    _isLoading = true;
    _stories = _repository.getStories();
    notifyListeners();

    try {
      _posts = await _repository.fetchPosts(0);
      _currentPage = 1;
      _hasMore = true;
    } catch (e) {
      // Handle network errors gracefully
      debugPrint('Error fetching posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMorePosts() async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      final List<PostModel> newPosts = await _repository.fetchPosts(_currentPage);
      _posts = [..._posts, ...newPosts];
      _currentPage++;
      // Cap at 5 pages (50 posts) for demo purposes
      if (_currentPage >= 5) _hasMore = false;
    } catch (e) {
      debugPrint('Error fetching more posts: $e');
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  void toggleLike(String postId) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;
    _posts[idx].isLiked = !_posts[idx].isLiked;
    notifyListeners();
  }

  void toggleSave(String postId) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;
    _posts[idx].isSaved = !_posts[idx].isSaved;
    notifyListeners();
  }
}