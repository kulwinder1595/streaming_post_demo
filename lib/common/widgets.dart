import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streaming_post_demo/common/size_config.dart';

import '../constants/app_colors.dart';

Widget headingText(String title, double size, Color color,
    {FontWeight weight = FontWeight.w700}) {
  return Text(
    title,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        fontWeight: weight,
        color: color,
        fontSize: size),
  );
}

Widget normalText(String title, double size, Color color,
    {TextAlign alignment = TextAlign.center}) {
  return Text(
    title,
    textAlign: alignment,
    style: TextStyle(
        fontWeight: FontWeight.w300,
        color: color,
        fontSize: size),
  );
}

AppBar appBar(BuildContext context, GlobalKey<ScaffoldState> key,
    String broadcastYourShows) {
  return AppBar(
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: colorWhite,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /*  InkWell(
            onTap: () {
              key.currentState!.openDrawer();
            },
            child: Image.asset(
              menu,
              width: SizeConfig.blockSizeHorizontal * 5,
              height: SizeConfig.blockSizeVertical * 5,
            ),
          ),*/
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 5,
            height: SizeConfig.blockSizeVertical * 5,
          ),
          headingText(broadcastYourShows, SizeConfig.blockSizeHorizontal * 4.7,
              colorBlack),
          /*InkWell(
            onTap: () {
              showLogoutDialog();
            },
            child: Image.asset(
              moveOut,
              width: SizeConfig.blockSizeHorizontal * 6,
              height: SizeConfig.blockSizeVertical * 6,
            ),
          ),*/
        ],
      ));
}

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
                headingText("areYouSureToLogoutFromApp",
                    SizeConfig.blockSizeHorizontal * 3.2, colorBlack,
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
                                "cancel",
                                SizeConfig.blockSizeHorizontal * 2.5,
                                colorBlack,
                                weight: FontWeight.w500),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
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
                                "ok",
                                SizeConfig.blockSizeHorizontal * 2.5,
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

Drawer drawerLayout(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: colorScreenBg,
          ),
          child: Text(''),
        ),
        ListTile(
          leading: const Icon(
            Icons.home,
            color: colorRed,
          ),
          title: const Text('Under Construction'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        /*ListTile(
          leading: Icon(
            Icons.train,
          ),
          title: const Text('Page 2'),
          onTap: () {
            Navigator.pop(context);
          },
        ),*/
      ],
    ),
  );
}

showMessage(String message) {
  Flushbar(
    message: message,
    duration: const Duration(seconds: 2),
  ).show(Get.context!);
}

showDebugPrint(String message) {
  debugPrint(message);
}

Widget commonLoader() {
  return Stack(
    children: const [
      Opacity(
        opacity: 0.4,
        child: ModalBarrier(dismissible: false, color: Colors.grey),
      ),
      Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colorRed),
        ),
      ),
    ],
  );
}
