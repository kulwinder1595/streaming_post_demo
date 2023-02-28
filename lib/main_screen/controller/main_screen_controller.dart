import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';
import '../../post/model/post_model.dart';

class MainScreenController extends GetxController {
  var postList = <PostModel>[].obs;
  final searchController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
  }

  fetchPosts() async {
    postList.value.clear();
    await FirebaseFirestore.instance.collection("posts").get().then((value) {
      for (var i in value.docs) {
        var imageList = <Images>[];
        if(i.data()['images'] != null && i.data()['images'] != []) {
          for (int j = 0; j < i.data()['images'].length; j++) {
            imageList.add(Images(i.data()['images'][j]));
          }
        }
        var commentList = <Comments>[];
        if (i.data()['comments'] != null && i.data()['comments'] != []) {
          for (int k = 0; k < i.data()['comments'].length; k++) {
            commentList.add(Comments(
                i.data()['comments'][k]['comment'] ?? null,
                i.data()['comments'][k]['username'] ?? "",
                i.data()['comments'][k]['userId'] ?? "",
                i.data()['comments'][k]['timestamp'].toString() ?? "",
                i.data()['comments'][k]['image'].toString() ?? "")
            );
          }
        }

        postList.value.add(PostModel(
            i.id,
            i.data()['userId'] ?? "",
            i.data()['username'] ?? "",
            i.data()['text'] ?? "",
            i.data()['timestamp'].toString() ?? "",
            i.data()['country'].toString() ?? "",
            imageList ?? [],
            commentList ?? []));
        postList.refresh();
      }
    });
  }

  Future<void> shareLink(PostModel list) async {
    await FlutterShare.share(
        title: "hi",
        text: list.text == "" || list.text == null ? '\n\n Watch the below post \n\n${list.username} from ${list.country} added a post having  \n\n Check 1st Image: ${list.images![0].image}'
        :list.images!.isEmpty ? '\n\n Watch the below post \n\n${list.username} from ${list.country} added a post having  \n\n Content: ${list.text}':
        'Hi!!\n\n Watch the below post \n\n${list.username} from ${list.country} added a post having  \n\n Content: ${list.text} \n\n Check 1st Image: ${list.images![0].image}',
         chooserTitle: 'Example Chooser Title');
  }

}
