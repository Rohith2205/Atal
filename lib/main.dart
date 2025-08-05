import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:atl_membership/firebase_options.dart';
import 'package:atl_membership/screens/myappscreen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'amplify_outputs.dart';
import 'models/ModelProvider.dart';

bool amplifyConfigured = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    await _configureAmplify();

    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(),
      ),
    );
  } on AmplifyException catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Error configuring Amplify: ${e.message}")),
      ),
    ));
  }
}

Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    final api = AmplifyAPI(
      options: APIPluginOptions(modelProvider: ModelProvider.instance),
    );

    // Only Auth + API
    await Amplify.addPlugins([auth, api]);
    await Amplify.configure(amplifyConfig);

    amplifyConfigured = true;
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: FlutterSplashScreen(
        duration: const Duration(milliseconds: 2000),
        nextScreen: const Sign(), // your SignIn screen
        backgroundColor: Colors.white,
        setStateTimer: const Duration(seconds: 6),
        splashScreenBody: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 200,
                child: Image.asset('assets/images/Emblem_of_Andhra_Pradesh.png'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ATL Mentorship',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
