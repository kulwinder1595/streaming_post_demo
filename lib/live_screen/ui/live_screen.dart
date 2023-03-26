import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:streaming_post_demo/common/size_config.dart';
import 'package:streaming_post_demo/common/widgets.dart';
import 'package:streaming_post_demo/constants/app_colors.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';
import 'package:streaming_post_demo/follow_requests/ui/follow_requests_screen.dart';
import 'package:streaming_post_demo/live_screen/controller/live_controller.dart';
import 'package:streaming_post_demo/live_screen/controller/streaming_requests_controller.dart';
import 'package:streaming_post_demo/live_screen/ui/streaming_requests_screen.dart';
import 'package:streaming_post_demo/my_clients/ui/my_clients_screen.dart';
import 'package:streaming_post_demo/profile/ui/profile_screen.dart';
import '../../constants/app_images.dart';
import '../model/chat_model.dart';

class LiveScreen extends StatelessWidget {
  var controller = Get.put(LiveController());

  LiveScreen(bool _isHost, streamingUserIds, streamingToken, String streamingJoiningId, bool groupStreaming, String hostId) {
    controller.isHost.value = _isHost;
    controller.streamingUserId.value = streamingUserIds;
    controller.streamingJoiningId.value = streamingJoiningId;
    controller.hostId.value = hostId;
    controller.groupStreaming.value = groupStreaming;
    print("I am hitting audience");

    //controller.fetchAudienceData(controller.streamingUserId.value);
    Future.delayed(Duration(seconds: 2), ()
    {

      if (controller.groupStreaming.value == true) {
        controller.isHost.value = true;
        controller.setupVideoSDKEngine();
       /* print("firebase remote user id ------->  ${controller
            .streamingJoiningId}");
        controller.users.value.add(int.parse(controller.streamingJoiningId.toString()));
        controller.users.value.add(int.parse(controller.hostId.toString()));
        controller.users.refresh();
        for(int i = 0; i< controller.users.length ; i++){
          showDebugPrint("--------------audience-----------  ${controller.users[i]}");
        }*/
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          controller.backPressButton();
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: SizeConfig.screenWidth,
                //  height: SizeConfig.screenHeight,
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 0.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.storeButtonClick(
                                    controller.userData.value.store.toString());
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
                                  child: headingText(
                                      myStore.tr,
                                      SizeConfig.blockSizeHorizontal * 3.2,
                                      colorBlack),
                                ),
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
                                child: Obx(
                                  () => controller.isHost.value == true
                                      ? InkWell(
                                          onTap: () {
                                            Get.to(() => FollowRequestsScreen(
                                                controller.userData.value.userId
                                                    .toString(),
                                                controller
                                                    .followRequests.value, controller.uid.value, controller.streamingRequestsList.value));
                                          },
                                          child: headingText(
                                              "${receiveARequest.tr}(${controller.streamingRequestsList.length > 0 ? controller.streamingRequestsList.length : 0})",
                                              SizeConfig.blockSizeHorizontal *
                                                  3.2,
                                              colorBlack),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            controller.followButtonClick(
                                                controller.userData.value);
                                          },
                                          child: headingText(
                                              controller.followText.value,
                                              SizeConfig.blockSizeHorizontal *
                                                  3.2,
                                              colorBlack),
                                        ),
                                ),
                              ),
                            ),
                            Obx(
                              () => InkWell(
                                onTap: () {
                                  Get.to(() => MyClientsScreen(
                                      controller.userData.value.userId
                                          .toString(),
                                      controller.myClientsList.value));
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
                                    child: headingText(
                                        '${myClients.tr}(${controller.myClientsList.length > 0 ? controller.myClientsList.length : 0})',
                                        SizeConfig.blockSizeHorizontal * 3.2,
                                        colorBlack),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => ProfileScreen(
                                    controller.userData.value,
                                    controller.enableTextField.value));
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
                                  child: headingText(
                                      myProfile.tr,
                                      SizeConfig.blockSizeHorizontal * 3.2,
                                      colorBlack),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 0.5,
                        ),
                      Container(
                            height: SizeConfig.screenHeight - 170,
                            decoration: BoxDecoration(border: Border.all()),
                            child: Obx(() => controller.isLoadingVideoView.value == true &&
                                controller.isHost.value == true || controller.users.length > 0 ? _viewRows() : controller.isLoadingVideoView.value == true &&
                                controller.isHost.value == false || controller.users.length > 0
                                ? AgoraVideoView(
                              controller: VideoViewController.remote(
                                rtcEngine: controller.agoraEngine.value,
                                canvas: VideoCanvas(uid: controller.remoteUid.value),
                                connection: RtcConnection(channelId: controller.channelName),
                              ),
                            )
                                : commonLoader())),
                     Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 2,
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
                                    controller:
                                        controller.messageController.value,
                                    cursorColor: colorRed,
                                    maxLines: 1,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    style: const TextStyle(color: colorBlack),
                                    decoration: InputDecoration(
                                      hintText: enter.tr,
                                      hintStyle:
                                          const TextStyle(color: colorGrey),
                                      filled: true,
                                      border: InputBorder.none,
                                    /* prefixIcon: InkWell(
                                        onTap: () {
                                          // controller.openGallery();
                                        },
                                        child: Container(git
                                          width:
                                              SizeConfig.blockSizeVertical * 1,
                                          height:
                                              SizeConfig.blockSizeVertical * 1,
                                          margin: const EdgeInsets.all(5),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              attachment,
                                              width:
                                                  SizeConfig.blockSizeVertical *
                                                      3,
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      3,
                                            ),
                                          ),
                                        ),
                                      ),*/
                                      fillColor: Colors.transparent,
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          controller.sendMessage();
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        },
                                        child: Container(
                                          width:
                                              SizeConfig.blockSizeVertical * 1,
                                          height:
                                              SizeConfig.blockSizeVertical * 1,
                                          margin: const EdgeInsets.all(5),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              sendChat,
                                              width:
                                                  SizeConfig.blockSizeVertical *
                                                      3,
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      3,
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
                      ],
                    ),
                   Obx(
                      () => controller.isLoading.value == true
                          ? Container(
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenHeight,
                              child: Center(child: commonLoader()))
                          : Container(),
                    ),
                Obx(
                      () => controller.chatList.isNotEmpty
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: EdgeInsets.only(top: SizeConfig.screenHeight/1.8),
                                height: 220,
                                child: ListView.builder(
                                  itemCount: controller.chatList.value.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return chatRowItem(
                                        controller.chatList.value[index],
                                        index);
                                  },
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                 Obx(() =>  controller.isHost.value == false ?  Row(
                       children: [
                         const Spacer(),
                         InkWell(
                            onTap: () {
                              controller.sendLiveStreamingRequest();

                            },
                            child: Container(
                              width: 110,
                              margin: const EdgeInsets.only(top: 60, right: 15),
                              decoration: BoxDecoration(
                                color: colorLightGreyBg,
                                border: Border.all(
                                  color: colorBlack,
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: headingText(
                                      sendARequest.tr,
                                      SizeConfig.blockSizeHorizontal * 3.2,
                                      colorBlack),
                                ),
                              ),
                            ),
                          ),
                       ],
                     ): Container(),),
                  ],
                )
              ),
            ),
          ),
        ));
  }

  Widget chatRowItem(ChatModel chatList, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: SizeConfig.blockSizeHorizontal * 25,
                child: headingText(" ${chatList.name.toString()} : ",
                    SizeConfig.blockSizeHorizontal * 3.8, chatList.color,
                    weight: FontWeight.w700),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 3,
              ),
              Expanded(
                child: Text(
                  chatList.message.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                      fontSize: SizeConfig.blockSizeHorizontal * 3.8),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 5,
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

/*  Widget _videoPanel() {
    return Obx(() => controller.isLoadingVideoView.value == true &&
            controller.isHost.value == true
        ?
        // Show local video preview
        AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: controller.agoraEngine.value,
              canvas: VideoCanvas(uid: 0),
            ),
          )
        :
        // Show remote video

        controller.isLoadingVideoView.value == true &&
                controller.isHost.value == false
            ? AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: controller.agoraEngine.value,
                  canvas: VideoCanvas(uid: controller.remoteUid.value),
                  connection: RtcConnection(channelId: controller.channelName),
                ),
              )
            : commonLoader());
  }*/

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3))
              ],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4))
              ],
            ));
      default:
    }
    return Container();
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: controller.agoraEngine.value,
        canvas: VideoCanvas(uid: 0),
      ),),);
    controller.users.value.forEach((int uid) => list.add(AgoraVideoView(
      controller: VideoViewController(
          rtcEngine: controller.agoraEngine.value,
          canvas: VideoCanvas(uid: uid),
      ),),),);
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }
}
