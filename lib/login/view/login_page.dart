import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
  }
}
