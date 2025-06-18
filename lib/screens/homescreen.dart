import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/AnnouncementsSection.dart';
import '../components/OfflineBanner.dart';
import '../components/SocialMediaSection.dart';
import '../components/carousel.dart';
import '../controllers/AuthController.dart';
import '../controllers/ConnectivityController.dart';
import '../models/SocialMediaLink.dart';

// class Homescreen extends StatelessWidget {
//   const Homescreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Get the AuthController instance
//     final AuthController authController = Get.put(AuthController());
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Obx(() {
//           // Show loading indicator while data is being fetched
//           if (authController.isLoading.value) {
//             return const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Loading your profile...'),
//                 ],
//               ),
//             );
//           }
//
//           // If dialog should be shown, show empty container (dialog will overlay)
//           if (authController.shouldShowDialog.value) {
//             return const Center(
//               child: Text(
//                 'Please complete your profile to continue',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }
//
//           // Show home screen content when user is properly authenticated
//           return _buildHomeContent();
//         }),
//       ),
//     );
//   }
//
//   Widget _buildHomeContent() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           const SizedBox(height: 25),
//           // Carousel Section
//           AspectRatio(
//             aspectRatio: 16 / 7,
//             child: Carousel(
//               imagePaths: const [
//                 'assets/images/home1.png',
//                 'assets/images/home2.png',
//                 'assets/images/home3.png',
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           // Announcements Section
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Text(
//                   'Announcements',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 15),
//
//               // Card for "No announcements" text - explicitly white
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Card(
//                   elevation: 10, // Same as social media cards
//                   color: Colors.white, // Explicitly set to white
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 180, // Larger height than social cards
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Text(
//                           'No announcements\nannounced yet',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.grey,
//                             height: 1.5,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 30),
//
//           // "Also visit us on" Section
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Text(
//                   'Also visit us on',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 15),
//
//               // Social media cards
//               SizedBox(
//                 height: 90,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   children: [
//                     _buildSocialCard(
//                       imagePath: 'assets/images/youtube.png',
//                       url: 'https://www.youtube.com/channel/UCnqXXpKfrOEK33yTuUGVkiQ',
//                     ),
//                     _buildSocialCard(
//                       imagePath: 'assets/images/instagram.png',
//                       url: 'https://www.instagram.com/AIMToInnovate/',
//                     ),
//                     _buildSocialCard(
//                       imagePath: 'assets/images/facebook.png',
//                       url: 'https://www.facebook.com/AIMToInnovate/',
//                     ),
//
//                     _buildSocialCard(
//                       imagePath: 'assets/images/linkedIn.png',
//                       url: 'https://www.linkedin.com/company/atal-innovation-mission-official/',
//                     ),
//
//                     _buildSocialCard(
//                       imagePath: 'assets/images/twitter.png',
//                       url: 'https://twitter.com/AIMtoInnovate',
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSocialCard({required String imagePath, required String url}) {
//     return GestureDetector(
//       onTap: () => _launchURL(url),
//       child: Card(
//         elevation: 12,
//         color: Colors.white, // Explicitly white
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: SizedBox(
//           width: 85,
//           height: 100,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Image.asset(
//               imagePath,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(Icons.error, color: Colors.grey);
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri)) {
//       throw Exception('Could not launch $url');
//     }
//   }
// }



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final connectivityController = Get.put(ConnectivityController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => _buildBody(authController, connectivityController)),
      ),
    );
  }

  Widget _buildBody(AuthController authController, ConnectivityController connectivityController) {
    if (authController.isLoading.value) {
      return const LoadingView();
    }

    if (authController.shouldShowDialog.value) {
      return const ProfileIncompleteView();
    }

    return HomeContent(connectivityController: connectivityController);
  }
}

// Separate loading view for better readability
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading your profile...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Separate profile incomplete view
class ProfileIncompleteView extends StatelessWidget {
  const ProfileIncompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Please complete your profile to continue',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

// Main home content widget
class HomeContent extends StatelessWidget {
  final ConnectivityController connectivityController;

  const HomeContent({
    super.key,
    required this.connectivityController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 25),
          _buildOfflineBanner(),
          _buildCarousel(),
          const SizedBox(height: 20),
          _buildAnnouncementsSection(),
          const SizedBox(height: 30),
          _buildSocialMediaSection(),
        ],
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Obx(() {
      if (connectivityController.isOnline.value) {
        return const SizedBox.shrink();
      }

      return const OfflineBanner();
    });
  }

  Widget _buildCarousel() {
    return const AspectRatio(
      aspectRatio: 16 / 7,
      child: Carousel(
        imagePaths: [
          'assets/images/home1.png',
          'assets/images/home2.png',
          'assets/images/home3.png',
        ],
      ),
    );
  }

  Widget _buildAnnouncementsSection() {
    return Obx(() => AnnouncementsSection(
      isOnline: connectivityController.isOnline.value,
    ));
  }

  Widget _buildSocialMediaSection() {
    return Obx(() => SocialMediaSection(
      isOnline: connectivityController.isOnline.value,
    ));
  }
}






