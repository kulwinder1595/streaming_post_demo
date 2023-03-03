import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_share/flutter_share.dart';
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
  var postData = PostModel(
      "",
      "",
      "",
      "",
      "",
      "",
      null,
      null).obs;
  var imageUrlList = <String>[].obs;
  var isLoading = false.obs;
  var commentList = <Comments>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

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
          imageUrlList.clear();
          imageUrlList.refresh();
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
      if (store.read(userName) == "" || store.read(userName) == null) {
        showMessage(pleaseLoginFirstToShareAPost.tr);
      } else {
        isLoading.value = true;

        if (imageUrlList.value.isNotEmpty) {
          uploadPost();
        } else {
          // uploading images on firebase store
          for (int i = 0; i < imageFileList.length; i++) {
            try {
              var filename =
                  'sightings/${DateTime
                  .now()
                  .toUtc()
                  .millisecondsSinceEpoch}.png';
              Reference storageReference =
              FirebaseStorage.instance.ref().child(filename);

              storageReference
                  .putFile(File(imageFileList.value[i].path))
                  .then((p0) async =>
              {
                await FirebaseStorage.instance
                    .ref()
                    .child(filename)
                    .getDownloadURL()
                    .then((value) =>
                {
                  print("image url --->  $value"),
                  imageUrlList.add(value.toString())
                })
              });
            } catch (e) {
              showDebugPrint("Image upload excaption ----------->  $e");
            }
          }
          uploadingConditionCheck
            (
          );
        }
      }
  }
  }

  Future<void> uploadPost() async {
    var map = {
      'userId': store.read(userId),
      'username': store.read(userName),
      'country': countryController.value.text.trim(),
      'text': textController.value.text.trim(),
      'timestamp': (DateTime
          .now()
          .toUtc()
          .millisecondsSinceEpoch).toString(),
      'images': imageUrlList,
      'comments': commentList
    };
    showDebugPrint("userid ------------->  ${store.read(userId)}");

    await FirebaseFirestore.instance
        .collection("posts")
        .doc(store.read(userId))
        .set({
      'userId': store.read(userId),
      'username': store.read(userName),
      'country': countryController.value.text.trim(),
      'text': textController.value.text.trim(),
      'timestamp': (DateTime
          .now()
          .toUtc()
          .millisecondsSinceEpoch).toString(),
      'images': imageUrlList.value,
      'comments': commentList.value
    }).then((value) =>
    {
      showMessage(postShareSuccessfully.tr),
      isLoading.value = false,
      Get.to(() => MainScreen()),
      countryController.value.text = "",
      textController.value.text = "",
      imageFileList.clear(),
      imageUrlList.clear(),
      commentList.clear(),
    });
  }

  void uploadingConditionCheck() {
    Future.delayed(const Duration(seconds: 5), () {
      if (imageUrlList.value.length == imageFileList.value.length) {
        uploadPost();
      } else {
        uploadingConditionCheck();
      }
    });
  }

  fetchUserPost() async {

    await FirebaseFirestore.instance
        .collection("posts")
        .doc(store.read(userId))
        .get()
        .then((value) {
      isLoading.value = true;
      var imageList = <Images>[];
     if(value.data() != null && value.data()!['images'] != null){
       if (value.data()!['images'] != null &&
           value.data()!['images'] != []) {
         for (int j = 0; j < value.data()!['images'].length; j++) {
           imageList.add(Images(value.data()!['images'][j]));
           imageUrlList.add(value.data()!['images'][j]);
         }
       }
     }

  /*    if (value.data() != null && value.data()!['comments'] != null && value.data()!['comments'] != []) {
        for (int k = 0; k < value.data()!['comments'].length; k++) {
          commentList.add(Comments(
              value.data()!['comments'][k]['comment'] ?? "",
              value.data()!['comments'][k]['username'] ?? "",
              value.data()!['comments'][k]['userId'] ?? "",
              value.data()!['comments'][k]['timestamp'].toString() ?? "",
              value.data()!['comments'][k]['image'].toString() ?? "")
          );
        }
      }*/
      isLoading.value = false;
      postData.value.id = value.id;
      postData.value.userId = value.data()!= null ? value.data()!['userId'] : "";
      postData.value.username = value.data()!= null ? value.data()!['username'] : "";
      postData.value.text = value.data()!= null ? value.data()!['text'] : "";
      postData.value.timestamp = value.data()!= null ? value.data()!['timestamp'] : "";
      postData.value.country = value.data()!= null ? value.data()!['country'] : "";
      postData.value.images = imageList;
      postData.value.comments = commentList;
      countryController.value.text = postData.value.country.toString();
      textController.value.text = postData.value.text.toString();
      imageUrlList.refresh();
      postData.refresh();
    });
  }

  void deletePostButtonClick() {
    FirebaseFirestore.instance.collection("posts").doc(store.read(userId)).delete().then((value){
      showMessage(postDeletedSuccessfully.tr);
      isLoading.value = false;
      Get.to(() => MainScreen());
      countryController.value.text = "";
      textController.value.text = "";
      imageFileList.clear();
      imageUrlList.clear();
      commentList.clear();
    });
  }
}
