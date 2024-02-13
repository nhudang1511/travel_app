import 'package:flutter/material.dart';

import '../../../widget/widget.dart';
import 'check_item.dart';

class PropertyScreen extends StatefulWidget {
  const PropertyScreen({super.key});

  static const String routeName = '/property';

  @override
  State<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  bool _selectAll =
      false; // Add a new state to control "Select All" functionality

  List<bool> _checkboxList = List.generate(7,
      (index) => false); // Maintain a list of checkboxes for individual items
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        titlePage: 'Property Type',
        subTitlePage: '',
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        _selectAll = !_selectAll;
                        _checkboxList = List.generate(8, (index) => _selectAll);
                      });
                    },
                    child: Text('Select All',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: const Color(0xFF6155CC)))),
                const SizedBox(
                  height: 20,
                ),
                CheckItem(
                  checkbox: _checkboxList[0],
                  title: 'Hotels',
                  radius: 4,
                  onToggle: () {
                    setState(() {
                      _checkboxList[0] = !_checkboxList[0];
                    });
                  },
                ),
                CheckItem(
                  checkbox: _checkboxList[1],
                  title: 'Resorts',
                  radius: 4,
                  onToggle: () {
                    setState(() {
                      _checkboxList[1] = !_checkboxList[1];
                    });
                  },
                ),
                CheckItem(
                  checkbox: _checkboxList[2],
                  title: 'Villas',
                  radius: 4,
                  onToggle: () {
                    setState(() {
                      _checkboxList[2] = !_checkboxList[2];
                    });
                  },
                ),
                CheckItem(
                  checkbox: _checkboxList[3],
                  title: 'Guest Houses',
                  radius: 4,
                  onToggle: () {
                    setState(() {
                      _checkboxList[3] = !_checkboxList[3];
                    });
                  },
                ),
                CheckItem(
                  checkbox: _checkboxList[4],
                  title: 'Homestays',
                  radius: 4,
                  onToggle: () {
                    setState(() {
                      _checkboxList[4] = !_checkboxList[4];
                    });
                  },
                ),
                CheckItem(
                  checkbox: _checkboxList[5],
                  title: 'Apartments',
                  radius: 4,
                  onToggle: () {
                    setState(() {
                      _checkboxList[5] = !_checkboxList[5];
                    });
                  },
                ),
                CheckItem(
                  checkbox: _checkboxList[6],
                  title: 'Others',
                  radius: 4,
                  onToggle: () {
                    setState(() {
                      _checkboxList[6] = !_checkboxList[6];
                    });
                  },
                ),
              ],
            ),
            CustomButton(title: 'Done', button: () {})
          ],
        ),
      ),
    );
  }
}
