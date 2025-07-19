import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ResourceButton.dart';

class ATLCurriculumScreen extends StatelessWidget {
  const ATLCurriculumScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'About ATL Curriculum',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/resources.jpg',
                width: 250,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: 'Level 1',
              onTap: () {
                _launchURL('https://drive.google.com/file/d/1YUBN2qYw_2VabWY5aCPczzwFEOadSSqz/view?usp=sharing');
              },
            ),
            const SizedBox(height: 15),
            CustomButton(
              label: 'Level 2',
              onTap: () {
                _launchURL('https://drive.google.com/file/d/1vJcR2RoeICfDrP_S9hH_5ucD5a6nu1Ee/view?usp=sharing');
              },
            ),
            const SizedBox(height: 15),
            CustomButton(
              label: 'Level 3',
              onTap: () {
                _launchURL('https://drive.google.com/file/d/16ZTatlc7909Mi_zo8kL8munDGRoixK6-/view?usp=sharing');
              },
            ),
          ],
        ),
    );
  }
}