import 'package:chatter_planet_application/models/user_model.dart';
import 'package:chatter_planet_application/services/users/user_service.dart';
import 'package:chatter_planet_application/utilz/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];

  Future<void> _fetchUsers() async {
    try {
      final users = await UserService().getAllUsers(); //get all users
      setState(() {
        _users = users; //store all the users in array
        _filteredUsers = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _users
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToUserProfile(UserModel user) {
    GoRouter.of(context).push('/profile-screen', extra: user);
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(8),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                filled: true,
                border: inputBorder,
                focusedBorder: inputBorder,
                enabledBorder: inputBorder,
                prefixIcon: const Icon(
                  Icons.search,
                  color: mainWhiteColor,
                  size: 20,
                ),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.imageUrl.isNotEmpty
                        ? NetworkImage(user.imageUrl)
                        : const AssetImage('assets/logo.png') as ImageProvider,
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.jobTitle),
                  onTap: () => _navigateToUserProfile(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
