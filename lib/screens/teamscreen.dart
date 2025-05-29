import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Teamscreen extends StatelessWidget {
  const Teamscreen({super.key});

  Future<Map<String, dynamic>> fetchDataWithDelay() async {
    // Simulate a 3-second delay
    await Future.delayed(const Duration(seconds: 3));

    // Simulate successful JSON data
    final Map<String, dynamic> jsonData = {
      'id': 1,
      'name': 'Simulated User',
      'email': 'user@example.com',
      'message': 'This data was fetched after a 3-second delay for Flutter!',
      'timestamp': DateTime.now().toIso8601String(),
      'team_members': [ // Added simulated team members data
        {'member_id': 'user_001', 'username': 'Alice'},
        {'member_id': 'user_002', 'username': 'Bob'},
        {'member_id': 'user_003', 'username': 'Charlie'},
      ]
    };
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.transparent,
          leading:IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back,color: Colors.black,size: 40,)) ,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/images/Emblem_of_Andhra_Pradesh.png'),height: 200,width: 200,),
                Text('YOUR TEAM',style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('XY123456',style: TextStyle(color: Colors.white,fontSize: 36),),
                      ),
                    ),
                    IconButton(onPressed: (){
                      Clipboard.setData(
                        //todo: change the clipboard data to the fetched team code
                          ClipboardData(text: 'sample team code : XXYY123'));
                      Get.showSnackbar(
                          GetSnackBar(message: "Code copied to clip board ",duration: Duration(seconds: 4),)
                      );
                    }, icon: Icon(Icons.copy))
                  ],
                ),
                    Text('Share this code to make\n your friends join your team'),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: Get.width/1.25,
                      height: 1,
                      color: Colors.black,
                    ),
                FutureBuilder(
                  future: fetchDataWithDelay(),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for the Future to complete
                      return Column(
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Loading team members...',
                            style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    } else if (asyncSnapshot.hasError) {
                      // If the Future completed with an error
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 60),
                          const SizedBox(height: 10),
                          Text(
                            'Error loading team: ${asyncSnapshot.error}',
                            style: const TextStyle(fontSize: 18, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Please check your connection and try again.',
                            style: TextStyle(fontSize: 16, color: Colors.redAccent),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    } else if (asyncSnapshot.hasData) {
                      // If the Future completed successfully and has data
                      final data = asyncSnapshot.data!;
                      final List<dynamic> teamMembers = data['team_members'] ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Align text to start
                        children: <Widget>[
                          const Text(
                            'Team members:',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          if (teamMembers.isEmpty)
                            const Text(
                              'No team members found.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            )
                          else
                            SizedBox(
                              height: Get.height/10,
                              child: Expanded( // Use Expanded for ListView.builder to fill remaining space
                                child: ListView.builder(
                                  padding: EdgeInsets.only(left: Get.width/3.5),
                                  itemCount: teamMembers.length,
                                  itemBuilder: (context, index) {
                                    final member = teamMembers[index];
                                    return Text("${index+1}. ${teamMembers[index]['username']}",style: TextStyle(fontSize: 16),);
                                  },
                                ),
                              ),
                            ),
                          OutlinedButton(style:OutlinedButton.styleFrom(backgroundColor: Colors.red.shade400),onPressed: (){}, child: Text('Leave Group',style: TextStyle(color: Colors.white),))
                        ],
                      );
                    } else {
                      // Fallback for any other state (e.g., no data yet, but not waiting or error)
                      return const Text('No team data available.');
                    }
                  }
                ),
              ],

            ),
          ),
        )
      ),
    );
  }
}
