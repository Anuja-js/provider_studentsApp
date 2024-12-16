// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerregisterapp/customs/text_custom.dart';
import 'package:providerregisterapp/screens/user_detail.dart';
import '../customs/constants.dart';
import '../models/user.dart';
import '../providers/home_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextCustom(
          text: "Students",
          textSize: 15.sp,
          color: white,
        ),
        backgroundColor:black,
        actions: [
          Consumer<HomeProvider>(
            builder: (context, homeProvider, child) => IconButton(
              onPressed: () {
                homeProvider.toggleViewMode();
              },
              icon: homeProvider.isGridView
                  ? const Icon(Icons.grid_4x4_outlined, color: white)
                  : const Icon(Icons.list_alt_outlined, color: white),
            ),
          ),
          IconButton(
            onPressed: () {
              Provider.of<HomeProvider>(context, listen: false).logout(context);
            },
            icon: const Icon(Icons.logout, color: white),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Consumer<HomeProvider>(
              builder: (context, homeProvider, child) => TextField(
                controller: homeProvider.searchController,
                onChanged: homeProvider.filterUserList,
                style: const TextStyle(color: white),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: grey, width: 2.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: grey, width: 2.w),
                  ),
                  prefixIcon: const Icon(Icons.search, color: white),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/background.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
              homeProvider.userList.isEmpty
                  ? const Center(
                      child: Text(
                        "NO STUDENTS AVAILABLE",
                        style: TextStyle(color: black),
                      ),
                    )
                  : homeProvider.isGridView
                      ? getUsersListView(homeProvider)
                      : getUsersGridView(homeProvider)
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: black,
        foregroundColor: white,
        onPressed: () {
          Provider.of<HomeProvider>(context, listen: false).navigateToDetail(
              context, User('', '', null, null, '', null), 'Add Student');
        },
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getUsersListView(HomeProvider providerHome) {
    return ListView.builder(
      itemCount: providerHome.userList.length,
      itemBuilder: (context, index) {
        final user = providerHome.userList[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
          child: Card(
            color: Colors.transparent,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: ListTile(
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return UserDetails(
                    user,
                  );
                }));
              },
              leading: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: black,
                ),
                child: user.imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: Image.file(
                          File(user.imagePath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person, color: white),
              ),
              title:
                  Text(user.name ?? '', style: const TextStyle(color: black)),
              subtitle: Text(user.qualification ?? ''),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: black,
                      ),
                      onPressed: () {
                        providerHome.navigateToDetail(
                            context, user, 'Edit Student');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: black,
                      ),
                      onPressed: () {
                        providerHome.showDeleteConfirmationDialog(
                            context, user);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  GridView getUsersGridView(HomeProvider providerHome) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: providerHome.userList.length,
      itemBuilder: (context, index) {
        final user = providerHome.userList[index];
        return InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return UserDetails(
                user,
              );
            }));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            color: Colors.transparent,
            elevation: 2.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                children: [
                  Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      color: black,
                    ),
                    child: user.imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(35.r),
                            child: Image.file(
                              File(user.imagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.person, color: white),
                  ),
                  SizedBox(height: 10.h),
                  Text(user.name ?? '',
                      style: TextStyle(color: black, fontSize: 18.sp)),
                  Text(user.qualification ?? '',
                      style: TextStyle(color: black54, fontSize: 15.sp)),
                  const Spacer(),
                  SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: black,
                          ),
                          onPressed: () {
                            providerHome.navigateToDetail(
                                context, user, 'Edit Student');
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: black,
                          ),
                          onPressed: () {
                            providerHome.showDeleteConfirmationDialog(
                                context, user);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
