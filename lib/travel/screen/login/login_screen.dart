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
  bool _checkbox = false;
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
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.pushNamedAndRemoveUntil(context, MainScreen.routeName, (route) => false);
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
                                Route route = MaterialPageRoute(
                                    builder: (context) => const ForgotScreen());
                                Navigator.push(context, route);
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
                            ),
                            CustomSmallButton(
                              title: 'Facebook',
                              imgLink: AppPath.iconFacebook,
                              color: const Color(0xff3C5A9A),
                              colorText: Colors.white,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => const SignUpScreen());
                            Navigator.push(context, route);
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

class CustomSmallButton extends StatelessWidget {
  const CustomSmallButton({
    super.key,
    required this.title,
    required this.imgLink,
    required this.color,
    required this.colorText,
  });

  final String title;
  final String imgLink;
  final Color color;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 155,
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 20,
                  width: 20,
                  child: Image.asset(
                    imgLink,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: TextStyle(
                  color: colorText,
                  fontSize: 16,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ],
          )),
    );
  }
}
