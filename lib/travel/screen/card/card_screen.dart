import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/card_model.dart';

import '../../../config/app_path.dart';
import '../../../config/validater.dart';
import '../../bloc/bloc.dart';
import '../../widget/widget.dart';
import 'components/card_number_item.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  static const String routeName = '/card';

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  late final TextEditingController countryController;
  final countryPicker = FlCountryCodePicker(
    title: Container(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: const Text(
          "Select your country",
        )),
  );
  CountryCode? countryCode = CountryCode.fromName('United States');
  late CardBloc _cardBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    countryController = TextEditingController(text: countryCode?.name);
    _cardBloc = CardBloc();
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
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      appBar: const CustomAppBar(
        titlePage: 'Add card',
        subTitlePage: '',
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  title: 'Name',
                  textController: nameController,
                  validator: validateName,
                ),
                CustomCardField(
                  cardController: cardController,
                  icon: AppPath.iconCard,
                  validator: validateCardNum,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 2 - 20,
                        child: CustomTextField(
                          title: 'Exp. Date',
                          textController: dateController,
                          validator: validateDate,
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 2 - 20,
                        child: CustomTextField(
                          title: 'CVV',
                          textController: cvvController,
                          validator: validateCVV,
                        )),
                  ],
                ),
                CustomCountryField(
                  countryController: countryController,
                  countryPicker: countryPicker,
                  chooseCountryCode: (CountryCode code) => chooseCountry(code),
                  validator: validateCountry,
                ),
                BlocProvider(
                  create: (context) => _cardBloc,
                  child: CustomButton(
                      title: 'Add card',
                      button: () {
                        if (_formKey.currentState!.validate()) {
                          CardModel card = CardModel(
                              name: nameController.text,
                              number: cardController.text,
                              expDate: dateController.text,
                              cvv: cvvController.text,
                              country: countryController.text);
                          _cardBloc.add(LoadCard(card: card));
                          Navigator.pop(context, card);
                        }
                        else{
                          Navigator.pop(context);
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
