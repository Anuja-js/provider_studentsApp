import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../customs/constants.dart';
import '../screens/home_screen.dart';
class LoginProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscures = true;
  bool get obscure => obscures;

  void toggleObscure() {
    obscures = !obscures;
    notifyListeners();
  }
  Future<void> checkLogin(BuildContext context) async {
    final username = nameController.text.trim();
    final password = passwordController.text.trim();

    if (username == "Anuja" && password == "anu123") {
      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setBool('userLoggedIn', true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful"),
          backgroundColor: green,
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Failed: Username or password is incorrect"),
          backgroundColor: red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
