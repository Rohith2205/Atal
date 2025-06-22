import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/AnnouncementsSection.dart';
import '../components/OfflineBanner.dart';
import '../components/SocialMediaSection.dart';
import '../components/carousel.dart';
import '../controllers/AuthController.dart';
import '../controllers/ConnectivityController.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final authController = Get.find<AuthController>();
    final connectivityController = Get.find<ConnectivityController>();

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

    if (authController.userController.shouldShowDialog.value) {
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






