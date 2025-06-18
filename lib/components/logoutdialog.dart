import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/controllers/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void logoutDialog(AuthController authController,BuildContext context){
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text('Logout'),
        content: Text('${authController.userName.value}!! \n Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: (){Get.back(closeOverlays: true);}, child: Text('cancel')),
          TextButton(onPressed: ()=>{
            Get.back(closeOverlays: true),
            Amplify.Auth.signOut()}, child: Text('logout'))
        ],
      );
    },
  );
}
