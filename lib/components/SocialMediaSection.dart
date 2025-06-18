// Social media section component
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/SocialMediaLink.dart';

class SocialMediaSection extends StatelessWidget {
  final bool isOnline;

  const SocialMediaSection({
    super.key,
    required this.isOnline,
  });

  static final List<SocialMediaLink> _socialLinks = [
    SocialMediaLink(
      name: 'YouTube',
      imagePath: 'assets/images/youtube.png',
      url: 'https://www.youtube.com/channel/UCnqXXpKfrOEK33yTuUGVkiQ',
    ),
    SocialMediaLink(
      name: 'Instagram',
      imagePath: 'assets/images/instagram.png',
      url: 'https://www.instagram.com/AIMToInnovate/',
    ),
    SocialMediaLink(
      name: 'Facebook',
      imagePath: 'assets/images/facebook.png',
      url: 'https://www.facebook.com/AIMToInnovate/',
    ),
    SocialMediaLink(
      name: 'LinkedIn',
      imagePath: 'assets/images/linkedIn.png',
      url: 'https://www.linkedin.com/company/atal-innovation-mission-official/',
    ),
    SocialMediaLink(
      name: 'Twitter',
      imagePath: 'assets/images/twitter.png',
      url: 'https://twitter.com/AIMtoInnovate',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Also visit us on'),
        const SizedBox(height: 15),
        _buildSocialMediaCards(),
      ],
    );
  }

  Widget _buildSocialMediaCards() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _socialLinks.length,
        itemBuilder: (context, index) {
          return SocialMediaCard(
            link: _socialLinks[index],
            isOnline: isOnline,
          );
        },
      ),
    );
  }
}

// Reusable section title widget
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

// Social media card component
class SocialMediaCard extends StatelessWidget {
  final SocialMediaLink link;
  final bool isOnline;

  const SocialMediaCard({
    super.key,
    required this.link,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(),
      child: Card(
        elevation: 12,
        color: Colors.white,
        margin: const EdgeInsets.only(right: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            _buildCardContent(),
            if (!isOnline) _buildOfflineIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return SizedBox(
      width: 85,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ColorFiltered(
          colorFilter: isOnline
              ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
              : ColorFilter.mode(Colors.transparent, BlendMode.saturation),
          child: Image.asset(
            link.imagePath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, color: Colors.grey);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOfflineIndicator() {
    return Positioned(
      top: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.wifi_off,
          size: 12,
          color: Colors.red.shade600,
        ),
      ),
    );
  }

  void _handleTap() {
    if (isOnline) {
      _launchURL(link.url);
    } else {
      _showOfflineMessage();
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open ${link.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade700,
      );
    }
  }

  void _showOfflineMessage() {
    Get.snackbar(
      'Offline',
      'Connect to internet to visit ${link.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.orange.shade700,
      icon: Icon(Icons.wifi_off, color: Colors.orange.shade700),
      duration: const Duration(seconds: 2),
    );
  }
}