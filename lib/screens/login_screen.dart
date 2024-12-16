import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../customs/constants.dart';
import '../customs/text_custom.dart';
import '../providers/login_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.jpeg",
              fit: BoxFit.fill,
            ),
          ),
          // Form UI
          Positioned(
            top: 100,
            left: 10,
            right: 10,
            bottom: 10,
            child: Consumer<LoginProvider>(
              builder: (context, loginProvider, _) {
                return Form(
                  key: loginProvider.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/splash.png",
                            width: 50.w,
                            height: 50.h,
                          ),
                          sw10,
                          const Text(
                            "Log In",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      sh20,
                      // Name Input Field
                      TextFormField(
                        controller: loginProvider.nameController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Your Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Name";
                          }
                          return null;
                        },
                      ),
                      sh20,
                      // Password Input Field
                      TextFormField(
                        controller: loginProvider.passwordController,
                        obscureText: loginProvider.obscure,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: loginProvider.toggleObscure,
                            icon: Icon(
                              loginProvider.obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                          labelText: "Enter Your Password",
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Password";
                          }
                          return null;
                        },
                      ),
                      const Spacer(),
                      // Login Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (loginProvider.formKey.currentState!.validate()) {
                              loginProvider.checkLogin(context);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(black),
                            foregroundColor: MaterialStateProperty.all(white),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                vertical: 15.h,
                                horizontal: MediaQuery.of(context).size.width / 2.5.w,
                              ),
                            ),
                          ),
                          child: TextCustom(text: "Log In", color: white),
                        ),
                      ),
                      sh50,
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
