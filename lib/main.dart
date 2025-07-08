import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:atl_membership/firebase_options.dart';
import 'package:atl_membership/screens/myappscreen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/services.dart';
import 'amplify_outputs.dart';
import 'models/ModelProvider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  try {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent
      )
    );
    await _configureAmplify();
    runApp( DevicePreview(
      enabled: !kReleaseMode,
      builder: (context)=>MyApp(),
    ));
  } on AmplifyException catch (e) {
    runApp(Text("Error configuring Amplify: ${e.message}"));
  }
}
Future<void> _configureAmplify() async {
  try {
    final auth= AmplifyAuthCognito();
    final api = AmplifyAPI(
        options: APIPluginOptions(
            modelProvider: ModelProvider.instance
        )
    );
    await Amplify.addPlugins([auth,api]);
    await Amplify.configure(amplifyConfig);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FlutterSplashScreen(
        duration: const Duration(milliseconds: 2000),
        nextScreen: const Sign(),
        backgroundColor: Colors.white,
        setStateTimer: Duration(seconds: 6),
        splashScreenBody: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 200,
                child: Image.asset('assets/images/Emblem_of_Andhra_Pradesh.png'),
              ),
            ),
            SizedBox(height: 16,),
            Text('ATL Mentorship',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
