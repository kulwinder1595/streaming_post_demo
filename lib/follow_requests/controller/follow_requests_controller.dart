import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:streaming_post_demo/profile/model/profile_model.dart';

import '../../common/widgets.dart';
import '../../constants/string_constants.dart';

class FollowRequestsController extends GetxController{
  var userID = "".obs;
  var requestsList = <Followers>[].obs;


  void deleteFollowRequest(int index) {
    requestsList.removeAt(index);
    requestsList.refresh();

    FirebaseFirestore.instance
        .collection('follow_request')
        .doc(userID.value)
        .set({
      "requests": requestsList.value.map((e) => e.toMap()).toList(),
    }, SetOptions(merge: true)).then((res) {

      showMessage(dataUpdatedSuccessfully.tr);
    });
  }
void acceptFollowRequest(int index) {
    FirebaseFirestore.instance
        .collection('followers')
        .doc(userID.value)
        .set({
      "requests": requestsList.value.map((e) => e.toMap()).toList(),
    }, SetOptions(merge: true)).then((res) {

     deleteFollowRequest(index);
    });
  }
}