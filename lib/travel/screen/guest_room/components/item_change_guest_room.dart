import 'package:flutter/material.dart';

import '../../../../config/image_helper.dart';

class ItemChangeGuestAndRoom extends StatefulWidget {
  const ItemChangeGuestAndRoom(
      {Key? key, this.initData = 0, required this.icon, required this.value})
      : super(key: key);

  final int initData;
  final String icon;
  final String value;

  @override
  State<ItemChangeGuestAndRoom> createState() => ItemChangeGuestAndRoomState();
}

class ItemChangeGuestAndRoomState extends State<ItemChangeGuestAndRoom> {
  late final TextEditingController _textEditingController;

  final FocusNode _focusNode = FocusNode();

  late int number;

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: widget.initData.toString())
          ..addListener(() {
            number = int.parse(_textEditingController.text);
          });
    number = widget.initData;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), color: Colors.white),
          margin: const EdgeInsets.only(bottom: 24.0),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ImageHelper.loadFromAsset(
                widget.icon,
              ),
              const SizedBox(
                width: 24.0,
              ),
              Text(
                widget.value,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.black),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  if (number > 1) {
                    setState(() {
                      number--;
                      _textEditingController.text = number.toString();
                      if (_focusNode.hasFocus) {
                        _focusNode.unfocus();
                      }
                    });
                  }
                },
                icon: const Icon(
                  Icons.remove_circle,
                  color: Color(0xFF3EC8BC),
                ),
              ),
              Container(
                height: 35,
                width: 60,
                padding: const EdgeInsets.only(left: 3),
                alignment: Alignment.center,
                child: TextField(
                  controller: _textEditingController,
                  textAlign: TextAlign.center,
                  focusNode: _focusNode,
                  enabled: true,
                  autocorrect: false,
                  minLines: 1,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      bottom: 18,
                    ),
                  ),
                  onChanged: (value) {},
                  onSubmitted: (String submitValue) {},
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    number++;
                    _textEditingController.text = number.toString();
                    if (_focusNode.hasFocus) {
                      _focusNode.unfocus();
                    }
                  });
                },
                icon: const Icon(
                  Icons.add_circle,
                  color: Color(0xFF3EC8BC),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
