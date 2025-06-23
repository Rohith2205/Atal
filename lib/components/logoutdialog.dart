import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/controllers/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void logoutDialog(AuthController authController,BuildContext context){
  showDialog(
    // barrierDismissible: false,
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text('Logout'),
        content: Obx(()=> Text('${authController.userController.userName.value}!! \n Are you sure you want to logout?')),
        actions: [
          TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('cancel')),
          TextButton(onPressed: ()=>{
            Navigator.of(context).pop(),
            Amplify.Auth.signOut()}, child: Text('logout'))
        ],
      );
    },
  );
}
