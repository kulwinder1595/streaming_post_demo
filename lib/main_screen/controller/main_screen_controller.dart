import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../post/model/post_model.dart';

class MainScreenController extends GetxController {
  var postList = <PostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  fetchPosts() async {
    postList.value.clear();
    await FirebaseFirestore.instance.collection("posts").get().then((value) {
      for (var i in value.docs) {
        var imageList = <Images>[];
        for (int j = 0; j < i['images'].length; j++) {
          imageList.add(Images(i['images'][j]));
        }
        var commentList = <Comments>[];
        if (i['comments'] != null && i['comments'] != []) {
          for (int k = 0; k < i['comments'].length; k++) {
            commentList.add(Comments(
                i['comments'][k]['comment'] ?? null,
                i['comments'][k]['username'],
                i['comments'][k]['userId'],
                i['comments'][k]['timestamp']));
          }
        }
        postList.value.add(PostModel(
            i.id,
            i['userId'] ?? "",
            i['username'] ?? "",
            i['text'] ?? "",
            i['timestamp'],
            imageList ?? [],
            commentList ?? []));
        postList.refresh();
      }
    });
  }
}
