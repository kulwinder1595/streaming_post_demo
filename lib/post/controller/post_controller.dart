import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streaming_post_demo/common/widgets.dart';
import 'package:streaming_post_demo/constants/storage_constants.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';

import '../../main_screen/ui/main_screen.dart';
import '../model/post_model.dart';

class PostController extends GetxController {
  final countryController = TextEditingController().obs;
  final textController = TextEditingController().obs;
  var store = GetStorage();
  var imageFileList = <XFile>[].obs;

  var isLoading = false.obs;

  getFromGallery() async {
    try {
      var pickedfiles = await ImagePicker().pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        if (pickedfiles.length > 5) {
          showMessage(youCanOnlySelectUpto5Photos.tr);
        } else {
          imageFileList.clear();
          imageFileList.value = pickedfiles;
          imageFileList.refresh();
        }
      } else {
        showDebugPrint("No image is selected.");
      }
    } catch (e) {
      showDebugPrint("error while picking file.");
    }
  }

  Future<void> addPostButtonClick() async {
    if (countryController.value.text.isEmpty) {
      showMessage(enterCountryName.tr);
    } else if (textController.value.text.isEmpty &&
        imageFileList.value.isEmpty) {
      showMessage(cantShareEmptyPost.tr);
    } else {
      if (store.read(userName) == "") {
        showMessage(pleaseLoginFirstToShareAPost.tr);
      } else {
        isLoading.value = true;
        List<String> imageUrlList = [];
        // uploading images on firebase store
        for (int i = 0; i < imageFileList.length; i++) {
          try {
            var filename =
                'sightings/${DateTime.now().toUtc().millisecondsSinceEpoch}.png';
            Reference storageReference =
                FirebaseStorage.instance.ref().child(filename);

            storageReference
                .putFile(File(imageFileList.value[i].path))
                .then((p0) async => {
                      await FirebaseStorage.instance
                          .ref()
                          .child(filename)
                          .getDownloadURL()
                          .then((value) => {
                                print("image url --->  $value"),
                                imageUrlList.add(value.toString())
                              })
                    });
          } catch (e) {
            showDebugPrint("Image upload excaption ----------->  $e");
          }
        }
        uploadingConditionCheck(imageUrlList);
      }
    }
  }

  Future<void> uploadPost(List<String> imageUrlList) async {
    var map = {
      'userId': store.read(userId),
      'username': store.read(userName),
      'country': countryController.value.text.trim(),
      'text': textController.value.text.trim(),
      'timestamp': (DateTime.now().toUtc().millisecondsSinceEpoch).toString(),
      'images': imageUrlList,
      'comments': []
    };
    await FirebaseFirestore.instance
        .collection("posts")
        .add(map)
        .then((value) => {
              showMessage(postShareSuccessfully.tr),
              isLoading.value = false,
              Get.to(() => MainScreen()),
              countryController.value.text = "",
              textController.value.text = "",
              imageFileList.value.clear(),
              imageUrlList.clear(),
            });
  }

  void uploadingConditionCheck(List<String> imageUrlList) {
    Future.delayed(Duration(seconds: 5), () {
      if (imageUrlList.length == imageFileList.value.length) {
        uploadPost(imageUrlList);
      } else {
        uploadingConditionCheck(imageUrlList);
      }
    });
  }
}
