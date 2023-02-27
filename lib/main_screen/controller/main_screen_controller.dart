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
                i.data()['comments'][k]['timestamp'].toString() ?? ""));
          }
        }
        postList.value.add(PostModel(
            i.id,
            i.data()['userId'] ?? "",
            i.data()['username'] ?? "",
            i.data()['text'] ?? "",
            i.data()['timestamp'].toString() ?? "",
            imageList ?? [],
            commentList ?? []));
        postList.refresh();
      }
    });
  }
}
