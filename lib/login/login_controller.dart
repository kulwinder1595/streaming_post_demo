import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:streaming_post_demo/common/widgets.dart';
import 'package:streaming_post_demo/constants/storage_constants.dart';

import '../constants/string_constants.dart';
import '../main_screen/ui/main_screen.dart';

class LoginController extends GetxController {
  final nameController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final otpController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var otpVerificationId = "".obs;
  final storage = GetStorage();

  otpVerfication() async {
    isLoading.value = true;
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
      verificationId: otpVerificationId.value,
      smsCode: otpController.value.text,
    )).then((result) {
      FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
        "id": result.user!.uid,
        "userId": result.user!.uid,
        "username": nameController.value.text,
        "phoneNumber": phoneController.value.text,
        "password": passwordController.value.text,
        "profileImage": "",
        "age": "",
        "state": "",
        "nationality": "",
        "web": "",
        "email": "",
        "store": "",
        "videos": [],
      }, SetOptions(merge: true))
          .then((res) {
        isLoading.value = false;

        Get.to(() => MainScreen());
        storage.write(userId, result.user!.uid);
        storage.write(userName, nameController.value.text);

        showMessage("${loginSuccessfully.tr} \nHello ${nameController.value.text}");
        nameController.value.text = "";
        phoneController.value.text = "";
        passwordController.value.text = "";
        isOtpSent.value = false;
      });
    }).catchError((err) {
      isLoading.value = false;
      showMessage("Login error ${err.message}");
      showDebugPrint("Login error -->  ${err.message}");

    });
  }

  Future<void> loginToFirebase() async {
    if(nameController.value.text.isEmpty){
      showMessage(enterYourName.tr);
    }else if(phoneController.value.text.isEmpty){
      showMessage(enterYourPhoneNumber.tr);
    }else if(!phoneController.value.text.contains("+")){
      showMessage(enterYourCountryCodeBeforePhoneNumber.tr);

    }else if(passwordController.value.text.isEmpty){
      showMessage(enterYourPassword.tr);
    }else {
      isLoading.value = true;

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneController.value.text,
        codeSent: (String verificationId, int? resendToken) async {
          isLoading.value = false;
          isOtpSent.value = true;
          otpVerificationId.value = verificationId;
        },
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          showDebugPrint("Complete -> ${phoneAuthCredential.verificationId}");
        },
        verificationFailed: (FirebaseAuthException error) {
          showDebugPrint("failed -> ${error}");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          showDebugPrint("timeout -> ${verificationId}");
        },
      );
    }
  }
}
