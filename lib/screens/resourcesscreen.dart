import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Resourcesscreen extends StatelessWidget {
  const Resourcesscreen({super.key});

  final List<Map<String, String>> modules = const [
    {
      "title": "ATL Introduction",
      "image": "assets/images/module_1.png",
      "url": "https://aim.gov.in/pdf/Introduction_to_Atal_Tinkering_Lab.pdf"
    },
    {
      "title": "Basics of Electronics",
      "image": "assets/images/module 2.png",
      "url": "https://sites.google.com/view/basic-of-electronics"
    },
    {
      "title": "Sensors & Actuators",
      "image": "assets/images/module 3.png",
      "url": "https://sites.google.com/view/sensor-actuator"
    },
    {
      "title": "Computational Thinking",
      "image": "assets/images/module 4.png",
      "url": "https://sites.google.com/view/computationalthinkingintro/introduction"
    },
    {
      "title": "Breadboard & PCB",
      "image": "assets/images/module 5.png",
      "url": "https://sites.google.com/view/breadboard-and-pcb/breadboard-and-pcb"
    },
    {
      "title": "Arduino Intro",
      "image": "assets/images/module 6.png",
      "url": "https://sites.google.com/view/arduino-introduction/what-is-arduino"
    },
    {
      "title": "3D Printing",
      "image": "assets/images/module 7.png",
      "url": "https://sites.google.com/view/3d-printing-process"
    },
    {
      "title": "Tools",
      "image": "assets/images/module 8.png",
      "url": "https://sites.google.com/view/tools-in-atl"
    },
    {
      "title": "Design Thinking",
      "image": "assets/images/module 9.png",
      "url": "https://sites.google.com/view/design-thinking-stages"
    },
    {
      "title": "Raspberry Pi",
      "image": "assets/images/module 10.png",
      "url": "https://sites.google.com/view/r-pi"
    },
    {
      "title": "Business Pitch",
      "image": "assets/images/module 11.png",
      "url": "https://sites.google.com/view/business-pitch"
    },
    {
      "title": "ATL Modules",
      "image": "assets/images/module 12.png",
      "url": "https://sites.google.com/view/atllearningmodules"
    },
    {
      "title": "Safety",
      "image": "assets/images/module 13.png",
      "url": "https://sites.google.com/view/understanding-safety"
    },
    {
      "title": "Trainer Slides",
      "image": "assets/images/module 14.png",
      "url": "https://sites.google.com/view/master-training"
    },
  ];

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : 3;

    return Scaffold(
      backgroundColor: const Color(0xffeef1f5),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: modules.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final item = modules[index];
                  return GestureDetector(
                    onTap: () => _launchURL(item['url']!),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}