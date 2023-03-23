import 'dart:async';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streaming_post_demo/common/widgets.dart';
import 'package:streaming_post_demo/constants/api_endpoints.dart';
import 'package:streaming_post_demo/live_screen/model/live_audience_model.dart';
import 'package:streaming_post_demo/live_screen/model/streaming_request_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/size_config.dart';
import '../../constants/app_colors.dart';
import '../../constants/storage_constants.dart';
import '../../constants/string_constants.dart';
import '../../login/login_screen.dart';
import '../../profile/model/profile_model.dart';
import '../model/chat_model.dart';

class LiveController extends GetxController {
  final messageController = TextEditingController().obs;
  var store = GetStorage();
  var userData =
      ProfileModel("", "", "", "", "", "", "", "", "", "", "", "", []).obs;
  var isLoading = false.obs;
  var userID = "".obs;
  var isLoadingVideoView = false.obs;
  var agoraEngine = createAgoraRtcEngine().obs;
  var uid = 0.obs; // uid of the local user
  var streamingJoiningId = 0.obs;
  var remoteUid = 1.obs; // uid of the remote user
  var isJoined =
      false.obs; // Indicates if the local user has joined the channel
  var isHost = false.obs;
  var groupStreaming = false.obs;
  var streamingUserId = "".obs;

  var enableTextField = true.obs;
  var followText = "".obs;
  var followRequests = <Followers>[].obs;
  var myClientsList = <Followers>[].obs;
  var streamingRequestsList = <StreamingRequestsModel>[].obs;
  var scrollController = ScrollController().obs;
  var channelName = "StreamingPost";
  var streamingToken =
      "007eJxTYDhWctD4Ys6WmN/5FaItyXNff16o4Vh20lqVZ2L7quQFPxQVGNIsLMzTDM1TU00SLUxMjFMtU8wMUg1S0swsjEySk9PMNY1kUhoCGRmOSpxhYWRgZGABYhCfCUwyg0kWMMnLEFxSlJqYm5mXHpBfXMLAAAAa1CXC".obs;
  var chatToken =
      "007eJxTYODIn7b1fujtlZq8q3+8WiX8LdBk2l3XKlf1GRfCN/EJR19WYEizsDBPMzRPTTVJtDAxMU61TDEzSDVISTOzMDJJTk4z/2kok9IQyMjQ9P4gKyMDKwMjEIL4KgwmBolJacYpBrpJaWlpuoaGqSm6iUlmZrrGSUmGKUlplmkWSYYA1/UphA=="
          .obs;
  var chatList = <ChatModel>[].obs;
  var streamingAudienceList = <LiveAudienceModel>[].obs;

  var users = <int>[].obs;
  final _infoStrings = <String>[];


  @override
  onInit() {
    getUserData();
    //if(streamingToken.value == null || streamingToken.value == ""){
      //tokenGeneration();
  //  }

    followText.value = follow.tr;
    initAgoraChatSDK();
    super.onInit();
  }

  void initAgoraChatSDK() async {
    ChatOptions options = ChatOptions(
      appKey: ApiEndPoints.agoraAppKey,
      autoLogin: false,
    );
    await ChatClient.getInstance.init(options);

    signInToAgora(store.read(userName));
    addChatListener();
  }

