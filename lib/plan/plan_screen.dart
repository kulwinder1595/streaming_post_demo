import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';
import 'package:streaming_post_demo/live_screen/ui/live_screen.dart';

import '../common/size_config.dart';
import '../common/widgets.dart';
import '../constants/app_colors.dart';

class PlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical * 7,
            ),
            Center(
              child: headingText(
                  chooseThePlan.tr, SizeConfig.blockSizeHorizontal * 7, appColor,
                  weight: FontWeight.w500),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 10,
            ),
            Row(
              children: [
                headingText("${freeTrial.tr}\n${fiveDays.tr}",
                    SizeConfig.blockSizeHorizontal * 4, colorBlack,
                    weight: FontWeight.w400),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      Get.to(() => LiveScreen() );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 15.0,
                    ),
                    child: SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 10,
                        height: SizeConfig.blockSizeVertical * 4,
                        child: Center(
                            child: headingText(
                                go.tr,
                                SizeConfig.blockSizeHorizontal * 4,
                                colorWhite)))),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 3,
            ),
         Row(
              children: [
                headingText(oneMonthPlan.tr,
                    SizeConfig.blockSizeHorizontal * 4, colorBlack,
                    weight: FontWeight.w400),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      //controller.registerToFirebase();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 15.0,
                    ),
                    child: SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 10,
                        height: SizeConfig.blockSizeVertical * 4,
                        child: Center(
                            child: headingText(
                                go.tr,
                                SizeConfig.blockSizeHorizontal * 4,
                                colorWhite)))),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 3,
            ),
         Row(
              children: [
                headingText(yearlyPlan.tr,
                    SizeConfig.blockSizeHorizontal * 4, colorBlack,
                    weight: FontWeight.w400),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      //controller.registerToFirebase();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 15.0,
                    ),
                    child: SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 10,
                        height: SizeConfig.blockSizeVertical * 4,
                        child: Center(
                            child: headingText(
                                go.tr,
                                SizeConfig.blockSizeHorizontal * 4,
                                colorWhite)))),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 7,
            ),
          ],
        ),
      ),
    ));
  }
}
