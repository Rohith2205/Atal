import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/carousel.dart';


class Aboutscreen extends StatelessWidget {
  const Aboutscreen({super.key});

  Future<void> _launchPDF(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading:IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
        title: Text(
          'About ATL Mentorship',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600 ,color: Colors.white),

        ),

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'With a vision to ‘Cultivate one Million children in India as Neoteric Innovators’, Atal Innovation Mission is establishing Atal Tinkering Laboratories (ATLs) in schools across India. The objective of this scheme is to foster curiosity, creativity, and imagination in young minds; and inculcate skills such as design mindset, computational thinking, adaptive learning, physical computing etc.',
              style: TextStyle(fontSize: 16),
              textAlign:TextAlign.left,

            ),
            const SizedBox(height: 20),
            Carousel(
              imagePaths: const [
                'assets/images/home1.png',
                'assets/images/home2.png',
                'assets/images/home3.png',
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'ATL is a workspace where young minds can give shape to their ideas through hands on do-it-yourself mode; and learn innovation skills. Young children will get a chance to work with tools and equipment to understand the concepts of STEM (Science, Technology, Engineering and Math). ATL would contain educational and learning ‘do it yourself’ kits and equipment on – science, electronics, robotics, open-source microcontroller boards, sensors and 3D printers and computers. Other desirable facilities include meeting rooms and video conferencing facility.',
              style: TextStyle(fontSize: 16),
              textAlign:TextAlign.left,
            ),
            const SizedBox(height: 10),
            const Text(
              'In order to foster inventiveness among students, ATL can conduct different activities ranging from regional and national level competitions, exhibitions, workshops on problem solving, designing and fabrication of products, lecture series etc. at periodic intervals.',
              style: TextStyle(fontSize: 16),
              textAlign:TextAlign.left,
            ),
            const SizedBox(height: 20),
            const Text(
              'ATL Objectives',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. To create workspaces where young minds can learn innovation skills, sculpt ideas through hands-on activities, work and learn in a flexible environment.\n'
                  '2. To empower our youth with the 21 century skills of creativity, innovation, critical thinking, design thinking, social and cross-cultural collaboration, ethical leadership and so on.\n'
                  '3. To help build innovative solutions for India’s unique problems and thereby support India’s efforts to grow as a knowledge economy.',
              style: TextStyle(fontSize: 16),
              textAlign:TextAlign.left,
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ATL Guidelines Button
                SizedBox(
                  height:40,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => _launchPDF("https://aim.gov.in/pdf/ATL-Guidebook.pdf"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('ATL Guidelines'),
                  ),
                ),
                const SizedBox(height: 10),
                // ATL Calendar Button
                SizedBox(
                  height:40,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => _launchPDF("https://aim.gov.in/pdf/ATL-calendar-2025.pdf"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('ATL Calendar'),
                  ),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}