  void addChatListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );
  }

  void tokenGeneration(){
    streamingToken.value = RtcTokenBuilder.build(
      appId: ApiEndPoints.agoraAppId,
      appCertificate: ApiEndPoints.agoraAppCertificates,
      channelName: channelName,
      uid: "101",
      role: RtcRole.publisher,
      expireTimestamp: 1710397585,
    );

    showDebugPrint("Generated token is -> ------------   ${streamingToken.value}");
  }
  void onMessagesReceived(List<ChatMessage> messages) {
    for (var msg in messages) {
      switch (msg.body.type) {
        case MessageType.TXT:
          {
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;
            _addLogToConsole(
              "receive text message: ${body.content}, from: ${msg.from}",
            );
            chatList
                .add(ChatModel(msg.from.toString(), body.content, colorYellow));
            chatList.refresh();
            Timer(
                const Duration(milliseconds: 500),
                    () => scrollController.value
                    .jumpTo(scrollController.value.position.maxScrollExtent));
          }
          break;
        case MessageType.IMAGE:
          {
            _addLogToConsole(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VIDEO:
          {
            _addLogToConsole(
              "receive video message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.LOCATION:
          {
            _addLogToConsole(
              "receive location message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VOICE:
          {
            _addLogToConsole(
              "receive voice message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.FILE:
          {
            _addLogToConsole(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CUSTOM:
          {
            _addLogToConsole(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CMD:
          {
            // Receiving command messages does not trigger the `onMessagesReceived` event, but triggers the `onCmdMessagesReceived` event instead.
          }
          break;
      }
    }
  }

  void signInToAgora(String userId) async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(
        "101",
        chatToken.value,
      );
      _addLogToConsole("login succeed, userId: $userId");
      joinChatRoom("1234567890");

    } on ChatError catch (e) {
      _addLogToConsole("login failed, code: ${e.code}, desc: ${e.description}");
      //  getAgoraRegisterApi(agoraAppChatToken.value, userId.value);
    }
  //  joinChatRoom("1234567890");
  }

  void sendMessage() async {
    var firstAttempt = true;
    if (messageController.value.text == "") {
      _addLogToConsole("single chat id or message content is null");
      showMessage(enterAChatMessage.tr);
      return;
    } else {
      var msg = ChatMessage.createTxtSendMessage(
          targetId: "101",
          content: messageController.value.text,
          chatType: ChatType.Chat);

      ChatClient.getInstance.chatManager.addMessageEvent(
          "UNIQUE_HANDLER_ID",
          ChatMessageEvent(
            onSuccess: (msgId, msg) {
              _addLogToConsole("send message: ${messageController.value.text}");
              ChatTextMessageBody body = msg.body as ChatTextMessageBody;
              chatList
                  .add(ChatModel(store.read(userName), body.content, colorRed));
              chatList.refresh();
              Timer(
                  const Duration(milliseconds: 500),
                      () => scrollController.value
                      .jumpTo(scrollController.value.position.maxScrollExtent));
              messageController.value.clear();
            },
            onProgress: (msgId, progress) {
              _addLogToConsole("send message succeed");
            },
            onError: (msgId, msg, error) {
              _addLogToConsole(
                "send message failed, code: ${error.code}, desc: ${error.description}",
              );
              if (error.code == 500 && firstAttempt) {
                sendMessage();
                firstAttempt = false;
              }
            },
          ));

      ChatClient.getInstance.chatManager.sendMessage(msg);
    }
  }

  void _addLogToConsole(String log) {
    showDebugPrint("message agora -----------------------   $log");
  }

  Future<void> joinChatRoom(String roomId) async {
    try {
      await ChatClient.getInstance.chatRoomManager.joinChatRoom(roomId);
    } on ChatError catch (e) {
      showDebugPrint("room join failure ---- $e");
    }
  }

  Future<void> leaveChatRoom(String roomId) async {
    try {
      await ChatClient.getInstance.chatRoomManager.leaveChatRoom(roomId);
    } on ChatError catch (e) {
      showDebugPrint("room leave failure ---- $e");
    }
  }

  /* void getAgoraRegisterApi(String appToken, String userId) {
    GoLiveRepo().agoraRegisterUser(appToken, userId).then((value) async {
      if (value.applicationName != "") {
        try {
          await ChatClient.getInstance.loginWithAgoraToken(
           userId,
            chatToken.value,
          );
          _addLogToConsole("login succeed, userId: $userId");
        } on ChatError catch (e) {
          _addLogToConsole("login failed, code: ${e.code}, desc: ${e.description}");
        }
      } else {
        return;
      }
    });
  }*/

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine.value = createAgoraRtcEngine();
    await agoraEngine.value
        .initialize(const RtcEngineContext(appId: ApiEndPoints.agoraAppId));

    Future.delayed(Duration(seconds: 2), () async {
      await agoraEngine.value.enableVideo();

      // Register the event handler
      agoraEngine.value.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            /* showMessage(
                  "Local user uid:${connection.localUid} joined the channel");*/
            showDebugPrint("connection.localUid id is -remoteUid1---------------  ${connection.localUid}");
            uid.value = connection.localUid!;
            isJoined.value = true;
            if (isHost.value == true) {
              streamingUserId.value = userID.value;
              updateLiveStreamingData();
            }
          },
          onUserJoined:
              (RtcConnection connection, int remoteUid1, int elapsed) {
            /* showMessage("Remote user uid:$remoteUid joined the channel");*/
             //   users.add(remoteUid1);
            remoteUid.value = remoteUid1;
            addStreamingAudience();
                showDebugPrint("Remote id is -remoteUid1---------------  ${remoteUid1}");
         //   users.refresh();
          },
          onUserOffline: (RtcConnection connection, int remoteUid1,
              UserOfflineReasonType reason) {
         //   users.clear();
         //   users.refresh();
            /*  showMessage("Remote user uid:$remoteUid left the channel");*/

            remoteUid.value = 1;
          },
        ),
      );
showDebugPrint("Remote id is ----------------  ${remoteUid.value}");
showDebugPrint("uid id is ----------------  ${uid.value}");
      join();
    });
  }

  void join() async {
    // Set channel options
    ChannelMediaOptions options;

    // Set channel profile and client role
    if (isHost.value) {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
      await agoraEngine.value.startPreview();
    } else {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
    }
    isLoadingVideoView.value = true;
    await agoraEngine.value.joinChannel(
      token: streamingToken.value,
      channelId: channelName,
      options: options,
      uid: 0,
    );
    showDebugPrint("-------------check is token is expired--------------");
  }

  void leave() {
    isJoined.value = false;
    remoteUid.value = 1;
    users.clear();
    goOffline();
    agoraEngine.value.leaveChannel();
    agoraEngine.value.release();
  }

  Future<void> backPressButton() async {
    await agoraEngine.value.leaveChannel();
    agoraEngine.value.release();
    leave();
    Get.back();
  }

  void goOffline() {
    FirebaseFirestore.instance
        .collection("live_streaming")
        .doc(userID.value)
        .delete()
        .then((value) {
      showMessage(postDeletedSuccessfully.tr);
      isLoading.value = false;
    });
  }

  Future<void> updateLiveStreamingData() async {
    showDebugPrint("inside the update live streaming data-------------------");
    await FirebaseFirestore.instance
        .collection('live_streaming')
        .doc(userID.value)
        .set({
      "user_id": userID.value,
      "agora_user_id": uid.value,
      "streaming_token": streamingToken.value,
      "streaming_channel": channelName,
      "chat_token": chatToken.value,
      "user_image": userData.value.profileImage,
      "user_name": userData.value.username,
    }, SetOptions(merge: true)).then((res) {
      isLoading.value = false;
      showMessage(dataUpdatedSuccessfully.tr);
    });
  }

 Future<void> addStreamingAudience() async {
   streamingAudienceList.add(LiveAudienceModel(remoteUid.value.toString()));
    await FirebaseFirestore.instance
        .collection('live_audience')
        .doc(userID.value)
        .set({
          "requests": streamingAudienceList.value.map((e) => e.toMap()).toList(),
        }, SetOptions(merge: true)).then((res) {
      isLoading.value = false;
      streamingAudienceList.refresh();
      showMessage(dataUpdatedSuccessfully.tr);
    });
  }

  fetchAudienceData(String userID) async {
    print("fetch user id audience ------------>  $userID");
    fetchFollowingRequests(userID);
    fetchFollowers(userID);
    await FirebaseFirestore.instance
        .collection("live_audience")
        .doc("G2tOqUX8HoVM1CpJAgWATb3Byq62")
        .get()
        .then((value) {
     streamingAudienceList.clear();
     if (value.data() != null && value.data()!['requests'] != null) {
       if (value.data()!['requests'] != null &&
           value.data()!['requests'] != []) {
         for (int j = 0; j < value.data()!['requests'].length; j++) {
           streamingAudienceList.add(LiveAudienceModel(
               value.data()!['requests'][j]['userId']));}
       }
     }
     streamingAudienceList.refresh();
     Future.delayed(Duration(seconds: 2), () {
       if(groupStreaming.value == true){
         print("firebase remote user id ------->  ${streamingAudienceList.value[0].userId.toString()}");
         users.value.add(int.parse(streamingAudienceList.value[0].userId.toString()));
         users.refresh();
       }
     });
    });
  }

 fetchUserData(String userID) async {
    isLoading.value = true;
    fetchFollowingRequests(userID);
    fetchFollowers(userID);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .get()
        .then((value) {
      var videoList = <Videos>[];
      if (value.data() != null && value.data()!['videos'] != null) {
        if (value.data()!['videos'] != null && value.data()!['videos'] != []) {
          for (int j = 0; j < value.data()!['videos'].length; j++) {
            videoList.add(Videos(value.data()!['videos'][j]['video']));
          }
        }
      }
      userData.value.id = value.data() != null ? value.data()!['userId'] : "";
      userData.value.userId =
          value.data() != null ? value.data()!['userId'] : "";
      userData.value.username =
          value.data() != null ? value.data()!['username'] : "";
      userData.value.password =
          value.data() != null ? value.data()!['password'] : "";
      userData.value.phoneNumber =
          value.data() != null ? value.data()!['phoneNumber'] : "";
      userData.value.profileImage =
          value.data() != null ? value.data()!['profileImage'] : "";
      userData.value.age = value.data() != null ? value.data()!['age'] : "";
      userData.value.state = value.data() != null ? value.data()!['state'] : "";
      userData.value.nationality =
          value.data() != null ? value.data()!['nationality'] : "";
      userData.value.web = value.data() != null ? value.data()!['web'] : "";
      userData.value.email = value.data() != null ? value.data()!['email'] : "";
      userData.value.store = value.data() != null ? value.data()!['store'] : "";
      userData.value.videos = videoList;
      userData.refresh();
      isLoading.value = false;
    });
  }

  fetchFollowingRequests(String userID) async {
    await FirebaseFirestore.instance
        .collection("follow_request")
        .doc(userID)
        .get()
        .then((value) {
      if (value.data() != null && value.data()!['requests'] != null) {
        if (value.data()!['requests'] != null &&
            value.data()!['requests'] != []) {
          for (int j = 0; j < value.data()!['requests'].length; j++) {
            followRequests.add(Followers(
                value.data()!['requests'][j]['userId'],
                value.data()!['requests'][j]['username'],
                value.data()!['requests'][j]['userImage'],
                value.data()!['requests'][j]['userCountry']));
          }
        }
      }
      followRequests.refresh();
    });
  }

fetchStreamingRequests(String userID) async {

    await FirebaseFirestore.instance
        .collection("live_streaming_requests")
        .doc(userID)
        .get()
        .then((value) {
      if (value.data() != null && value.data()!['requests'] != null) {
        if (value.data()!['requests'] != null &&
            value.data()!['requests'] != []) {
          for (int j = 0; j < value.data()!['requests'].length; j++) {
            streamingRequestsList.add(StreamingRequestsModel(
                value.data()!['requests'][j]['senderUserId'],
                value.data()!['requests'][j]['receiverUserId'],
                value.data()!['requests'][j]['senderUsername'],
                value.data()!['requests'][j]['senderUserCountry'],
                value.data()!['requests'][j]['senderUserImage'],
                value.data()!['requests'][j]['streamingToken'],
                value.data()!['requests'][j]['streamingChannel'],
                value.data()!['requests'][j]['chatToken'],
            ));
          }
        }
      }
      streamingRequestsList.refresh();
    });
  }

  fetchFollowers(String userID) async {
    showDebugPrint("User id is ---->  $userID");
    await FirebaseFirestore.instance
        .collection("followers")
        .doc(userID)
        .get()
        .then((value) {
      if (value.data() != null && value.data()!['requests'] != null) {
        if (value.data()!['requests'] != null &&
            value.data()!['requests'] != []) {
          for (int j = 0; j < value.data()!['requests'].length; j++) {
            myClientsList.value.add(Followers(
                value.data()!['requests'][j]['userId'],
                value.data()!['requests'][j]['username'],
                value.data()!['requests'][j]['userImage'],
                value.data()!['requests'][j]['userCountry']));
          }
        }
      }
      myClientsList.refresh();
    });
  }

  Future<void> getUserData() async {
    Future.delayed(Duration(seconds: 1), () {
      userID.value = store.read(userId) != null ? store.read(userId) : "";
      showDebugPrint("user id---------->  $userID");
      showDebugPrint("streamingUserId id---------->  $streamingUserId");
      enableTextField.value = isHost.value;
      fetchUserData(
          isHost.value == false ? streamingUserId.value : userID.value);
      if (userID.value != "") {
        setupVideoSDKEngine();
      } else {
        showLoginDialog();
      }
    });
  }

  void showLoginDialog() {
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
                  headingText(pleaseLoginFirstToJoinALive.tr,
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
                            Get.to(() => LoginScreen());
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
                                  ok.tr,
                                  SizeConfig.blockSizeHorizontal * 3.5,
                                  colorBlack,
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

  Future<void> storeButtonClick(String url) async {
    if (url == null || url == "") {
      url = "https://www.google.com/";
    }

    if (!await launchUrl(Uri.parse(url))) {
      showDebugPrint('Could not launch =======');
    }
  }

  followButtonClick(ProfileModel userDetails) {
    showDebugPrint("userid ------------->  ${userID.value}");
    var followerUserid = "";
    var followerUsername = "";
    var followerUserCountry = "";
    var followerUserImage = "";
    FirebaseFirestore.instance
        .collection("users")
        .doc(userID.value)
        .get()
        .then((value) {
      followerUserid = value.data() != null ? value.data()!['userId'] : "";
      followerUsername = value.data() != null ? value.data()!['username'] : "";
      followerUserImage =
          value.data() != null ? value.data()!['profileImage'] : "";
      followerUserCountry =
          value.data() != null ? value.data()!['nationality'] : "";

      followRequests.add(Followers(followerUserid, followerUsername,
          followerUserImage, followerUserCountry));
      FirebaseFirestore.instance
          .collection('follow_request')
          .doc(streamingUserId.value)
          .set({
        "requests": followRequests.value.map((e) => e.toMap()).toList(),
      }, SetOptions(merge: true)).then((res) {
        isLoading.value = false;
        followText.value = "Followed";
        FirebaseFirestore.instance
            .collection('followers')
            .doc(streamingUserId.value)
            .set({
          "requests": followRequests.value.map((e) => e.toMap()).toList(),
        }, SetOptions(merge: true)).then((res) {

          showMessage(dataUpdatedSuccessfully.tr);
        });

      });
    });
  }
}
