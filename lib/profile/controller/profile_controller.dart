import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/widgets.dart';

class ProfileController extends GetxController{

  final nameController = TextEditingController().obs;
  final ageController = TextEditingController().obs;
  final stateController = TextEditingController().obs;
  final nationalityController = TextEditingController().obs;
  final webController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final storeController = TextEditingController().obs;
  var videoFile = XFile("").obs;
  var imageFile = XFile("").obs;

  getVideoFromGallery() async {
    try {
      var pickedfiles = await ImagePicker().pickVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 60));
      if (pickedfiles != null) {
        videoFile.value = pickedfiles;
        videoFile.refresh();

      } else {
        showDebugPrint("No video is selected.");
      }
    } catch (e) {
      showDebugPrint("error while picking file.");
    }
  }

 getImageFromGallery() async {
    try {
      var pickedfiles = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedfiles != null) {
        imageFile.value = pickedfiles;
        imageFile.refresh();

      } else {
        showDebugPrint("No video is selected.");
      }
    } catch (e) {
      showDebugPrint("error while picking file.");
    }
  }

}