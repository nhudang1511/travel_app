import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

class CustomCountryField extends StatefulWidget {
  const CustomCountryField({
    super.key,
    required this.countryController,
    required this.countryPicker,
    this.countryCode,
    required this.chooseCountryCode,
    this.validator,
  });

  final TextEditingController countryController;
  final FlCountryCodePicker countryPicker;
  final CountryCode? countryCode;
  final Function(CountryCode) chooseCountryCode;
  final String? Function(String?)? validator;

  @override
  State<CustomCountryField> createState() => _CustomCountryFieldState();
}

class _CustomCountryFieldState extends State<CustomCountryField> {
  final FocusNode _focusNode = FocusNode();
  String? errorText;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          errorText = widget.validator!(widget.countryController.text);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: InkWell(
        onTap: () async {
          final code = await widget.countryPicker.showPicker(
            context: context,
            scrollToDeviceLocale: true,
          );
          if (code != null) {
            widget.chooseCountryCode(code);
          }
        },
        child: TextFormField(
          enabled: false,
          keyboardType: TextInputType.text,
          controller: widget.countryController,
          decoration: InputDecoration(
              labelText: 'Country',
              border: InputBorder.none,
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down,
                size: 30,
                color: Color(0xff232323),
              ),
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: const Color(0xFF636363)),
              contentPadding: const EdgeInsets.all(10),
              errorText: errorText),
          focusNode: _focusNode,
        ),
      ),
    );
  }
}
