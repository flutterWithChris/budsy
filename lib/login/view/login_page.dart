import 'dart:io';

import 'package:canjo/app/snackbars.dart';
import 'package:canjo/app/system/bottom_nav.dart';
import 'package:canjo/login/cubit/login_cubit.dart';
import 'package:canjo/onboarding/onboarding_page.dart';
import 'package:canjo/subscription/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
            // Make sure to not show this during the build process

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => const OnboardingPage())
                  .then((value) =>
                      context.read<SubscriptionBloc>().add(ShowPaywall()));

              setState(() {
                onboardingShown = true;
              });
            });
          }
          return BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              Navigator.of(context, rootNavigator: true).pop();
              if (state is LoginFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  getErrorSnackBar('Error logging in!')
                );
              }
              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  getSuccessSnackBar('Logged In')
                );
              }
            },
            child: Scaffold(
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
                Platform.isAndroid
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              if (state is LoginLoading) {
                                return FilledButton.icon(
                                  onPressed: () async => ScaffoldMessenger.of(
                                          context)
                                      .showSnackBar(getErrorSnackBar(
                                          'Please wait; Already logging in...')),
                                  icon:
                                      PhosphorIcon(PhosphorIcons.googleLogo()),
                                  label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        LoadingAnimationWidget.discreteCircle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 20.0),
                                        Gap(size: 8),
                                        const Text('Loging In...')
                                      ]),
                                );
                              }

                              return FilledButton.icon(
                                onPressed: () async => await context
                                    .read<LoginCubit>()
                                    .signInWithGoogle(),
                                icon: PhosphorIcon(PhosphorIcons.googleLogo()),
                                label: const Text('Sign in with Google'),
                              );
                            },
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              if (state is LoginLoading) {
                                return FilledButton.icon(
                                  onPressed: () async => ScaffoldMessenger.of(
                                          context)
                                      .showSnackBar(getErrorSnackBar(
                                          'Please wait; Already logging in...')),
                                  icon:
                                      PhosphorIcon(PhosphorIcons.googleLogo()),
                                  label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        LoadingAnimationWidget.discreteCircle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 20.0),
                                        Gap(size: 8),
                                        const Text('Loging In...')
                                      ]),
                                );
                              }
                              return FilledButton.icon(
                                onPressed: () async => await context
                                    .read<LoginCubit>()
                                    .signInWithApple(),
                                icon: PhosphorIcon(PhosphorIcons.appleLogo(PhosphorIconsStyle.fill)),
                                label: const Text('Sign in with Apple'),
                              );
                            },
                          ),
                        ],
                      )
              ],
            )),
          );
        });
  }
}
