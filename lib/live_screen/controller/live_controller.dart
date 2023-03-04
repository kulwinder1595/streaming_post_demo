import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:streaming_post_demo/common/widgets.dart';

import '../../constants/storage_constants.dart';
import '../../profile/model/profile_model.dart';

class LiveController extends GetxController {
  final messageController = TextEditingController().obs;
  var store = GetStorage();
  var userData =
      ProfileModel("", "", "", "", "", "", "", "", "", "", "", "", []).obs;
  var isLoading = false.obs;
  var userID = "".obs;

  @override
  onInit() {
    getUserData();

    super.onInit();
  }

  fetchUserData(String userID) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .get()
        .then((value) {
      var videoList = <Videos>[];
      if (value.data() != null && value.data()!['videos'] != null) {
        if (value.data()!['videos'] != null && value.data()!['videos'] != []) {
          for (int j = 0; j < value.data()!['videos'].length; j++) {
            videoList.add(Videos(value.data()!['videos'][j]['video']));
          }
        }
      }
      userData.value.id = value.data() != null ? value.data()!['userId'] : "";
      userData.value.userId =
          value.data() != null ? value.data()!['userId'] : "";
      userData.value.username =
          value.data() != null ? value.data()!['username'] : "";
      userData.value.password =
          value.data() != null ? value.data()!['password'] : "";
      userData.value.phoneNumber =
          value.data() != null ? value.data()!['phoneNumber'] : "";
      userData.value.profileImage =
          value.data() != null ? value.data()!['profileImage'] : "";
      userData.value.age = value.data() != null ? value.data()!['age'] : "";
      userData.value.state = value.data() != null ? value.data()!['state'] : "";
      userData.value.nationality =
          value.data() != null ? value.data()!['nationality'] : "";
      userData.value.web = value.data() != null ? value.data()!['web'] : "";
      userData.value.email = value.data() != null ? value.data()!['email'] : "";
      userData.value.store = value.data() != null ? value.data()!['store'] : "";
      userData.value.videos = videoList;
      userData.refresh();
      isLoading.value = false;
    });
  }

  Future<void> getUserData() async {
    Future.delayed(Duration(seconds: 1), () {
      userID.value = store.read(userId);
      showDebugPrint("user id---------->  $userID");
      fetchUserData(userID.value);
    });
  }
}
