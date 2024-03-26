import 'dart:typed_data';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/firebase.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/config/utils.dart';
import 'package:flutter_nhu_nguyen/config/validater.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/auth/auth_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/user/user_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/user_model.dart';
//import 'package:flutter_nhu_nguyen/travel/repository/authentication_repository.dart';
//import 'package:flutter_nhu_nguyen/travel/repository/user_repository.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_button.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_country_field.dart';
//import 'package:flutter_nhu_nguyen/travel/widget/custom_inkwell.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_phone_field.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

import '../../widget/custom_appbar_item.dart';

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({Key? key}) : super(key: key);
  static const String routeName = '/edit_profile';
  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  late UserBloc _userBloc;
  late AuthBloc _authBloc;
  Uint8List? _images;
  //Uint8List? _images = SharedService.getAvatar();

  String? email = SharedService.getEmail();
  String? name = SharedService.getName();
  String? phone = SharedService.getPhone();
  String? country = SharedService.getCountry();
  String? password = SharedService.getPassword();
  String? avatar = SharedService.getAvatar();

  // Set edit controller for fiels
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController countryController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();
  final countryPicker = FlCountryCodePicker(
    title: Container(
      padding: const EdgeInsets.only(left: 20, top: 10),
      child:  const Text("Select your country"),
    )
  );
  CountryCode? countryCode = CountryCode.fromName(SharedService.getCountry());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    countryController = TextEditingController(text: countryCode?.name);
    nameController = TextEditingController(text: SharedService.getName());
    phoneController = TextEditingController(text: SharedService.getPhone());
    emailController = TextEditingController(text: SharedService.getEmail());
    passwordController = TextEditingController(text: SharedService.getPassword());
    //Cubits
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _images = img;
    });
  }

  Future<String> saveImage() async {
    return await StoreData().uploadImageToStorage("profileImage", _images.hashCode.toString(), _images!);
  }

  @override
  Widget build(BuildContext context) {
    void chooseCountry(CountryCode code) {
      setState(() {
        countryCode = code;
        countryController.text = code.name;
      });
    }

    return CustomAppBarItem(
      title: 'Your Profile',
      isIcon: false,
      isFirst: true,
      showModalBottomSheet: () {},
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Stack(

                  children: [
                    _images != null ?
                        CircleAvatar(
                          radius: 53,
                          backgroundColor: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(_images!),
                          ),
                        ) :
                    CircleAvatar(
                      radius: 53,
                      backgroundColor: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      child: ( avatar != "") ?
                      CircleAvatar(
                        backgroundImage: NetworkImage(avatar!),
                        radius: 50,
                      ) :
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        child: ClipOval(
                          child: Icon(
                            Icons.person, size: 80, color: Color(0xFF8F67E8),),
                        ),
                      ),
                    ),
                    Positioned(
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                      bottom: -12,
                      left: 63,
                    )
                  ],
                ),
                //name
                Text(
                  name ?? 'no name',
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: Colors.black),
                ),
                SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        title: "Name",
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
                        readOnly: true,
                      ),
                      CustomTextField(
                        title: 'Password',
                        textController: passwordController,
                        validator: validatePassword,
                        isPassword: true,
                        readOnly: true,
                      ),
                      CustomButton(
                        title: 'Save Profile',
                        button: () async {
                          String image = await saveImage();
                          print(image);
                          User user = User(id: SharedService.getUserId() ?? '', name: nameController.text, country: countryController.text, phone: emailController.text, avatar: image);
                          _userBloc.add(UpdateUser(user));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
