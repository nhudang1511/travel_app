import 'dart:convert';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/travel/model/guest_model.dart';

import '../../../../config/validater.dart';
import '../../../widget/widget.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  static const String routeName = '/contact';

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final countryPicker = FlCountryCodePicker(
    title: Container(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: const Text(
          "Select your country",
        )),
  );
  CountryCode? countryCode = CountryCode.fromName('United States');
  List<Guest> guests = List.empty(growable: true);
  List<String> contactList = SharedService.getListContacts();

  @override
  void initState(){
    super.initState();
    if (contactList.isNotEmpty) {
      guests =
          contactList.map((e) => Guest.fromDocument(json.decode(e))).toList();
    }
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
        titlePage: 'Contact \nDetails',
        subTitlePage: '',
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                title: 'Name',
                textController: nameController,
                validator: validateName,
              ),
              CustomPhoneField(
                phoneController: phoneController,
                countryPicker: countryPicker,
                countryCode: countryCode,
                chooseCountryCode: (CountryCode code) => chooseCountry(code),
                validator: validatePhone,
              ),
              CustomTextField(
                title: 'Email',
                textController: emailController,
                validator: validateEmail,
              ),
              Text(
                'E-ticket will be sent to your E-mail',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color(0xFF636363)),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                  title: 'Done',
                  button: () {
                    String name = nameController.text;
                    String phone =  phoneController.text;
                    String email =  emailController.text;
                    String country = countryController.text;
                    if (name.isNotEmpty && phone.isNotEmpty && email.isNotEmpty && country.isNotEmpty) {
                      guests.add(Guest(name: name, email: email, country: country, phone: phone));
                      List<String> contactString = guests.map((e) => jsonEncode(e.toDocument())).toList();
                      SharedService.setListContacts(contactString);
                      Navigator.pop(context, guests);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
