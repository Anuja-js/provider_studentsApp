import 'dart:io';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:providerregisterapp/customs/constants.dart';
import 'package:providerregisterapp/customs/text_custom.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/user.dart';
import '../providers/home_provider.dart';
import 'edit_user_details.dart';

class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: TextCustom(
          text: user.name ?? "User Details",
          color: white,
          textSize: 17.sp,
        ),
        backgroundColor: black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2.55.w,
            top: 20.h,
            child: CircleAvatar(
              backgroundColor: black,
              radius: 50.r,
              child: user.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: Image.file(
                        File(user.imagePath!),
                        fit: BoxFit.cover,
                        width: 100.w,
                        height: 100.h,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      color: white,
                    ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 5.h,
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildInfoRow("Name", user.name),
                buildInfoRow("Qualification", user.qualification),
                buildInfoRow("Age", user.age?.toString()),
                buildInfoRow("Phone", user.phone.toString()),
                buildInfoRow("Description", user.description),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 4.5,
            left: 25,
            right: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserDetailsEdit(
                            user: user, appBarTitle: "Edit User"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: black,
                    foregroundColor: white,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 40.w),
                    child: TextCustom(
                      text: 'Edit',
                      color: white,
                    ),
                  ),
                ),
                sw5,
                ElevatedButton(
                  onPressed: () {
                    homeProvider.showDeleteConfirmationDialog(context, user);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                    child: Text('Delete'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          value ?? "N/A",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
