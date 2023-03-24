import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:streaming_post_demo/common/widgets.dart';
import 'package:streaming_post_demo/constants/string_constants.dart';
import 'package:streaming_post_demo/main_screen/ui/main_screen.dart';

import '../constants/storage_constants.dart';

class RegisterController extends GetxController{
  final nameController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final otpController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var otpVerificationId = "".obs;
  var storage = GetStorage();

  @override
  Future<void> onInit() async {
    await Firebase.initializeApp;
    super.onInit();
  }

otpVerfication() async {
  isLoading.value = true;
  await FirebaseAuth.instance
      .signInWithCredential(PhoneAuthProvider.credential(
    verificationId: otpVerificationId.value,
    smsCode: otpController.value.text,
  )).then((result) {
    FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set(
        {
          "name": nameController.value.text,
          "phone_number": phoneController.value.text,
          "password": passwordController.value.text,
        })
   .then((res) {
      isLoading.value = false;

      Get.to(() => MainScreen());
      storage.write(userId, result.user!.uid);
      storage.write(userName, nameController.value.text);
      storage.write(userCountry, "");
      storage.write(userImage, "");

      showMessage("${registerSuccessfully.tr} \nHello ${nameController.value.text}");
      nameController.value.text = "";
      phoneController.value.text = "";
      passwordController.value.text = "";
      isOtpSent.value = false;
    });
  }).catchError((err) {
    isLoading.value = false;
    showMessage("Register error ${err.message}");
    showDebugPrint("Register error -->  ${err.message}");

  });;
}

  Future<void> registerToFirebase() async {
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