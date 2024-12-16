import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/edit_user_provider.dart';
import '../providers/home_provider.dart';

class UserDetailsEdit extends StatelessWidget {
  final User user;
  final String appBarTitle;


  const UserDetailsEdit({
    required this.user,
    required this.appBarTitle,

    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return ChangeNotifierProvider<EditUserProvider>(
      create: (context) => EditUserProvider(homeProvider)
        ..initialize(user, appBarTitle),
      child: Consumer<EditUserProvider>(
        builder: (context, editUserProvider, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(editUserProvider.appBarTitle,
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/background.jpeg",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Form(
                    key: editUserProvider.formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(15.0),
                      children: [
                        InkWell(
                          onTap: () => editUserProvider.pickImage(),
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 50,
                            child: editUserProvider.imagePath != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                File(editUserProvider.imagePath!),
                                fit: BoxFit.cover,
                              ),
                            )
                                : const Icon(Icons.camera_alt_outlined,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildTextFormField(
                          controller: editUserProvider.nameController,
                          label: 'Name',
                          onChanged: editUserProvider.updateName,
                        ),
                        _buildTextFormField(
                          controller: editUserProvider.qualificationController,
                          label: 'Qualification',
                          onChanged: editUserProvider.updateQualification,
                        ),
                        _buildTextFormField(
                          controller: editUserProvider.ageController,
                          label: 'Age',
                          keyboardType: TextInputType.number,
                          onChanged: editUserProvider.updateAge,
                        ),
                        _buildTextFormField(
                          controller: editUserProvider.phoneController,
                          label: 'Phone',
                          keyboardType: TextInputType.number,
                          onChanged: editUserProvider.updatePhone,
                        ),
                        _buildTextFormField(
                          controller: editUserProvider.descriptionController,
                          label: 'Description',
                          onChanged: editUserProvider.updateDescription,
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                          onPressed: () {
                            if (editUserProvider.formKey.currentState!
                                .validate()) {
                              editUserProvider.saveUser(context);
                            }
                          },
                          child: Text(
                            editUserProvider.appBarTitle == 'Add Student'
                                ? 'Save Student'
                                : 'Update Student',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 18.0),
        keyboardType: keyboardType,
        onChanged: (value) => onChanged(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter $label";
          }
          if (label == 'Phone' && !RegExp(r'^\d{10}$').hasMatch(value)) {
            return "Phone number must be 10 digits";
          }
          if (label == 'Age' && !RegExp(r'^\d{1,3}$').hasMatch(value)) {
            return "Age must be at most 3 digits";
          }
          return null;
        },
      ),
    );
  }
}
