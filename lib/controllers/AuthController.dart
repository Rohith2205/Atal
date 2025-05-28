

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/utils/bgcolorconverter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  RxString userName = ''.obs;
  RxString email = ''.obs;
  RxString phoneNumber = ''.obs;
  Rx<Color> profileColor = Color(0xFF000000).obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    AuthUser user = await Amplify.Auth.getCurrentUser();
    userName.value = user.username;
    var attribs = await Amplify.Auth.fetchUserAttributes();
    for (final element in attribs) {
      safePrint('key: ${element.userAttributeKey}; value: ${element.value}');
    }


  }
  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    profileColor.value = await getColorFromStringAsync(userName.value);

  }
}