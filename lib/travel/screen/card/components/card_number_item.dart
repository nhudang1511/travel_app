import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';

import '../../../../config/image_helper.dart';
import '../../../model/card_model.dart';
import 'card_util.dart';

class CustomCardField extends StatefulWidget {
  const CustomCardField({
    super.key,
    required this.cardController,
    this.validator, required this.icon,
  });

  final TextEditingController cardController;
  final String? Function(String?)? validator;
  final String icon;

  @override
  State<CustomCardField> createState() => _CustomCardFieldState();
}

class _CustomCardFieldState extends State<CustomCardField> {
  final FocusNode _focusNode = FocusNode();
  String? errorText;
  CardType cardType = CardType.Others;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          errorText = widget.validator!(widget.cardController.text);
        });
      }
    });
    if (widget.cardController.text.isNotEmpty) {
      _getCardTypeFrmNumber();
    }
  }
  void _getCardTypeFrmNumber() {
    String input = CardUtil.getCleanedNumber(widget.cardController.text);
    CardType cardType = CardUtil.getCardTypeFrmNumber(input);
    setState(() {
      this.cardType = cardType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child:  TextFormField(
        onChanged: (value) => {
          _getCardTypeFrmNumber(),
          getCardIcon(cardType)
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,    // allow only  digits
          CardNumberInputFormatter(),                // custom class to format entered data from textField
          LengthLimitingTextInputFormatter(22)       // restrict user to enter max 16 characters
        ],
        keyboardType: TextInputType.number,
        controller: widget.cardController,
        focusNode: _focusNode,
        //validator: widget.validator,
        textInputAction: TextInputAction.done,
        maxLines: 1,
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            labelText: 'Card Number',
            hintText: "Enter your card number",
            prefixIconConstraints: const BoxConstraints(),
            errorText: errorText,
            prefixIcon:  Container(
              margin: const EdgeInsets.all(10),
              child: ImageHelper.loadFromAsset(
                  getCardIcon(cardType),
                  width: 30
              ),
            ),
            filled: true,
            fillColor: Colors.white
        ),
      )
    );
  }
}
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

String getCardIcon (CardType? cardType){
  // var masterCardRegExp = RegExp(r'^5[1-5][0-9]{14}$');
  // var visaCardRegExp = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$');
  // var verveCardRegExp = RegExp(r'^((506(0|1))|(507(8|9))|(6500))[0-9]{12}$');

  // CardType getCardType(Car)

  String imgPath = "";
  switch (cardType) {
    case CardType.MasterCard:
      imgPath = AppPath.masterCard;
      break;
    case CardType.Visa:
      imgPath = AppPath.visaCard;
      break;
    case CardType.Verve:
      imgPath = AppPath.verveCard;
      break;
    case CardType.Others:
      imgPath = AppPath.card;
      break;
    default:
      imgPath = AppPath.card;
      break;
  }
  return imgPath;
}