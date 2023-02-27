import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streaming_post_demo/common/size_config.dart';
import 'package:streaming_post_demo/common/widgets.dart';
import 'package:streaming_post_demo/constants/app_colors.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';
import 'package:streaming_post_demo/post/controller/post_controller.dart';

import '../../constants/app_images.dart';

class AddPostScreen extends StatelessWidget {
  var controller = Get.put(PostController());

  AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child:  Stack(
            children: [
        Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child:Column(
                children: [
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  Center(
                    child: headingText(
                        addPost.tr, SizeConfig.blockSizeHorizontal * 8, colorBlack),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 25,
                          child: headingText(country.tr,
                              SizeConfig.blockSizeHorizontal * 4.5, colorBlack)),
                      Expanded(
                        child: SizedBox(
                          height: SizeConfig.blockSizeVertical * 6,
                          child: TextFormField(
                            controller: controller.countryController.value,
                            cursorColor: colorRed,
                            maxLines: 1,
                            textAlignVertical: TextAlignVertical.bottom,
                            style: const TextStyle(color: colorBlack),
                            decoration: InputDecoration(
                              hintText: country.tr,
                              hintStyle: const TextStyle(color: colorGrey),
                              filled: true,
                              fillColor: colorWhite,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide:
                                    BorderSide(color: colorGrey, width: 0.7),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: colorGrey),
                              ),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(color: colorRed),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: SizeConfig.blockSizeVertical * 6,
                          width: SizeConfig.blockSizeHorizontal * 25,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 13.0),
                            child: headingText(addText.tr,
                                SizeConfig.blockSizeHorizontal * 4.5, colorBlack),
                          )),
                      Expanded(
                        child: SizedBox(
                          // height: SizeConfig.blockSizeVertical * 6,
                          child: TextFormField(
                            controller: controller.textController.value,
                            cursorColor: colorRed,
                            maxLines: 10,
                            maxLength: 500,
                            textAlignVertical: TextAlignVertical.bottom,
                            style: const TextStyle(color: colorBlack),
                            decoration: InputDecoration(
                              hintText: addText.tr,
                              hintStyle: const TextStyle(color: colorGrey),
                              filled: true,
                              fillColor: colorWhite,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide:
                                    BorderSide(color: colorGrey, width: 0.7),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: colorGrey),
                              ),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(color: colorRed),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          height: SizeConfig.blockSizeVertical * 6,
                          width: SizeConfig.blockSizeHorizontal * 21,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: headingText(photo.tr,
                                SizeConfig.blockSizeHorizontal * 4.5, colorBlack),
                          )),
                      InkWell(
                        onTap: () {
                          controller.getFromGallery();
                        },
                        child: SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 20,
                          height: SizeConfig.blockSizeVertical * 10,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                plus,
                                width: SizeConfig.blockSizeHorizontal * 8.5,
                                height: SizeConfig.blockSizeVertical * 4.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: SizeConfig.blockSizeVertical * 15,
                          child: Obx (() =>  controller.imageFileList.value.length > 0 ? ListView.builder(
                            itemCount: controller.imageFileList.value.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                child:Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.file(
                                    File(controller.imageFileList.value![index].path),
                                    width: SizeConfig.blockSizeHorizontal * 20,
                                    height: SizeConfig.blockSizeVertical * 15,
                                    fit: BoxFit.fill,
                                  ),),
                              );
                            },
                          ) : Container(),
                        ),
                      ),),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          controller.addPostButtonClick();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 15.0,
                        ),
                        child: SizedBox(
                            width: SizeConfig.screenWidth / 1.5,
                            height: SizeConfig.blockSizeVertical * 6,
                            child: Center(
                                child: headingText(
                                    add.tr,
                                    SizeConfig.blockSizeHorizontal * 4,
                                    colorWhite)))),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  Center(
                    child: headingText(termsConditions.tr,
                        SizeConfig.blockSizeHorizontal * 4, colorBlack),
                  ),
                ],
              ),),
              Obx (() => controller.isLoading.value == true ? Container( width: SizeConfig.screenWidth, height : SizeConfig.screenHeight, child: Center(child: commonLoader())) : Container(),),

            ],
          ),
        ),

    ));
  }
}
