

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
    var attribs = await Amplify.Auth.fetchUserAttributes();
    email.value = attribs[0].value;
    phoneNumber.value = attribs[2].value;
    userName.value = attribs[4].value;
    profileColor.value = await getColorFromStringAsync(userName.value);
  }
}