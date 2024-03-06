import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.textController,
    this.validator,
    this.isPassword = false,
    this.readOnly = false,
  });

  final String title;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool readOnly;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  String? errorText;
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          errorText = widget.validator!(widget.textController.text);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
            //style a TextFormField
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: widget.title,
            hintStyle: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: const Color(0xFF636363)),
            contentPadding: const EdgeInsets.all(10),
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    child: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xff232323),
                      size: 20,
                    ),
                    onTap: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )
                : null,
            errorText: errorText,
        ),
        validator: widget.validator,
        obscureText: widget.isPassword && _passwordVisible == false,
        controller: widget.textController,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
      ),
    );
  }
}
