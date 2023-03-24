import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streaming_post_demo/constants/app_images.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';
import 'package:streaming_post_demo/live_screen/ui/live_screen.dart';
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
  var controller = Get.put(MainScreenController());

  MainScreen() {
    controller.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    return SafeArea(
        child: Scaffold(
      key: key,
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration:  const BoxDecoration(
                color: colorScreenBg,
              ),
              child: Center(
                child: Obx(() =>headingText(
                    controller.username.value, SizeConfig.blockSizeHorizontal * 4, appColor,
                    weight: FontWeight.w400,),),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: colorRed,
              ),
              title: headingText(
                  home.tr, SizeConfig.blockSizeHorizontal * 4, appColor,
                  weight: FontWeight.w400),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.account_circle_outlined,
                color: colorRed,
              ),
              title: headingText(
                  aboutUs.tr, SizeConfig.blockSizeHorizontal * 4, appColor,
                  weight: FontWeight.w400),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.ad_units_rounded,
                color: colorRed,
              ),
              title: headingText(termsConditions.tr,
                  SizeConfig.blockSizeHorizontal * 4, appColor,
                  weight: FontWeight.w400),
              onTap: () {
                Navigator.pop(context);
              },
            ),
        Obx(() => controller.username != "" ?  ListTile(
              leading: const Icon(
                Icons.logout,
                color: colorRed,
              ),
              title: headingText(logout.tr,
                  SizeConfig.blockSizeHorizontal * 4, appColor,
                  weight: FontWeight.w400),
              onTap: () {
                Navigator.pop(context);
                controller.showLogoutDialog();
              },
            ) : Container()),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical * 3,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 15,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( // inside the <> you enter the type of your stream
                stream: FirebaseFirestore.instance.collection("live_streaming").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return  Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: InkWell(
                                  onTap: (){
                                    Get.to(() => LiveScreen(false, snapshot.data!.docs[index].get('user_id'), snapshot.data!.docs[index].get('streaming_token'), "0", false, "0"));
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot.data!.docs[index].get('user_image') ?? ""),
                                    radius: 40,
                                  ),
                                )),
                            headingText(
                                snapshot.data!.docs[index].get('user_name') != null &&  snapshot.data!.docs[index].get('user_name') != "" ?  snapshot.data!.docs[index].get('user_name') :"user",
                                SizeConfig.blockSizeHorizontal * 3.2,
                                colorBlack)
                          ],
                        );

                         /* ListTile(
                          title: Text(
                            snapshot.data!.docs[index].get('user_id'),
                          ),
                        );*/
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else {
                    return  Container();
                  }
                },
              ),





              /*ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return storyRowItem(index);
                },
              ),*/
            ),
            InkWell(
              onTap: () {
                //  controller.showCountriesDialog();
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: colorLightGreyBg,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    )),
                margin:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    controller: controller.searchController.value,
                    cursorColor: colorRed,
                    onChanged: (value) {
                      controller.filterSearchResults(value);
                    },
                    enabled: false,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.bottom,
                    style: const TextStyle(color: colorBlack),
                    decoration: InputDecoration(
                      hintText: searchCountryName.tr,
                      hintStyle: const TextStyle(color: colorGrey),
                      filled: true,
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      prefixIcon: Container(
                        width: SizeConfig.blockSizeVertical * 1,
                        height: SizeConfig.blockSizeVertical * 1,
                        margin: const EdgeInsets.all(5),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            search,
                            width: SizeConfig.blockSizeVertical * 3,
                            height: SizeConfig.blockSizeVertical * 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.postList.isNotEmpty
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
                      height: 300,
                      child: Center(
                        child: headingText(noDataFound.tr,
                            SizeConfig.blockSizeHorizontal * 4, colorGrey,
                            weight: FontWeight.w500),
                      ),
                    ),
            ),
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: headingText(list.username.toString(),
                      SizeConfig.blockSizeHorizontal * 4, colorBlack,
                      weight: FontWeight.w500),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: headingText(list.country.toString(),
                      SizeConfig.blockSizeHorizontal * 4, colorBlack,
                      weight: FontWeight.w500),
                ),
              ],
            ),
            const Divider(),
            list.text.toString().isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        right: 14.0, left: 14.0, top: 10, bottom: 10),
                    child: Text(
                      list.text.toString(),
                      maxLines: 25,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: colorBlack,
                          fontSize: SizeConfig.blockSizeHorizontal * 4),
                    ),
                  )
                : Container(),
            list.images!.isNotEmpty
                ? SizedBox(
                    height: SizeConfig.blockSizeVertical * 50,
                    child: ListView.builder(
                      itemCount: list.images!.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index1) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: placeholder,
                            image: list.images![index1].image.toString(),
                            width: SizeConfig.screenWidth - 40,
                            height: SizeConfig.blockSizeVertical * 50,
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    Get.to(() => CommentScreen(list.id.toString()));
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
                InkWell(
                  onTap: () {
                    controller.shareLink(list);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      share,
                      width: SizeConfig.blockSizeHorizontal * 6,
                      height: SizeConfig.blockSizeVertical * 4,
                    ),
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
