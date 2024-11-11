import 'package:chatter_planet_application/models/user_model.dart';
import 'package:chatter_planet_application/services/auth/auth_service.dart';
import 'package:chatter_planet_application/services/feeds/feed_service.dart';
import 'package:chatter_planet_application/services/users/user_service.dart';
import 'package:chatter_planet_application/widget/reusable/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel?> _userFuture;
  late Future<Map<String, int>> _userStatsFuture;
  bool _isLoading = true;
  bool _hasError = false;
  late String _currentUserId;
  late UserService _userService;
  late FeedService _feedService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userService = UserService();
    _feedService = FeedService();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _userFuture = _fetchUserDetails();
    _userStatsFuture = _fetchUserStats();
  }

  Future<UserModel?> _fetchUserDetails() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final user = await _userService.getUserById(userId);
      setState(() {
        _isLoading = false;
        if (user == null) {
          _hasError = true;
        }
      });
      return user;
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        _isLoading = true;
        _hasError = true;
      });
      return null;
    }
  }

  Future<Map<String, int>> _fetchUserStats() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final postsCount = await _feedService.getUserPostsCount(userId);
      final followersCount = await _userService.getUserFollowersCount(userId);
      final followingCount = await _userService.getUserFollowingCount(userId);

      return {
        'posts': postsCount,
        'followers': followersCount,
        'following': followingCount,
      };
    } catch (e) {
      print('Error fetching user stats: $e');
      return {'posts': 0, 'followers': 0, 'following': 0};
    }
  }

  void _signOut() async {
    await AuthServices().signOut();
    GoRouter.of(context).go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings
            },
          ),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_hasError) {
            return const Center(child: Text('Error loading profile'));
          }
          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundImage: user.imageUrl.isNotEmpty
                    ? NetworkImage(user.imageUrl)
                    : const AssetImage('assets/logo.png') as ImageProvider,
              ),
              const SizedBox(height: 16),
              // User Name
              Text(
                user.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // User Bio
              Text(
                user.jobTitle,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Stats (Posts, Followers, Following)
              FutureBuilder<Map<String, int>>(
                future: _userStatsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading stats'));
                  }
                  final stats = snapshot.data;

                  if (stats == null) {
                    return const Center(child: Text('Stats not available'));
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatColumn('Posts', stats['posts'].toString()),
                      _buildStatColumn(
                          'Followers', stats['followers'].toString()),
                      _buildStatColumn(
                          'Following', stats['following'].toString()),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),
              CustomButton(
                text: "Logout",
                width: MediaQuery.of(context).size.width,
                onPressed: _signOut,
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to build stats column
  Widget _buildStatColumn(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
