import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/carousel.dart';


class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25),
              // Carousel Section
              AspectRatio(
                aspectRatio: 16 / 7,
                child: Carousel(
                  imagePaths: const [
                    'assets/images/home1.png',
                    'assets/images/home2.png',
                    'assets/images/home3.png',
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Announcements Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Announcements',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Card for "No announcements" text - explicitly white
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Card(
                      elevation: 10, // Same as social media cards
                      color: Colors.white, // Explicitly set to white
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 180, // Larger height than social cards
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'No announcements\nannounced yet',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // "Also visit us on" Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Also visit us on',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Social media cards
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildSocialCard(
                          imagePath: 'assets/images/youtube.png',
                          url: 'https://www.youtube.com/channel/UCnqXXpKfrOEK33yTuUGVkiQ',
                        ),
                        _buildSocialCard(
                          imagePath: 'assets/images/instagram.png',
                          url: 'https://www.instagram.com/AIMToInnovate/',
                        ),
                        _buildSocialCard(
                          imagePath: 'assets/images/facebook.png',
                          url: 'https://www.facebook.com/AIMToInnovate/',
                        ),

                        _buildSocialCard(
                          imagePath: 'assets/images/linkedIn.png',
                          url: 'https://www.linkedin.com/company/atal-innovation-mission-official/',
                        ),

                        _buildSocialCard(
                          imagePath: 'assets/images/twitter.png',
                          url: 'https://twitter.com/AIMtoInnovate',
                        ),
                      ],
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialCard({required String imagePath, required String url}) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Card(
        elevation: 12,
        color: Colors.white, // Explicitly white
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: 85,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.grey);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}