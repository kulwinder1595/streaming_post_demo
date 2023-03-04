import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streaming_post_demo/common/size_config.dart';
import 'package:streaming_post_demo/common/widgets.dart';
import 'package:streaming_post_demo/constants/app_colors.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';
import 'package:streaming_post_demo/live_screen/controller/live_controller.dart';
import 'package:streaming_post_demo/profile/ui/profile_screen.dart';

import '../../constants/app_images.dart';

class LiveScreen extends StatelessWidget {
  var controller = Get.put(LiveController());

 /* LiveScreen(){
    controller.fetchUserData();
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 0.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorBlack,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: headingText(myStore.tr,
                            SizeConfig.blockSizeHorizontal * 4, colorBlack),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorBlack,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: headingText(follow.tr,
                            SizeConfig.blockSizeHorizontal * 4, colorBlack),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorBlack,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: headingText('${myClients.tr}(0)',
                            SizeConfig.blockSizeHorizontal * 4, colorBlack),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Get.to( () => ProfileScreen(controller.userData.value));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: colorBlack,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: headingText(myProfile.tr,
                              SizeConfig.blockSizeHorizontal * 4, colorBlack),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorBlack,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: headingText("${receiveARequest.tr}(0)",
                            SizeConfig.blockSizeHorizontal * 4, colorBlack),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: colorLightGreyBg,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        )),
                    margin: const EdgeInsets.only(
                        left: 15.0, right: 15.0, bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        controller: controller.messageController.value,
                        cursorColor: colorRed,
                        maxLines: 1,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: const TextStyle(color: colorBlack),
                        decoration: InputDecoration(
                          hintText: enter.tr,
                          hintStyle: const TextStyle(color: colorGrey),
                          filled: true,
                          border: InputBorder.none,
                          prefixIcon: InkWell(
                            onTap: () {
                              // controller.openGallery();
                            },
                            child: Container(
                              width: SizeConfig.blockSizeVertical * 1,
                              height: SizeConfig.blockSizeVertical * 1,
                              margin: const EdgeInsets.all(5),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  attachment,
                                  width: SizeConfig.blockSizeVertical * 3,
                                  height: SizeConfig.blockSizeVertical * 3,
                                ),
                              ),
                            ),
                          ),
                          fillColor: Colors.transparent,
                          suffixIcon: InkWell(
                            onTap: () {
                              // controller.sendMessage();
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: Container(
                              width: SizeConfig.blockSizeVertical * 1,
                              height: SizeConfig.blockSizeVertical * 1,
                              margin: const EdgeInsets.all(5),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  sendChat,
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
                ],
              ),
            ),
            Obx(
            () => controller.isLoading.value == true
    ? Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Center(child: commonLoader()))
        : Container(),),
          ],
        ),
      ),
    ));
  }
}
