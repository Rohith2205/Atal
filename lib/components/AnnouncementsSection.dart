
// Announcements section component
import 'package:flutter/material.dart';



class AnnouncementsSection extends StatelessWidget {
  final bool isOnline;

  const AnnouncementsSection({
    super.key,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Announcements'),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildAnnouncementCard(),
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard() {
    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isOnline ? _buildOnlineContent() : _buildOfflineContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineContent() {
    return const Text(
      'No announcements\nannounced yet',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: Colors.grey,
        height: 1.5,
      ),
    );
  }

  Widget _buildOfflineContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.announcement_outlined,
          size: 48,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 12),
        Text(
          'Announcements unavailable offline',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Connect to internet to view latest announcements',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
      ],
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

