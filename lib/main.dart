import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:atl_membership/screens/aboutscreen.dart';
import 'package:atl_membership/screens/achievementsscreen.dart';
import 'package:atl_membership/screens/attendancescreen.dart';
import 'package:atl_membership/screens/help_support.dart';
import 'package:atl_membership/screens/homescreen.dart';
import 'package:atl_membership/screens/mainscreen.dart';
import 'package:atl_membership/screens/profilescreen.dart';
import 'package:atl_membership/screens/resourcesscreen.dart';
import 'package:atl_membership/screens/jointeamscreen.dart';
import 'package:atl_membership/screens/schoolscreen.dart';
import 'package:atl_membership/screens/suggestionscreen.dart';
import 'package:atl_membership/screens/teamscreen.dart';
import 'package:atl_membership/utils/routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'amplify_outputs.dart';
import 'package:atl_membership/screens/personal_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(),
  ));
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyConfig);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      authenticatorBuilder: (context, state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return AuthScaffold(
              state: state,
              body: SignInForm(),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () => state.changeStep(AuthenticatorStep.signUp),
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.signUp:
            return AuthScaffold(
              state: state,
              body: SignUpForm.custom(fields: [
                SignUpFormField.name(required: true),
                SignUpFormField.email(required: true),
                SignUpFormField.phoneNumber(required: true),
                SignUpFormField.password(),
                SignUpFormField.passwordConfirmation(),

              ],
              ),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => state.changeStep(AuthenticatorStep.signIn),
                    child: const Text("Sign In"),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.confirmSignUp:
            return AuthScaffold(state: state, body: ConfirmSignUpForm());
          default:
            return null;
        }
      },
      child: GetMaterialApp(
        initialRoute: Routes.PERSONAL,
        getPages: [
          GetPage(name: Routes.PERSONAL, page: ()=> PersonalDetailsDialog()),
          GetPage(name: Routes.HOME, page: () => const MainScreen(), children: [
            GetPage(name: Routes.ATTENDANCE, page: () => Attendancescreen()),
            GetPage(name: Routes.HOME, page: () => Homescreen()),
            GetPage(name: Routes.RESOURCES, page: () => Resourcesscreen()),
            GetPage(name: Routes.JOINTEAM, page: () => JoinTeamscreen()),
            GetPage(name: Routes.TEAM, page: () => Teamscreen()),
            GetPage(name: Routes.PROFILE, page: () => Profilescreen()),
            GetPage(name: Routes.ABOUT, page: () => Aboutscreen()),
            GetPage(name: Routes.SCHOOL, page: () => Schoolscreen()),
            GetPage(name: Routes.ACHIEVEMENTS, page: () => Achievementsscreen()),
            GetPage(name: Routes.SUGGESTION, page: () => Suggestionscreen()),
            GetPage(name: Routes.HELP, page: () => HelpSupportscreen()),

          ]),
        ],
        theme: ThemeData(colorSchemeSeed: Colors.blue),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Authenticator.builder()(
            context,
            _AfterSignInWrapper(child: child!),
          );
        },
      ),
    );
  }
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.state,
    required this.body,
    this.footer,
  });

  final AuthenticatorState state;
  final Widget body;
  final Widget? footer;
  static const String assetName = 'assets/images/Emblem_of_Andhra_Pradesh.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Center(
                  child: Image.asset(assetName, height: 175, width: 175),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: body,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: footer != null ? [footer!] : null,
    );
  }
}

class _AfterSignInWrapper extends StatefulWidget {
  final Widget child;
  const _AfterSignInWrapper({required this.child});

  @override
  State<_AfterSignInWrapper> createState() => _AfterSignInWrapperState();
}

class _AfterSignInWrapperState extends State<_AfterSignInWrapper> {
  bool _dialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showPersonalDetailsDialogIfNeeded();
  }

  Future<void> _showPersonalDetailsDialogIfNeeded() async {
    try {
      final authSession = await Amplify.Auth.fetchAuthSession();
      if (authSession.isSignedIn && !_dialogShown) {
        _dialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const PersonalDetailsDialog(),
          );
        });
      }
    } catch (e) {
      safePrint('Error fetching auth session: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
