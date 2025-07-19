import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/controllers/AuthController.dart';
import 'package:atl_membership/controllers/UserTableController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../services/user_table_amplify_service.dart';
import '../utils/routes.dart';

class Policyscreen extends StatefulWidget {
  const Policyscreen({super.key});

  @override
  State<Policyscreen> createState() => _PolicyscreenState();
}

class _PolicyscreenState extends State<Policyscreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  )),
              title: const Text(
                'About ATL Mentorship',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
            body: const PolicyDialog()));
  }
}

class PolicyDialog extends StatefulWidget {
  const PolicyDialog({super.key});

  @override
  State<PolicyDialog> createState() => _PolicyDialogState();
}

class _PolicyDialogState extends State<PolicyDialog> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  late UserController _userController;
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _userController = Get.find<UserController>();
    _authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    super.dispose();
    _pdfViewerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
            height: Get.height / 1.5,
            width: Get.width,
            child: SfPdfViewer.asset('assets/pdfs/ChildProtectionPolicy.pdf',
                controller: _pdfViewerController)),
        Obx(
              () => OutlinedButton(
              onPressed: _userController.isPolicyAccepted.value == true
                  ? null
                  : () async {
                await _handlePolicyAcceptance();
              },
              style: OutlinedButton.styleFrom(
                  backgroundColor:
                  _userController.isPolicyAccepted.value == false
                      ? Colors.blue
                      : Colors.grey),
              child: Text(
                _userController.isPolicyAccepted.value == false
                    ? "I Agree"
                    : "Accepted",
                style: const TextStyle(color: Colors.white),
              )),
        )
      ],
    );
  }

  Future<void> _handlePolicyAcceptance() async {
    try {
      if (_userController.isPolicyAccepted.value != true) {
        final success = await _userController.acceptPolicy();
        if (success) {
          _userController.shouldShowDialog.value = false;

          // Call onPolicyAccepted() when user accepts the policy
          await _authController.onPolicyAccepted();

          await _authController.onPersonalDetailsCompleted();
          Get.offAllNamed(Routes.HOME);
          Get.snackbar(
            'Success',
            'Welcome! Your profile has been completed.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.7),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        } else {
          // Handle policy acceptance failure
          Get.snackbar(
            'Error',
            'Failed to accept policy. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      safePrint('Error accepting policy: $e');
      Get.snackbar(
        'Error',
        'An error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }
}