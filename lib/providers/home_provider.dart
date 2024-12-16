import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../screens/edit_user_details.dart';
import '../screens/login_screen.dart';
import '../utils/database_helper.dart';

class HomeProvider extends ChangeNotifier {
  // Dependencies
  final DatabaseHelper databaseHelper = DatabaseHelper();

  // State Variables
  List<User> _userList = [];
  bool _isGridView = true;
  int _count = 0;
  final TextEditingController searchController = TextEditingController();

  // Getters
  List<User> get userList => _userList;
  bool get isGridView => _isGridView;
  int get count => _count;

  // Constructor
  HomeProvider() {
    updateListView();
  }

  // Toggle View Mode
  void toggleViewMode() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  // Logout Functionality
  Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await prefs.clear();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  // Update User List from Database
  Future<void> updateListView() async {
    try {
      final users = await databaseHelper.getUserList();
      _userList = users;
      _count = users.length;
      notifyListeners();
    } catch (e) {
      print("Error updating user list: $e");
    }
  }

  // Search and Filter User List
  void filterUserList(String query) async {
    if (query.isNotEmpty) {
      final fullUserList = await databaseHelper.getUserList();
      _userList = fullUserList
          .where((user) => user.name!.toUpperCase().contains(query.toUpperCase()))
          .toList();
    } else {
      await updateListView();
    }
    _count = _userList.length;
    notifyListeners();
  }

  // Navigate to User Detail Screen
  Future<void> navigateToDetail(BuildContext context, User user, String title) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => UserDetailsEdit( appBarTitle: title, user: user,)),
    );
    if (result == true) {
      await updateListView();
    }
  }

  // Delete a User from the Database
  Future<void> deleteUser(BuildContext context, int userId) async {
    int result = await databaseHelper.deleteUser(userId);
    if (result != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Deleted Successfully'),
          backgroundColor: Colors.green,
        ),
      );
      await updateListView();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error Deleting User'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Show a Confirmation Dialog for Deletion
  void showDeleteConfirmationDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Delete...?"),
          content: Text("Are you sure? ${user.name} will be deleted."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await deleteUser(context, user.id!);
                Navigator.of(ctx).pop(); // Close the dialog
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
