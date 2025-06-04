import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Achievementsscreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEEF1F5),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading:IconButton(onPressed: (){
            Get.back();
          }, icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
          title: const Text('Achievements',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600 ,color: Colors.white)
          ),
        ),
        body: Column(
          children: [

            const SizedBox(height: 20,),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset('assets/images/Group.png'),

              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Material(
            //     color: Colors.white,
            //     elevation: 4,
            //     child: ListTile(
            //       leading: const Icon(Icons.emoji_events_outlined),
            //       title: const Text('certificate of appreciation'),
            //       trailing: const Icon(Icons.download),
            //       onTap: () {
            //         // Add download logic
            //       },
            //     ),
            //   ),
            // ),

            const SizedBox(height: 20,),
            const Center(
                child: Text('Certificates not available yet.')
            )

          ],

        )
    );
  }
}