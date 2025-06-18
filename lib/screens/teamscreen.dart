import 'dart:async';
import 'package:atl_membership/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Teamscreen extends StatelessWidget {
  const Teamscreen({super.key});

  Future<Map<String, dynamic>> fetchDataWithDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    return {
      'id': 1,
      'name': 'Simulated User',
      'email': 'user@example.com',
      'message': 'This data was fetched after a 3-second delay for Flutter!',
      'timestamp': DateTime.now().toIso8601String(),
      'team_members': [
        {'member_id': 'user_001', 'username': 'Bhargavi'},
        {'member_id': 'user_002', 'username': 'Pushpa'},
        {'member_id': 'user_003', 'username': 'Saida Rao'},
      ]
    };
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
                "Username!!",
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
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
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false,
                );
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // AppBar replacement with back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.black, size: 30),
                      ),
                    ],
                  ),
                ),

                // Team avatar
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.group,
                      size: 100, color: Colors.white),
                ),

                const SizedBox(height: 20),

                // Team title
                const Text(
                  'YOUR TEAM',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Team code section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'XY123456',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          const ClipboardData(text: 'XY123456'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Team code copied to clipboard"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Share instruction text
                const Text(
                  'Share this code with your friends\nto join your team',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),

                // Divider
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 1,
                  color: Colors.black.withOpacity(0.2),
                ),

                const SizedBox(height: 20),

                // Team members section
                FutureBuilder(
                  future: fetchDataWithDelay(),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Loading team members...',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      );
                    } else if (asyncSnapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 60),
                            const SizedBox(height: 10),
                            Text(
                              'Error loading team: ${asyncSnapshot.error}',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Please check your connection and try again.',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.redAccent),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else if (asyncSnapshot.hasData) {
                      final data = asyncSnapshot.data!;
                      final List<dynamic> teamMembers =
                          data['team_members'] ?? [];

                      return Column(
                        children: [
                          const Text(
                            'Team Members',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (teamMembers.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'No team members found.',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            )
                          else
                            Column(
                              children:
                              List.generate(teamMembers.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 20),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      teamMembers[index]['username'],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => showLeaveDialog(context),
                              child: const Text(
                                'Leave Group',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text('No team data available.'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}