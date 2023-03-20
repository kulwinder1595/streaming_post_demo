import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';
import 'package:streaming_post_demo/main_screen/ui/main_screen.dart';
import 'package:streaming_post_demo/profile/model/profile_model.dart';
import '../../common/size_config.dart';
import '../../common/widgets.dart';
import '../../constants/app_colors.dart';
import '../../constants/storage_constants.dart';
import '../../post/model/post_model.dart';

class MainScreenController extends GetxController {
  var postList = <PostModel>[].obs;
  var duplicatePostList = <PostModel>[].obs;
  final searchController = TextEditingController().obs;
  var store = GetStorage();
  var username = "".obs;

  @override
  onInit() {
    super.onInit();
  }

  fetchPosts() async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      postList.clear();
      duplicatePostList.clear();
      await FirebaseFirestore.instance
          .collection("posts")
          .get()
          .then((value) async {
        for (var i in value.docs) {
          var imageList = <Images>[];
          if (i.data()['images'] != null && i.data()['images'] != []) {
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
                  i.data()['comments'][k]['image'].toString() ?? ""));
            }
          }

          postList.add(PostModel(
              i.id,
              i.data()['userId'] ?? "",
              i.data()['username'] ?? "",
              i.data()['text'] ?? "",
              i.data()['timestamp'].toString() ?? "",
              i.data()['country'].toString() ?? "",
              imageList ?? [],
              commentList ?? []));
        }
        await Future.delayed(Duration.zero);
        username.value = store.read(userName) != null ? store.read(userName) : "";
        postList.refresh();
        duplicatePostList.addAll(postList);
      });
    });
  }

  void filterSearchResults(String query) {
    List<PostModel> dummySearchList = [];
    dummySearchList.addAll(duplicatePostList);
    if (query.isNotEmpty) {
      List<PostModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.country
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      postList.clear();
      postList.addAll(dummyListData);
      postList.refresh();
      return;
    } else {
      postList.clear();
      postList.addAll(duplicatePostList);
      postList.refresh();
    }
  }

  Future<void> shareLink(PostModel list) async {
    await FlutterShare.share(
        title: "hi",
        text: list.text == "" || list.text == null
            ? '\n\n Watch the below post \n\n${list.username} from ${list.country} added a post having  \n\n Check 1st Image: ${list.images![0].image}'
            : list.images!.isEmpty
                ? '\n\n Watch the below post \n\n${list.username} from ${list.country} added a post having  \n\n Content: ${list.text}'
                : 'Hi!!\n\n Watch the below post \n\n${list.username} from ${list.country} added a post having  \n\n Content: ${list.text} \n\n Check 1st Image: ${list.images![0].image}',
        chooserTitle: 'Example Chooser Title');
  }

/*void showCountriesDialog() {
    showDebugPrint("-------button click--------");
    Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        content: SizedBox(
            width: SizeConfig.screenWidth / 1.5,
            height: SizeConfig.blockSizeVertical * 14,
            child: ListView.builder(
              itemCount: controller.postList.value.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return postRowItem(controller.postList.value[index]);
              },
            )),
      ),
    );
  }*/

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        content: SizedBox(
            width: SizeConfig.screenWidth / 1.5,
            height: SizeConfig.blockSizeVertical * 14,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  headingText(areYouSureToLogoutFromApp.tr,
                      SizeConfig.blockSizeHorizontal * 4.2, colorBlack,
                      weight: FontWeight.w500),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 18,
                            decoration: BoxDecoration(
                                color: colorWhite,
                                border: Border.all(color: colorRed),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: headingText(
                                  cancel.tr,
                                  SizeConfig.blockSizeHorizontal * 3.5,
                                  colorBlack,
                                  weight: FontWeight.w500),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            store.erase();
                            username.value = "";
                            Get.offAll(() => MainScreen());
                            Get.back();
                          },
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 18,
                            decoration: BoxDecoration(
                                color: colorRed,
                                border: Border.all(color: colorRed),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: headingText(
                                  ok.tr,
                                  SizeConfig.blockSizeHorizontal * 3.5,
                                  colorWhite,
                                  weight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])),
      ),
    );
  }
}
