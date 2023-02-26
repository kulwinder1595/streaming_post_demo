import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:streaming_post_demo/constants/app_images.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';
import 'package:streaming_post_demo/login/login_screen.dart';
import 'package:streaming_post_demo/main_screen/controller/main_screen_controller.dart';
import 'package:streaming_post_demo/main_screen/ui/comment_screen.dart';
import 'package:streaming_post_demo/post/model/post_model.dart';

import '../../common/size_config.dart';
import '../../common/widgets.dart';
import '../../constants/app_colors.dart';
import '../../plan/plan_screen.dart';
import '../../post/ui/add_post.dart';

class MainScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  var controller = Get.put(MainScreenController());

  MainScreen() {
    controller.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //   key: key,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorWhite,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                key.currentState!.openDrawer();
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 12.0, top: 12.0, bottom: 12.0),
                child: Image.asset(
                  menu,
                  width: SizeConfig.blockSizeHorizontal * 6,
                  height: SizeConfig.blockSizeVertical * 2.8,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => PlanScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  live,
                  width: SizeConfig.blockSizeHorizontal * 9,
                  height: SizeConfig.blockSizeVertical * 5,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => AddPostScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  plus,
                  width: SizeConfig.blockSizeHorizontal * 6.5,
                  height: SizeConfig.blockSizeVertical * 2.8,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => LoginScreen());
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0),
                child: headingText(
                    enter, SizeConfig.blockSizeHorizontal * 5.2, colorBlack),
              ),
            )
          ],
        ),
      ),
      drawer: drawerLayout(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical * 15,
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return storyRowItem(index);
                },
              ),
            ),
            Obx(() => controller.postList.value.length > 0
                ? ListView.builder(
                    itemCount: controller.postList.value.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return postRowItem(controller.postList.value[index]);
                    },
                  )
                : Container(
                    height: 400,
                    child: Center(
                      child: commonLoader()
                    ),
                  )),
          ],
        ),
      ),
    ));
  }

  Widget storyRowItem(int index) {
    return const Padding(
        padding: EdgeInsets.all(5.0),
        child: CircleAvatar(
          backgroundImage: AssetImage(dummyImage),
          radius: 40,
        ));
  }

  Widget postRowItem(PostModel list) {
    return Card(
        margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        elevation: 2,
        shadowColor: colorGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: headingText(list.username,
                  SizeConfig.blockSizeHorizontal * 4, colorBlack,
                  weight: FontWeight.w500),
            ),
            const Divider(),
            !list.text.isEmpty ? Padding(
              padding: const EdgeInsets.only(
                  right: 14.0, left: 14.0, top: 10, bottom: 10),
              child: headingText(
                  list.text, SizeConfig.blockSizeHorizontal * 4, colorBlack,
                  weight: FontWeight.w300),
            ):Container(),
         list.images.length > 0 ?   SizedBox(
              height: SizeConfig.blockSizeVertical * 50,
              child: ListView.builder(
                itemCount: list.images.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index1) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: placeholder,
                      image: list.images[index1].image,
                      width: SizeConfig.screenWidth - 40,
                      height: SizeConfig.blockSizeVertical * 50,
                      fit: BoxFit.fill,
                    ),
                  );
                },
              ),
            ) : Container(),
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    Get.to(() => CommentScreen(list.id));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      chat,
                      width: SizeConfig.blockSizeHorizontal * 6,
                      height: SizeConfig.blockSizeVertical * 4,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    share,
                    width: SizeConfig.blockSizeHorizontal * 6,
                    height: SizeConfig.blockSizeVertical * 4,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 2,
                )
              ],
            )
          ],
        ));
  }
}
