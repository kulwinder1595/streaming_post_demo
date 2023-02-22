import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:streaming_post_demo/main_screen/main_screen.dart';

import 'constants/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: appColor,
        backgroundColor: colorWhite,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 12.0),
        ),
      ),
      home: MainScreen()));
}