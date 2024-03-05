import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/cubits/login/login_cubit.dart';
import 'package:flutter_nhu_nguyen/travel/screen/login/forgot_password.dart';
import 'package:flutter_nhu_nguyen/travel/screen/login/signup_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/main_screen.dart';
import '../../../config/app_path.dart';
import '../../../config/validater.dart';
import '../../widget/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //LoginCubit? _loginCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        titlePage: 'Login',
        subTitlePage: 'Hi, Welcome back!',
        isFirst: true,
      ),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state.status == LoginStatus.success) {
            Navigator.pushNamedAndRemoveUntil(context, MainScreen.routeName, (route) => false);
          }
          else if(state.status == LoginStatus.error){
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              headerAnimationLoop: false,
              title: 'Error',
              desc:
              '${state.status}',
              descTextStyle: const TextStyle(color: Colors.black),
              btnOkOnPress: () {},
              btnOkIcon: Icons.cancel,
              btnOkColor: Colors.red,
            ).show();
          }
          else if(state.status == LoginStatus.emailDiffProvider){
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.rightSlide,
              headerAnimationLoop: false,
              title: 'Warning',
              desc:
              '${state.status}',
              descTextStyle: const TextStyle(color: Colors.black),
              btnOkOnPress: () {},
              btnOkIcon: Icons.cancel,
              btnOkColor: Colors.yellow,
            ).show();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          title: 'Email',
                          textController: emailController,
                          validator: validateEmail,
                        ),
                        CustomTextField(
                          title: 'Password',
                          textController: passwordController,
                          validator: validatePassword,
                          isPassword: true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, ForgotScreen.routeName);
                              },
                              child: Text('Forgot password?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                      color: const Color(0xFF313131))),
                            ),
                          ],
                        ),
                        CustomButton(
                          title: 'Log in',
                          button: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<LoginCubit>()
                                  .emailChanged(emailController.text);
                              context
                                  .read<LoginCubit>()
                                  .passwordChanged(passwordController.text);
                              context.read<LoginCubit>().logInWithCredentials();
                            }
                          },
                        ),
                        const CustomDriver(
                          title: 'or log in with',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomSmallButton(
                              title: 'Google',
                              imgLink: AppPath.iconGoogle,
                              color: Colors.white,
                              colorText: Colors.black,
                              onPressed: () {
                                context.read<LoginCubit>().logInWithGoogle();
                              },
                            ),
                            CustomSmallButton(
                              title: 'Facebook',
                              imgLink: AppPath.iconFacebook,
                              color: const Color(0xff3C5A9A),
                              colorText: Colors.white, onPressed: () {
                              context.read<LoginCubit>().logInWithFacebook();
                            },
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignUpScreen.routeName);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Don’t have an account? ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                          color: const Color(0xFF313131))),
                                  TextSpan(
                                      text: 'Sign Up',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                          color: const Color(0xFF6155CC))),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}


