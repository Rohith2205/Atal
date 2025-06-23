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
      'team_members': [
        {'member_id': 'user_001', 'username': 'Alice'},
        {'member_id': 'user_002', 'username': 'Bob'},
        {'member_id': 'user_003', 'username': 'Charlie'},
      ]
    };
    return jsonData;
  }

  void showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Leave Current Team",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Are you sure you want to leave the current team?",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate back to previous screen or HomeScreen using GetX
                Get.offAllNamed('/home'); // Replace with your home route if needed
              },
              child: const Text(
                "Leave",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 40),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              // Replace spacing (which is invalid on Column) with SizedBox for spacing
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(
                  image:
                  const AssetImage('assets/images/Emblem_of_Andhra_Pradesh.png'),
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'YOUR TEAM',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue, borderRadius: BorderRadius.circular(6)),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'XY123456',
                          style: TextStyle(color: Colors.white, fontSize: 36),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          const ClipboardData(text: 'XY123456'), // use actual code here
                        );
                        Get.showSnackbar(
                          const GetSnackBar(
                            message: "Code copied to clipboard",
                            duration: Duration(seconds: 4),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Share this code to make\n your friends join your team',
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: Get.width / 1.25,
                  height: 1,
                  color: Colors.black,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: fetchDataWithDelay(),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                        // While waiting for the Future to complete
                        return Column(
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Team members:',
                              style:
                              TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            if (teamMembers.isEmpty)
                              const Text(
                                'No team members found.',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              )
                            else
                              SizedBox(
                                height: Get.height / 10,
                                child: ListView.builder(
                                  padding: EdgeInsets.only(left: Get.width / 3.5),
                                  itemCount: teamMembers.length,
                                  itemBuilder: (context, index) {
                                    final member = teamMembers[index];
                                    return Text(
                                      "${index + 1}. ${member['username']}",
                                      style: const TextStyle(fontSize: 16),
                                    );
                                  },
                                ),
                              ),
                            const SizedBox(height: 20),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.red.shade400),
                              onPressed: () => showLeaveDialog(context),
                              child: const Text(
                                'Leave Group',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        );
                      } else {
                        // Fallback for any other state
                        return const Text('No team data available.');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
