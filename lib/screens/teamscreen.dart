import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Teamscreen extends StatelessWidget {
  const Teamscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('My Team')
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
