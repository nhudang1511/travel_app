import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/screen/login/verify_email.dart';
import '../../../config/app_path.dart';
import '../../../config/validater.dart';
import '../../cubits/login/login_cubit.dart';
import '../../cubits/signup/signup_cubit.dart';
import '../../widget/widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routeName = '/sign_up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  late final TextEditingController countryController;
  final _formKey = GlobalKey<FormState>();
  final countryPicker = FlCountryCodePicker(
    title: Container(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: const Text(
          "Select your country",
        )),
  );
  CountryCode? countryCode = CountryCode.fromName('United States');
  late SignupCubit _signupCubit;
  late LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    countryController = TextEditingController(text: countryCode?.name);
    _signupCubit = BlocProvider.of(context);
    _loginCubit = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    void chooseCountry(CountryCode code) {
      setState(() {
        countryCode = code;
        countryController.text = code.name;
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        titlePage: 'Sign Up',
        subTitlePage: 'Let’s create your account!',
      ),
      body: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.success) {
            Navigator.pushNamed(context, VerifyEmailScreen.routeName);
          }
          else if(state.status == SignupStatus.error){
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
          else if(state.status == SignupStatus.emailExists){
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
                          title: 'Name',
                          textController: nameController,
                          validator: validateName,
                        ),
                        CustomCountryField(
                          countryController: countryController,
                          countryPicker: countryPicker,
                          chooseCountryCode: (CountryCode code) =>
                              chooseCountry(code),
                          validator: validateCountry,
                        ),
                        CustomPhoneField(
                          phoneController: phoneController,
                          countryPicker: countryPicker,
                          countryCode: countryCode,
                          chooseCountryCode: (CountryCode code) =>
                              chooseCountry(code),
                          validator: validatePhone,
                        ),
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
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        'By tapping sign up you agree to the ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            color: const Color(0xFF313131))),
                                TextSpan(
                                    text: ' Terms and Condition ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                            color: const Color(0xFF6155CC))),
                                TextSpan(
                                    text: 'and ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            color: const Color(0xFF313131))),
                                TextSpan(
                                    text: 'Privacy Policy',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                            color: const Color(0xFF6155CC))),
                                TextSpan(
                                    text: 'of this app',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            color: const Color(0xFF313131)))
                              ],
                            ),
                          ),
                        ),
                        CustomButton(
                          title: 'Sign Up',
                          button: () {
                            if (_formKey.currentState!.validate()) {
                              _signupCubit.emailChanged(emailController.text);
                              _signupCubit
                                  .passwordChanged(passwordController.text);
                              _signupCubit
                                  .phoneNumberChanged(phoneController.text);
                              _signupCubit.fullNameChanged(nameController.text);
                              _signupCubit
                                  .countryChanged(countryController.text);
                              _signupCubit.signUpWithEmailAndPassword();
                            }
                          },
                        ),
                        const CustomDriver(
                          title: 'or sign up with',
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
                                _loginCubit.logInWithGoogle();
                              },
                            ),
                            CustomSmallButton(
                              title: 'Facebook',
                              imgLink: AppPath.iconFacebook,
                              color: const Color(0xff3C5A9A),
                              colorText: Colors.white,
                              onPressed: () {
                                _loginCubit.logInWithGoogle();
                              },
                            ),
                          ],
                        ),
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
