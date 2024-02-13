import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

class CustomPhoneField extends StatefulWidget {
  const CustomPhoneField({
    super.key,
    required this.phoneController,
    required this.countryPicker,
    required this.countryCode,
    required this.chooseCountryCode, this.validator,
  });

  final TextEditingController phoneController;
  final FlCountryCodePicker countryPicker;
  final CountryCode? countryCode;
  final Function(CountryCode) chooseCountryCode;
  final String? Function(String?)? validator;

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {

  final FocusNode _focusNode = FocusNode();
  String? errorText;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          errorText = widget.validator!(widget.phoneController.text);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        maxLines: 1,
        controller: widget.phoneController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Enter your Phone Number",
          prefixIconConstraints: const BoxConstraints(),
          errorText: errorText,
          prefixIcon: InkWell(
            onTap: () async {
              final code = await widget.countryPicker.showPicker(
                context: context,
                scrollToDeviceLocale: true,
              );
              if (code != null) {
                widget.chooseCountryCode(code);
              }
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey)),
              ),
              child: Text(widget.countryCode?.dialCode ?? "+?", style: const TextStyle(color: Colors.black),),
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: const Color(0xFF636363)),
        ),
        focusNode: _focusNode,
      ),
    );
  }
}