import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/login/cubit/login_cubit.dart';
import 'package:budsy/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool onboardingShown = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance()
            .then((prefs) => prefs.getBool('onboardingComplete') ?? false),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data !=
                  true && // CHeck if bottom sheet is not already open
              ModalRoute.of(context)!.isCurrent &&
              onboardingShown == false) {
            print('onboarding not complete');
            // Make sure to not show this during the build process

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const OnboardingPage());

              setState(() {
                onboardingShown = true;
              });
            });
          }
          return Scaffold(
              body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Image.asset(
                      'assets/logo/app_icon.png',
                      height: 40,
                    ),
                  ),
                  const Gap(
                    size: 8,
                  ),
                  Text('Login',
                      style: Theme.of(context).textTheme.headlineLarge),
                  // const SizedBox(height: 16),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async =>
                        await context.read<LoginCubit>().signInWithGoogle(),
                    icon: PhosphorIcon(PhosphorIcons.googleLogo()),
                    label: const Text('Sign in with Google'),
                  ),
                ],
              ),
            ],
          ));
        });
  }
}
