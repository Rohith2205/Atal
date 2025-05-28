import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: SignOutButton());
  }
}
