import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/cubits/cubit.dart';
import 'package:flutter_nhu_nguyen/travel/screen/login/login_screen.dart';

import '../../../config/app_path.dart';
import '../../widget/custom_button.dart';
import '../main_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  static const String routeName = '/verify';

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late SignupCubit _signupCubit;

  @override
  void initState() {
    super.initState();
    _signupCubit = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          print(state.status);
          if (state.status == SignupStatus.success) {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.routeName, (route) => false);
          }
        },
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Image.asset(AppPath.email),
                Text(
                  'Verify your email address',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.black),
                ),
                Text(
                  'We have just send email verification link on your email. '
                  'Please check email and click on that link to verify '
                  'your Email address. \nIf not auto redirected after '
                  'verification, click on the Resend Email button',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.black),
                ),
                CustomButton(
                  title: 'Resend Email',
                  button: () {
                    //_signupCubit.sendEmailVerification();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.routeName, (route) => false);
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
