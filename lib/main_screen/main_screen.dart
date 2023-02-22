import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:streaming_post_demo/constants/app_images.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';
import 'package:streaming_post_demo/login/login_screen.dart';
import 'package:streaming_post_demo/plan/plan_screen.dart';

import '../common/size_config.dart';
import '../common/widgets.dart';
import '../constants/app_colors.dart';

class MainScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
              onTap: (){
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
              onTap: (){
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                plus,
                width: SizeConfig.blockSizeHorizontal * 6.5,
                height: SizeConfig.blockSizeVertical * 2.8,
              ),
            ),
            InkWell(
              onTap: (){
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

            ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return postRowItem(index);
              },
            ),
          ],
        ),
      ),
    ));
  }

  Widget storyRowItem(int index) {
    return  const Padding(
      padding:  EdgeInsets.all(5.0),
      child: CircleAvatar(
        backgroundImage: AssetImage(dummyImage),
        radius: 40,
      )
    );
  }

  Widget postRowItem(int index) {
    return Card(
        margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        elevation: 2,
        shadowColor: colorGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical * 31,
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.darken),
                    image: const NetworkImage(
                        "https://fastly.picsum.photos/id/1064/536/354.jpg?hmac=3m2mR2AP_ciBQdwJZYjqlZAdaBltgQkmiKbK6m6fLAA"),
                    fit: BoxFit.cover),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            Row(children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  chat,
                  width: SizeConfig.blockSizeHorizontal * 6,
                  height: SizeConfig.blockSizeVertical * 4,
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
            ],)
          ],
        ));
  }
}
