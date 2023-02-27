import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:streaming_post_demo/common/widgets.dart';
import 'package:streaming_post_demo/constants/storage_constants.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';
import 'package:streaming_post_demo/post/model/post_model.dart';

class CommentController extends GetxController {
  final commentController = TextEditingController().obs;
  var commentList = <Comments>[].obs;
  var commentId = "".obs;
  var store = GetStorage();

  fetchComments() async {
    commentList.value.clear();
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(commentId.value)
        .get()
        .then((value) {

          for(int i = 0; i< value.data()!['comments'].length ; i++) {
            commentList.value.add(Comments.fromJson(value.data()!['comments'][i]));
          }
      commentList.refresh();
    });
  }

  void sendMessage() {
    if (commentController.value.text.isEmpty) {
      showMessage(enterComment.tr);
    } else {
      if (store.read(userName) == "") {
        showMessage(pleaseLoginFirstToShareAPost.tr);
      } else {
        commentList.value.add(Comments(
            commentController.value.text,
            store.read(userName),
            store.read(userId),
            (DateTime
                .now()
                .toUtc()
                .millisecondsSinceEpoch).toString()));

        var map = {
          'comment': commentController.value.text,
          'username': store.read(userName),
          'userId': store.read(userId),
          'timestamp': DateTime
              .now()
              .toUtc()
              .millisecondsSinceEpoch,
        };

        FirebaseFirestore.instance.collection('posts').doc(commentId.value).set(
            {
              'comments': commentList.value.map((e) => e.toMap()).toList(),
            }, SetOptions(merge: true)).then((value) =>
        {
          commentList.refresh(),
          commentController.value.text = "",
          showMessage("Message sent successfully")
        });
      }
    }
  }
}
