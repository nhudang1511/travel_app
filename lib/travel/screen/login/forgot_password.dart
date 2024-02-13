import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/validater.dart';
import 'package:flutter_nhu_nguyen/travel/cubits/forgotPassword/forgotPassword_cubit.dart';
import '../../widget/widget.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        titlePage: 'Forgot Password',
        subTitlePage: 'You’ll get messages soon on your e-mail address',
      ),
      body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if(state.status == ForgotPasswordStatus.success){
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
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
                        CustomButton(
                          title: 'Send',
                          button: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ForgotPasswordCubit>().emailChanged(
                                  emailController.text);
                              context.read<ForgotPasswordCubit>()
                                  .forgotPassword();
                            }
                          },
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

