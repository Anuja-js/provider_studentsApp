import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';
import '../utils/database_helper.dart';
import 'home_provider.dart';

class EditUserProvider extends ChangeNotifier {
  final HomeProvider homeProvider;
  final DatabaseHelper helper = DatabaseHelper();
  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController qualificationController;
  late TextEditingController ageController;
  late TextEditingController phoneController;
  late TextEditingController descriptionController;
  String appBarTitle = '';
  User user = User('', '', 0, 0, '');
  String? imagePath;
  EditUserProvider(this.homeProvider);
  void initialize(User initialUser, String title) {
    user = initialUser;
    appBarTitle = title;

    nameController = TextEditingController(text: user.name ?? '');
    qualificationController = TextEditingController(text: user.qualification ?? '');
    ageController = TextEditingController(text: user.age?.toString() ?? '');
    phoneController = TextEditingController(text: user.phone?.toString() ?? '');
    descriptionController = TextEditingController(text: user.description ?? '');
    imagePath = user.imagePath;
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath = pickedFile.path;
      notifyListeners();
    }
  }

  void updateName() {
    user.name = nameController.text;
  }
  void updateQualification() {
    user.qualification = qualificationController.text;
  }
  void updateAge() {
    user.age = int.tryParse(ageController.text);
  }
  void updatePhone() {
    user.phone = int.tryParse(phoneController.text);
  }
  void updateDescription() {
    user.description = descriptionController.text;
  }
  Future<void> saveUser(BuildContext context) async {
    // Assign the image path to the user
    user.imagePath = imagePath;
    // Validate if the operation is Add or Update based on the appBarTitle value
    if (appBarTitle == 'Add Student') {
      // Insert the new user into the database
      await helper.insertUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Update the existing user in the database
      await helper.updateUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }

    // Update the user list in HomeProvider and navigate back
    homeProvider.updateListView();
    Navigator.of(context).popUntil((route) => route.isFirst);//home
  }
}
