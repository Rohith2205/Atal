import 'package:atl_membership/screens/resources_screen.dart';
import 'package:flutter/material.dart';


class Resourcesscreen extends StatelessWidget {
  const Resourcesscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: const Text('Resources',
            style: TextStyle(fontWeight: FontWeight.bold,),),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
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
            _buildButton(context, 'About ATL Curriculum', () {
            }),
            const SizedBox(height: 15),
            _buildButton(context, 'Resources', () {
            }),
            const SizedBox(height: 15),
            _buildButton(context, 'Modules', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Resources_screen()),
              );
            }),

          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black12),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}